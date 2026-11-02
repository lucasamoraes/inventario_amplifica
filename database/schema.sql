SET NAMES utf8mb4;

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
CREATE TABLE companies (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
 name VARCHAR(160) NOT NULL, slug VARCHAR(80) NOT NULL UNIQUE,
 logo_path VARCHAR(255) NULL, primary_color CHAR(7) NOT NULL DEFAULT '#173F73', accent_color CHAR(7) NOT NULL DEFAULT '#F3B61F',
 critical_year_before SMALLINT NOT NULL DEFAULT 2019, critical_ram_below SMALLINT NOT NULL DEFAULT 8,
 attention_score_threshold TINYINT UNSIGNED NOT NULL DEFAULT 1, critical_score_threshold TINYINT UNSIGNED NOT NULL DEFAULT 3,
 ssd_mitigation_points TINYINT UNSIGNED NOT NULL DEFAULT 1,
 active TINYINT(1) NOT NULL DEFAULT 1, created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE users (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, company_id BIGINT UNSIGNED NOT NULL,
 name VARCHAR(160) NOT NULL, email VARCHAR(190) NOT NULL, password_hash VARCHAR(255) NOT NULL,
 role ENUM('employee','it','manager') NOT NULL DEFAULT 'employee', active TINYINT(1) NOT NULL DEFAULT 1,
 failed_attempts TINYINT UNSIGNED NOT NULL DEFAULT 0, locked_until DATETIME NULL, last_login_at DATETIME NULL,
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 UNIQUE KEY uq_company_email(company_id,email), CONSTRAINT fk_users_company FOREIGN KEY(company_id) REFERENCES companies(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE computers (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, company_id BIGINT UNSIGNED NOT NULL,
 collected_at DATETIME NULL, computer_name VARCHAR(120) NOT NULL, sector VARCHAR(140) NULL, assigned_user VARCHAR(160) NULL,
 manufacturer VARCHAR(100) NULL, model VARCHAR(160) NULL, manufacture_year SMALLINT NULL, service_tag VARCHAR(120) NULL,
 processor VARCHAR(255) NULL, ram_gb SMALLINT NULL, ram_slots_detail VARCHAR(255) NULL,
 windows_version VARCHAR(160) NULL, local_ip VARCHAR(45) NULL, mac_address VARCHAR(30) NULL, location VARCHAR(140) NULL,
 asset_status VARCHAR(80) NOT NULL DEFAULT 'Em uso', notes TEXT NULL,
 created_by BIGINT UNSIGNED NULL, updated_by BIGINT UNSIGNED NULL, created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 KEY ix_company_computer(company_id,computer_name), KEY ix_company_sector(company_id,sector), KEY ix_company_user(company_id,assigned_user),
 CONSTRAINT fk_computers_company FOREIGN KEY(company_id) REFERENCES companies(id) ON DELETE CASCADE,
 CONSTRAINT fk_computers_created FOREIGN KEY(created_by) REFERENCES users(id) ON DELETE SET NULL,
 CONSTRAINT fk_computers_updated FOREIGN KEY(updated_by) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE catalog_items (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, company_id BIGINT UNSIGNED NOT NULL,
 catalog_type ENUM('sector','location','asset_status') NOT NULL, name VARCHAR(140) NOT NULL, active TINYINT(1) NOT NULL DEFAULT 1,
 created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
 UNIQUE KEY uq_catalog_item(company_id,catalog_type,name),
 CONSTRAINT fk_catalog_company FOREIGN KEY(company_id) REFERENCES companies(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE disks (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, computer_id BIGINT UNSIGNED NOT NULL,
 disk_type ENUM('SSD','HDD','NVMe','Outro') NOT NULL, brand_model VARCHAR(190) NULL, size_gb INT UNSIGNED NULL,
 CONSTRAINT fk_disks_computer FOREIGN KEY(computer_id) REFERENCES computers(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE custom_fields (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, company_id BIGINT UNSIGNED NOT NULL, name VARCHAR(120) NOT NULL,
 field_key VARCHAR(120) NOT NULL, field_type ENUM('text','number','date','select','textarea') NOT NULL DEFAULT 'text', options_json JSON NULL,
 required TINYINT(1) NOT NULL DEFAULT 0, active TINYINT(1) NOT NULL DEFAULT 1, sort_order SMALLINT NOT NULL DEFAULT 0,
 UNIQUE KEY uq_company_field(company_id,field_key), CONSTRAINT fk_custom_company FOREIGN KEY(company_id) REFERENCES companies(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE custom_field_values (
 computer_id BIGINT UNSIGNED NOT NULL, custom_field_id BIGINT UNSIGNED NOT NULL, value_text TEXT NULL,
 PRIMARY KEY(computer_id,custom_field_id), CONSTRAINT fk_value_computer FOREIGN KEY(computer_id) REFERENCES computers(id) ON DELETE CASCADE,
 CONSTRAINT fk_value_field FOREIGN KEY(custom_field_id) REFERENCES custom_fields(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE audit_logs (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, company_id BIGINT UNSIGNED NOT NULL, user_id BIGINT UNSIGNED NULL,
 action VARCHAR(40) NOT NULL, entity_type VARCHAR(60) NOT NULL, entity_id BIGINT UNSIGNED NULL, details_json JSON NULL,
 ip_address VARCHAR(45) NULL, created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, KEY ix_audit_company(company_id,created_at),
 CONSTRAINT fk_audit_company FOREIGN KEY(company_id) REFERENCES companies(id) ON DELETE CASCADE,
 CONSTRAINT fk_audit_user FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE login_attempts (
 id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY, email VARCHAR(190) NULL, ip_address VARCHAR(45) NOT NULL,
 succeeded TINYINT(1) NOT NULL DEFAULT 0, attempted_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, KEY ix_login_ip(ip_address,attempted_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
