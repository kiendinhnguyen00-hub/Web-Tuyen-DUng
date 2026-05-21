<?php
declare(strict_types=1);

/**
 * Nhận form liên hệ từ index.html → lưu bảng contact_requests
 */

const REDIRECT_OK = '../index.html?sent=1#lien-he';
const REDIRECT_ERR = '../index.html?error=%s#lien-he';

const ALLOWED_INTERESTS = [
    'cong-nhan',
    'ky-thuat',
    'van-phong',
    'doanh-nghiep',
    'khac',
];

function redirect_error(string $code): never
{
    header('Location: ' . sprintf(REDIRECT_ERR, rawurlencode($code)));
    exit;
}

function redirect_ok(): never
{
    header('Location: ' . REDIRECT_OK);
    exit;
}

function client_ip(): ?string
{
    if (!empty($_SERVER['HTTP_CF_CONNECTING_IP'])) {
        return substr((string) $_SERVER['HTTP_CF_CONNECTING_IP'], 0, 45);
    }
    if (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
        $parts = explode(',', (string) $_SERVER['HTTP_X_FORWARDED_FOR']);
        return substr(trim($parts[0]), 0, 45);
    }
    return isset($_SERVER['REMOTE_ADDR']) ? substr((string) $_SERVER['REMOTE_ADDR'], 0, 45) : null;
}

if (($_SERVER['REQUEST_METHOD'] ?? '') !== 'POST') {
    header('Location: ../index.html');
    exit;
}

// Honeypot chống bot (field ẩn, người thật không điền)
if (!empty($_POST['website'] ?? '')) {
    redirect_ok();
}

$name = trim((string) ($_POST['name'] ?? ''));
$phone = trim((string) ($_POST['phone'] ?? ''));
$email = trim((string) ($_POST['email'] ?? ''));
$interest = trim((string) ($_POST['interest'] ?? 'khac'));
$message = trim((string) ($_POST['message'] ?? ''));

$len = static function (string $s): int {
    return function_exists('mb_strlen') ? mb_strlen($s) : strlen($s);
};

if ($name === '' || $len($name) > 120) {
    redirect_error('name');
}

if ($phone === '' || $len($phone) > 20) {
    redirect_error('phone');
}

$phoneDigits = preg_replace('/\D+/', '', $phone);
if ($phoneDigits === null || strlen($phoneDigits) < 9 || strlen($phoneDigits) > 15) {
    redirect_error('phone');
}

if ($email !== '' && ($len($email) > 120 || !filter_var($email, FILTER_VALIDATE_EMAIL))) {
    redirect_error('email');
}

if (!in_array($interest, ALLOWED_INTERESTS, true)) {
    $interest = 'khac';
}

if ($message === '' || $len($message) > 5000) {
    redirect_error('message');
}

require_once dirname(__DIR__) . '/database/db.php';

try {
    $pdo = ankhang_db();

    $ip = client_ip();
    if ($ip !== null) {
        $limitStmt = $pdo->prepare(
            'SELECT COUNT(*) FROM contact_requests
             WHERE ip_address = :ip AND created_at > (NOW() - INTERVAL 1 HOUR)'
        );
        $limitStmt->execute([':ip' => $ip]);
        if ((int) $limitStmt->fetchColumn() >= 5) {
            redirect_error('rate');
        }
    }

    $stmt = $pdo->prepare(
        'INSERT INTO contact_requests (full_name, phone, email, interest, message, ip_address, user_agent)
         VALUES (:full_name, :phone, :email, :interest, :message, :ip_address, :user_agent)'
    );

    $userAgent = isset($_SERVER['HTTP_USER_AGENT'])
        ? substr((string) $_SERVER['HTTP_USER_AGENT'], 0, 255)
        : null;

    $stmt->execute([
        ':full_name' => $name,
        ':phone' => $phone,
        ':email' => $email !== '' ? $email : null,
        ':interest' => $interest,
        ':message' => $message,
        ':ip_address' => $ip,
        ':user_agent' => $userAgent,
    ]);

    redirect_ok();
} catch (Throwable $e) {
    error_log('submit_contact: ' . $e->getMessage());
    redirect_error('server');
}
