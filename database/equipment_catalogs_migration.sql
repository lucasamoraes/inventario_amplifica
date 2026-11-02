ALTER TABLE computers
  ADD COLUMN ram_sticks_count TINYINT UNSIGNED NULL AFTER ram_gb,
  ADD COLUMN ram_per_stick_gb SMALLINT UNSIGNED NULL AFTER ram_sticks_count;

ALTER TABLE catalog_items
  MODIFY catalog_type ENUM('sector','location','asset_status','windows_version') NOT NULL;

UPDATE computers
SET asset_status='Em manutenção'
WHERE asset_status LIKE 'Em manuten%' AND asset_status<>'Em manutenção';

DELETE FROM catalog_items
WHERE catalog_type='asset_status'
  AND name LIKE 'Em manuten%'
  AND name<>'Em manutenção';

INSERT IGNORE INTO catalog_items(company_id,catalog_type,name)
SELECT id,'asset_status','Em uso' FROM companies;
INSERT IGNORE INTO catalog_items(company_id,catalog_type,name)
SELECT id,'asset_status','Reserva' FROM companies;
INSERT IGNORE INTO catalog_items(company_id,catalog_type,name)
SELECT id,'asset_status','Em manutenção' FROM companies;
INSERT IGNORE INTO catalog_items(company_id,catalog_type,name)
SELECT id,'asset_status','Baixado' FROM companies;

INSERT IGNORE INTO catalog_items(company_id,catalog_type,name)
SELECT company_id,'windows_version',windows_version
FROM computers
WHERE windows_version IS NOT NULL AND windows_version<>'';

INSERT IGNORE INTO catalog_items(company_id,catalog_type,name)
SELECT id,'windows_version','Windows 10 Pro' FROM companies;
INSERT IGNORE INTO catalog_items(company_id,catalog_type,name)
SELECT id,'windows_version','Windows 11 Pro' FROM companies;

UPDATE computers
SET ram_sticks_count=1,ram_per_stick_gb=ram_gb
WHERE ram_slots_detail LIKE '1 pente%' AND ram_gb IS NOT NULL;

UPDATE computers
SET ram_sticks_count=2,ram_per_stick_gb=ram_gb/2
WHERE ram_slots_detail LIKE '2 pente%' AND ram_gb IS NOT NULL AND MOD(ram_gb,2)=0;

