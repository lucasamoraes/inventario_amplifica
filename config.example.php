<?php
return [
    'app' => [
        'name' => 'Inventário Amplificati',
        'url' => 'https://inventario.amplificati.com.br',
        'env' => 'production',
        'session_name' => 'amplificati_inventory',
        'timezone' => 'America/Sao_Paulo',
    ],
    'db' => [
        'host' => 'localhost',
        'port' => 3306,
        'name' => 'inventario_amplificati',
        'user' => 'inventario_user',
        'pass' => 'ALTERE_AQUI',
        'charset' => 'utf8mb4',
    ],
    'captcha' => [
        // Cloudflare Turnstile. Deixe vazio em desenvolvimento local.
        'site_key' => '',
        'secret_key' => '',
    ],
];

