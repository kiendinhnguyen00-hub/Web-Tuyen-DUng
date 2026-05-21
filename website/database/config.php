<?php
/**
 * CẤU HÌNH MYSQL — BẮT BUỘC SỬA TRƯỚC KHI CHẠY FORM TRÊN HOST
 * Lấy thông tin trong cPanel → MySQL Databases
 */
return [
    'db_host' => 'localhost',
    'db_name' => 'ankhang_db',       // VD: cpaneluser_ankhang
    'db_user' => 'cpaneluser_dbuser',     // VD: cpaneluser_dbuser
    'db_pass' => 'your_db_password',
    'db_charset' => 'utf8mb4',
];
