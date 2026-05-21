<?php
declare(strict_types=1);

/**
 * Kết nối PDO — dùng chung cho các file PHP trong api/
 */
function ankhang_db(): PDO
{
    static $pdo = null;

    if ($pdo instanceof PDO) {
        return $pdo;
    }

    $configFile = __DIR__ . '/config.php';
    if (!is_readable($configFile)) {
        throw new RuntimeException(
            'Chưa có file database/config.php. Hãy copy từ config.example.php và điền thông tin MySQL.'
        );
    }

    $config = require $configFile;
    $host = $config['db_host'] ?? 'localhost';
    $name = $config['db_name'] ?? '';
    $user = $config['db_user'] ?? '';
    $pass = $config['db_pass'] ?? '';
    $charset = $config['db_charset'] ?? 'utf8mb4';

    if (
        $name === ''
        || $user === ''
        || str_contains($user, 'your_db')
        || str_contains((string) $pass, 'your_db_password')
    ) {
        throw new RuntimeException('Vui lòng cấu hình db_name, db_user và db_pass trong database/config.php.');
    }

    $dsn = sprintf('mysql:host=%s;dbname=%s;charset=%s', $host, $name, $charset);

    $pdo = new PDO($dsn, $user, $pass, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
        PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        PDO::ATTR_EMULATE_PREPARES => false,
    ]);

    return $pdo;
}
