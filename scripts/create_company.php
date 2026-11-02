<?php
if(PHP_SAPI!=='cli')exit("Execute no terminal.\n");
require dirname(__DIR__).'/app/bootstrap.php';
[$script,$company,$slug,$name,$email,$password]=$argv+[null,null,null,null,null,null];
if(!$password||strlen($password)<10)exit("Uso: php scripts/create_company.php \"Empresa\" slug \"Administrador\" email senha-com-10-caracteres\n");
db()->beginTransaction();
try{query('INSERT INTO companies(name,slug) VALUES(?,?)',[$company,$slug]);$cid=(int)db()->lastInsertId();query('INSERT INTO users(company_id,name,email,password_hash,role) VALUES(?,?,?,?,\'manager\')',[$cid,$name,strtolower($email),password_hash($password,PASSWORD_DEFAULT)]);db()->commit();echo "Empresa e administrador criados. ID: $cid\n";}catch(Throwable $e){db()->rollBack();fwrite(STDERR,$e->getMessage()."\n");exit(1);}

