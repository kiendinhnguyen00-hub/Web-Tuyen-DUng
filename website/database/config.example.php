<?php
/**
 * Đổi tên file này thành config.php sau khi tạo database trên host.
 * KHÔNG upload config.php lên Git công khai nếu có mật khẩu thật.
 */
return [
    'db_host' => 'localhost',
    'db_name' => 'ankhang_db',      // tên DB trên cPanel (vd: user123_ankhang)
    'db_user' => 'your_db_user',    // user MySQL
    'db_pass' => 'your_db_password',
    'db_charset' => 'utf8mb4',
];
