<?php
declare(strict_types=1);

$configFile = dirname(__DIR__) . '/config.php';
if (!is_file($configFile)) { http_response_code(500); exit('Copie config.example.php para config.php e configure o banco.'); }
try {
    $config = require $configFile;
} catch (Throwable $error) {
    error_log('Inventario: config.php invalido - '.$error->getMessage());
    http_response_code(500);
    exit('O arquivo config.php possui um erro de sintaxe. Revise aspas, virgulas e a senha do banco.');
}
if(!is_array($config)||empty($config['app'])||empty($config['db'])){http_response_code(500);exit('O arquivo config.php esta incompleto.');}
date_default_timezone_set($config['app']['timezone'] ?? 'America/Sao_Paulo');
$secure = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off');
session_name($config['app']['session_name'] ?? 'inventory_session');
session_set_cookie_params(['lifetime'=>0,'path'=>'/','secure'=>$secure,'httponly'=>true,'samesite'=>'Lax']);
session_start();
header('X-Frame-Options: SAMEORIGIN');
header('X-Content-Type-Options: nosniff');
header('Referrer-Policy: strict-origin-when-cross-origin');
header('X-Robots-Tag: noindex, nofollow, noarchive');

function config(?string $key=null): mixed { global $config; if ($key===null) return $config; $v=$config; foreach(explode('.',$key) as $p) $v=$v[$p]??null; return $v; }
function base_path(): string {
    $configured=rtrim((string)(parse_url((string)config('app.url'),PHP_URL_PATH)??''),'/');
    $request=(string)(parse_url($_SERVER['REQUEST_URI']??'/',PHP_URL_PATH)??'/');
    if($configured!==''&&$request!==$configured&&!str_starts_with($request,$configured.'/')) return '';
    return $configured;
}
function app_url(string $path='/'): string { $path='/'.ltrim($path,'/'); return base_path().($path==='/'?'/':$path); }
function db(): PDO { static $pdo; if($pdo) return $pdo; $d=config('db'); $dsn="mysql:host={$d['host']};port={$d['port']};dbname={$d['name']};charset={$d['charset']}"; return $pdo=new PDO($dsn,$d['user'],$d['pass'],[PDO::ATTR_ERRMODE=>PDO::ERRMODE_EXCEPTION,PDO::ATTR_DEFAULT_FETCH_MODE=>PDO::FETCH_ASSOC,PDO::ATTR_EMULATE_PREPARES=>false]); }
function e(mixed $v): string { return htmlspecialchars((string)$v,ENT_QUOTES,'UTF-8'); }
function csrf(): string { if(empty($_SESSION['csrf'])) $_SESSION['csrf']=bin2hex(random_bytes(32)); return $_SESSION['csrf']; }
function verify_csrf(): void { if(!hash_equals($_SESSION['csrf']??'',$_POST['_token']??'')){http_response_code(419);exit('Sessão expirada. Atualize a página.');} }
function redirect(string $path): never { header('Location: '.(str_starts_with($path,'/')?app_url($path):$path)); exit; }
function flash(string $type,string $message): void { $_SESSION['flash']=[$type,$message]; }
function user(): ?array { return $_SESSION['user']??null; }
function company(): ?array { return $_SESSION['company']??null; }
function require_auth(): void { if(!user()) redirect('/login'); }
function can_manage(): bool { return in_array(user()['role']??'', ['it','manager'],true); }
function require_manage(): void { require_auth(); if(!can_manage()){http_response_code(403);exit('Acesso negado.');} }
function tenant_id(): int { return (int)(user()['company_id']??0); }
function query(string $sql,array $params=[]): PDOStatement { $s=db()->prepare($sql);$s->execute($params);return $s; }
function audit(string $action,string $entityType,?int $entityId=null,array $details=[]): void { query('INSERT INTO audit_logs(company_id,user_id,action,entity_type,entity_id,details_json,ip_address) VALUES(?,?,?,?,?,?,?)',[tenant_id(),user()['id']??null,$action,$entityType,$entityId,json_encode($details,JSON_UNESCAPED_UNICODE),$_SERVER['REMOTE_ADDR']??null]); }
function verify_captcha(string $token,string $expectedAction='company_login'): bool {
    $secret=(string)config('captcha.secret_key');
    if($secret==='') return config('app.env')!=='production';
    if($token==='') return false;
    $payload=http_build_query(['secret'=>$secret,'response'=>$token,'remoteip'=>$_SERVER['REMOTE_ADDR']??'']);$raw=false;
    if(function_exists('curl_init')){$curl=curl_init('https://www.google.com/recaptcha/api/siteverify');curl_setopt_array($curl,[CURLOPT_POST=>true,CURLOPT_POSTFIELDS=>$payload,CURLOPT_RETURNTRANSFER=>true,CURLOPT_TIMEOUT=>8,CURLOPT_HTTPHEADER=>['Content-Type: application/x-www-form-urlencoded']]);$raw=curl_exec($curl);curl_close($curl);}
    if(!$raw){$ctx=stream_context_create(['http'=>['method'=>'POST','header'=>'Content-Type: application/x-www-form-urlencoded','content'=>$payload,'timeout'=>8]]);$raw=@file_get_contents('https://www.google.com/recaptcha/api/siteverify',false,$ctx);}
    if(!$raw)return false;$result=json_decode($raw,true);$minimum=(float)(config('captcha.min_score')??0.5);
    return !empty($result['success'])&&($result['action']??'')===$expectedAction&&(float)($result['score']??0)>=$minimum;
}
function criticality(array $pc,array $disks): array {
    if(!array_key_exists('critical_score_threshold',company()??[])) refresh_company();$settings=company()??[];
    $reasons=[];$score=0;$year=(int)($pc['manufacture_year']??0);$ram=(int)($pc['ram_gb']??0);$cpu=strtolower($pc['processor']??'');$win=strtolower($pc['windows_version']??'');
    if($year && $year<(int)($settings['critical_year_before']??2019)){ $reasons[]="Fabricação antiga ({$year})";$score++; }
    if($ram && $ram<(int)($settings['critical_ram_below']??8)){ $reasons[]="Memória insuficiente ({$ram} GB)";$score++; }
    if(preg_match('/\b(i3|celeron|pentium|atom)\b/i',$cpu)||preg_match('/i[357]-([1-7]\d{3}|\d{3})\b/i',$cpu)){ $reasons[]='Processador antigo ou de entrada';$score++; }
    if(str_contains($win,'windows 7')||str_contains($win,'windows 8')||str_contains($win,'windows 10')){ $reasons[]='Windows sem ciclo regular de suporte';$score++; }
    // SSD ou NVMe sempre é considerado o armazenamento principal. Um HDD adicional é tratado apenas como unidade secundária.
    $diskTypes=array_column($disks,'disk_type');
    $hasFastPrimary=(bool)array_intersect(['SSD','NVMe'],$diskTypes);
    $hasHdd=in_array('HDD',$diskTypes,true);
    if($hasHdd&&!$hasFastPrimary){ $reasons[]='Somente HDD';$score++; }
    if($hasFastPrimary&&$score>0){ $score=max(1,$score-(int)($settings['ssd_mitigation_points']??1));$reasons[]='SSD/NVMe reduz a prioridade do risco'; }
    $criticalAt=(int)($settings['critical_score_threshold']??3);$attentionAt=(int)($settings['attention_score_threshold']??1);
    $level=$score>=$criticalAt?'critical':($score>=$attentionAt?'attention':'ok'); return ['level'=>$level,'reasons'=>$reasons,'score'=>$score];
}
function refresh_company(): void { if(user()) $_SESSION['company']=query('SELECT * FROM companies WHERE id=?',[tenant_id()])->fetch(); }
function page_start(string $title,string $active=''): void { $u=user();$c=company();$flash=$_SESSION['flash']??null;unset($_SESSION['flash']);$logo=$c['logo_path']??'';$primary=$c['primary_color']??'#173F73';$accent=$c['accent_color']??'#F3B61F';ob_start(fn(string $html):string=>base_path()===''?$html:preg_replace('/\\b(href|src|action)="\\/(?!\\/)/','$1="'.base_path().'/', $html)); ?>
<!doctype html><html lang="pt-BR"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="robots" content="noindex,nofollow,noarchive"><title><?=e($title)?> · <?=e($c['name']??config('app.name'))?></title><link rel="stylesheet" href="/assets/app.css"><style>:root{--brand:<?=e($primary)?>;--accent:<?=e($accent)?>}</style></head><body><div class="shell"><aside class="sidebar"><div class="brand"><?php if($logo):?><img src="<?=e($logo)?>" alt=""><?php endif?><strong><?=e($c['name']??'Inventário')?></strong></div><nav class="nav"><a class="<?=$active==='dashboard'?'active':''?>" href="/">Dashboard</a><a class="<?=$active==='computers'?'active':''?>" href="/computers">Computadores</a><a class="<?=$active==='critical'?'active':''?>" href="/critical">Criticidade</a><a class="<?=$active==='reports'?'active':''?>" href="/reports">Relatórios</a><?php if(can_manage()):?><a class="<?=$active==='catalogs'?'active':''?>" href="/catalogs">Cadastros</a><a class="<?=$active==='users'?'active':''?>" href="/users">Usuários</a><a class="<?=$active==='fields'?'active':''?>" href="/fields">Campos extras</a><a class="<?=$active==='settings'?'active':''?>" href="/settings">Empresa</a><?php endif?><a href="/logout">Sair</a></nav></aside><div class="sidebar-overlay" data-menu-close></div><main><div class="topbar"><div class="topbar-title"><button class="menu-toggle" type="button" data-menu-toggle aria-label="Recolher ou abrir menu"><span></span><span></span><span></span></button><div><h1><?=e($title)?></h1><span class="muted"><?=e($u['name']??'')?> · <?=e(['employee'=>'Funcionário','it'=>'TI','manager'=>'Gerência'][$u['role']??'']??'')?></span></div></div></div><?php if($flash):?><div class="alert <?=$flash[0]==='error'?'error':''?>"><?=e($flash[1])?></div><?php endif?>
<?php }
function page_end(): void { ?><div id="confirm-modal" class="modal-backdrop"><div class="modal"><h3>Confirmar ação</h3><p data-message></p><div class="actions"><button class="btn" data-yes>Sim, confirmar</button><button class="btn secondary" data-no>Cancelar</button></div></div></div><script>window.APP_BASE=<?=json_encode(base_path(),JSON_UNESCAPED_SLASHES)?>;</script><script src="/assets/app.js"></script></main></div></body></html><?php ob_end_flush(); }

