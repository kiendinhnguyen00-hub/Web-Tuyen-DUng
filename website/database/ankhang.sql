-- =============================================================================
-- Tuyển Dụng An Khang — Database MySQL / MariaDB
-- =============================================================================
-- CÁCH IMPORT TRÊN HOST (cPanel):
-- 1. Tạo database + user MySQL trong cPanel → MySQL Databases
-- 2. Ghi lại: tên DB, username, password, host (thường là localhost)
-- 3. Mở phpMyAdmin → chọn database vừa tạo → tab Import → chọn file này → Go
--
-- LƯU Ý: Nhiều host KHÔNG cho phép CREATE DATABASE qua SQL.
--         Nếu lỗi dòng CREATE DATABASE, hãy xóa/comment 2 dòng đó và import lại
--         sau khi đã chọn đúng database trong phpMyAdmin.
-- =============================================================================

SET NAMES utf8mb4;
SET time_zone = '+07:00';
SET FOREIGN_KEY_CHECKS = 0;

-- Đổi tên nếu host đã cấp sẵn (vd: cpaneluser_ankhang)
CREATE DATABASE IF NOT EXISTS `ankhang_db`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `ankhang_db`;

-- -----------------------------------------------------------------------------
-- Bảng: liên hệ từ form website (khớp form trong index.html)
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS `contact_requests`;
CREATE TABLE `contact_requests` (
  `id`            BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `full_name`     VARCHAR(120)    NOT NULL COMMENT 'Họ và tên',
  `phone`         VARCHAR(20)     NOT NULL COMMENT 'Số điện thoại',
  `email`         VARCHAR(120)    NULL     COMMENT 'Email (không bắt buộc)',
  `interest`      VARCHAR(40)     NOT NULL DEFAULT 'khac' COMMENT 'cong-nhan|ky-thuat|van-phong|doanh-nghiep|khac',
  `message`       TEXT            NOT NULL COMMENT 'Nội dung liên hệ',
  `ip_address`    VARCHAR(45)     NULL     COMMENT 'IP người gửi',
  `user_agent`    VARCHAR(255)    NULL,
  `status`        ENUM('new','contacted','closed') NOT NULL DEFAULT 'new',
  `admin_note`    TEXT            NULL     COMMENT 'Ghi chú nội bộ',
  `created_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`    DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_contact_status` (`status`),
  KEY `idx_contact_created` (`created_at`),
  KEY `idx_contact_phone` (`phone`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- Bảng: tin tuyển dụng (dùng sau khi có trang/admin quản lý việc làm)
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS `job_posts`;
CREATE TABLE `job_posts` (
  `id`              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title`           VARCHAR(200)    NOT NULL,
  `company_name`    VARCHAR(150)    NULL,
  `location`        VARCHAR(120)    NOT NULL DEFAULT 'Hà Nam',
  `salary_text`     VARCHAR(100)    NULL COMMENT 'VD: 7-9 triệu + phụ cấp',
  `job_type`        ENUM('cong-nhan','ky-thuat','van-phong','khac') NOT NULL DEFAULT 'cong-nhan',
  `description`     TEXT            NOT NULL,
  `requirements`    TEXT            NULL,
  `contact_phone`   VARCHAR(20)     NULL DEFAULT '0345297862',
  `is_hot`          TINYINT(1)      NOT NULL DEFAULT 0,
  `is_published`    TINYINT(1)      NOT NULL DEFAULT 1,
  `published_at`    DATETIME        NULL,
  `expires_at`      DATE            NULL,
  `created_at`      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at`      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_job_published` (`is_published`, `published_at`),
  KEY `idx_job_type` (`job_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- Bảng: cài đặt website (hotline, địa chỉ, v.v.)
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS `site_settings`;
CREATE TABLE `site_settings` (
  `setting_key`   VARCHAR(60)  NOT NULL,
  `setting_value` TEXT         NOT NULL,
  `updated_at`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`setting_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `site_settings` (`setting_key`, `setting_value`) VALUES
  ('site_name',       'Tuyển Dụng An Khang'),
  ('hotline',         '0345297862'),
  ('hotline_display', '0345 297 862'),
  ('area',            'Hà Nam & vùng phụ cận'),
  ('meta_description','Tuyển Dụng An Khang - Tư vấn tuyển dụng lao động tại khu công nghiệp Hà Nam và vùng phụ cận.');

-- -----------------------------------------------------------------------------
-- Bảng: tài khoản admin (tạo user sau khi có trang đăng nhập PHP)
-- Tạo mật khẩu trên host: password_hash('MatKhauManh', PASSWORD_DEFAULT)
-- -----------------------------------------------------------------------------
DROP TABLE IF EXISTS `admin_users`;
CREATE TABLE `admin_users` (
  `id`            INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `username`      VARCHAR(50)  NOT NULL,
  `password_hash` VARCHAR(255) NOT NULL,
  `full_name`     VARCHAR(120) NULL,
  `is_active`     TINYINT(1)   NOT NULL DEFAULT 1,
  `last_login_at` DATETIME     NULL,
  `created_at`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_admin_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- Dữ liệu mẫu: vài tin tuyển (có thể xóa sau)
-- -----------------------------------------------------------------------------
INSERT INTO `job_posts` (`title`, `company_name`, `location`, `salary_text`, `job_type`, `description`, `requirements`, `is_hot`, `published_at`) VALUES
  (
    'Tuyển công nhân sản xuất KCN Hà Nam',
    'Doanh nghiệp sản xuất',
    'KCN Đồng Văn, Hà Nam',
    'Thỏa thuận + phụ cấp',
    'cong-nhan',
    'Tuyển lao động phổ thông làm ca ngày/đêm. Có xe đưa đón, ăn ca.',
    '18–45 tuổi, sức khỏe tốt, chịu khó.',
    1,
    NOW()
  ),
  (
    'Tuyển kỹ thuật bảo trì',
    NULL,
    'Hà Nam',
    '8–12 triệu',
    'ky-thuat',
    'Bảo trì máy móc dây chuyền sản xuất.',
    'Có kinh nghiệm ưu tiên; biết đọc bản vẽ cơ bản.',
    0,
    NOW()
  );

SET FOREIGN_KEY_CHECKS = 1;

-- =============================================================================
-- SAU KHI IMPORT
-- =============================================================================
-- 1. Tạo user MySQL và gán FULL quyền cho database này (trong cPanel)
-- 2. Copy config.example.php → config.php và điền thông tin DB
-- 3. Upload thư mục api/ (nếu dùng PHP lưu form) cùng index.html
-- 4. Tạo tài khoản admin khi đã có trang quản trị PHP
-- =============================================================================
