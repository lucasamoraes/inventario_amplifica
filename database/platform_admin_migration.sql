CREATE TABLE IF NOT EXISTS platform_admins (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(160) NOT NULL,
  email VARCHAR(190) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  active TINYINT(1) NOT NULL DEFAULT 1,
  must_change_password TINYINT(1) NOT NULL DEFAULT 1,
  last_login_at DATETIME NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO platform_admins(name,email,password_hash,active,must_change_password)
VALUES ('Lucas Moraes','lucas.moraes@amplificati.com.br','$2y$10$Ip.rGIXcmCgM5u9WJFpr6eTnOUl3g0TKRZBdXJo.Jhrld/uM4mBRG',1,1)
ON DUPLICATE KEY UPDATE name=VALUES(name),active=1;

