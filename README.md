# Inventário Amplificati

## Publicação pela hospedagem

1. Aponte o domínio ou subdomínio para a pasta `public` do projeto.
2. Crie o banco MySQL/MariaDB pelo painel da hospedagem.
3. Importe `database/hosting_database.sql` pelo phpMyAdmin.
4. Copie `config.example.php` para `config.php` e informe a URL e as credenciais do banco da hospedagem.
5. Mantenha `config.php` fora do Git, pois ele contém dados de acesso.

O arquivo `hosting_database.sql` contém a estrutura e os dados atuais do ambiente local. Importe-o apenas em um banco vazio para evitar registros duplicados.

Sistema PHP 8.1+ e MySQL/MariaDB para inventário multiempresas.

## Publicação

1. Crie o banco no phpMyAdmin e importe `database/schema.sql`.
2. Copie `config.example.php` para `config.php` e informe banco, URL e chaves do Cloudflare Turnstile.
3. Aponte a raiz do subdomínio para a pasta `public/`.
4. Garanta escrita em `storage/uploads/`.
5. Crie a primeira empresa via SSH: `php scripts/create_company.php "Colégio CAVE" cave "Administrador" email@dominio.com "senha-forte"`.
6. Importe `database/cave_inventory.sql` depois de substituir `@CAVE_COMPANY_ID` pelo ID criado.

## Perfis

- Funcionário: cadastra e edita computadores; não exclui.
- TI e Gerência: CRUD completo, usuários, campos extras, identidade visual e critérios.
- Todos os registros operacionais são isolados por `company_id`.

## Segurança

Turnstile, CSRF, prepared statements, password_hash, bloqueio após tentativas, rate limit por IP, cookies HttpOnly/SameSite, trilha de auditoria, cabeçalhos de segurança e `noindex`.

