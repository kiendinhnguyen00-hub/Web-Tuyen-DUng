# Hướng dẫn upload website lên host (hoàn chỉnh)

Website **Tuyển Dụng An Khang** — HTML + PHP + MySQL.

---

## 1. Yêu cầu host

| Hạng mục | Cần có |
|----------|--------|
| Hosting | Shared hosting (cPanel) hoặc tương đương |
| PHP | 8.0 trở lên |
| MySQL | 5.7+ / MariaDB |
| Extension | `pdo_mysql` |
| SSL | Bật Let's Encrypt (HTTPS) |

---

## 2. File bắt buộc upload

Upload vào **`public_html`** (hoặc `www`):

```
public_html/
├── index.html          ← Trang chủ
├── 404.html
├── .htaccess
├── robots.txt
├── sitemap.xml         ← Sửa tên miền trong file
├── api/
│   └── submit_contact.php
├── database/
│   ├── config.php      ← SỬA thông tin MySQL
│   ├── db.php
│   └── .htaccess
└── images/
    ├── logo.jpg
    ├── gallery-1.jpg
    ├── gallery-2.jpg
    ├── gallery-3.jpg
    ├── about-1.jpg
    └── about-2.jpg
```

### File không bắt buộc upload lên web

| File | Ghi chú |
|------|---------|
| `database/ankhang.sql` | Chỉ dùng **import** trong phpMyAdmin, không cần để trên web |
| `database/HUONG-DAN-IMPORT.txt` | Tài liệu |
| `images/z7842193*.jpg` | Ảnh dự phòng, website không dùng — có thể xóa để giảm dung lượng upload |
| `README-HUONG-DAN-UP-HOST.md` | Tài liệu |

---

## 3. Tạo database (phpMyAdmin)

1. **cPanel** → **MySQL Databases** → tạo database + user → **ALL PRIVILEGES**
2. **phpMyAdmin** → chọn database → **Import** → `database/ankhang.sql`
3. Nếu lỗi `CREATE DATABASE`: comment 2 dòng `CREATE DATABASE` / `USE` trong file SQL, chọn đúng DB rồi import lại

Chi tiết: `database/HUONG-DAN-IMPORT.txt`

---

## 4. Cấu hình `database/config.php`

Mở file và điền đúng thông tin từ cPanel:

```php
'db_host' => 'localhost',
'db_name' => 'cpaneluser_ankhang',   // tên DB đầy đủ
'db_user' => 'cpaneluser_dbuser',
'db_pass' => 'mat_khau_manh',
```

Lưu ý: trên host, tên DB/user thường có **tiền tố** (vd `user123_`).

---

## 5. Sau khi có tên miền

Sửa trong các file:

| File | Việc sửa |
|------|----------|
| `robots.txt` | `Sitemap: https://tênmiền.com/sitemap.xml` |
| `sitemap.xml` | Đổi `https://tenmien.com` → tên miền thật |
| `index.html` | `og:image` và `og:url` (nếu thêm) thành URL đầy đủ |
| `.htaccess` | Bỏ comment khối **HTTPS redirect** |

Bật SSL trong cPanel → **SSL/TLS** → AutoSSL.

---

## 6. Kiểm tra sau khi upload

- [ ] Mở `https://tênmiền.com/` — trang hiển thị, logo + gallery + about có ảnh
- [ ] Bấm **Gọi ngay** / hotline trên điện thoại
- [ ] Gửi form liên hệ → thông báo **Đã gửi thành công**
- [ ] phpMyAdmin → bảng `contact_requests` có dòng mới
- [ ] Thử URL sai → trang `404.html`

### Lỗi thường gặp

| Triệu chứng | Cách xử lý |
|-------------|------------|
| Form báo không gửi được | Kiểm tra `config.php`, import SQL, quyền user MySQL |
| Ảnh about/gallery vỡ | Thiếu file trong `images/` — upload đủ 6 file ảnh bắt buộc |
| Trang trắng / lỗi 500 | Host chưa bật PHP 8; xem Error Log trong cPanel |
| Không vào được trang chủ | Đảm bảo file tên `index.html` nằm trong `public_html` |

---

## 7. Checklist nhanh

```
[ ] Import ankhang.sql
[ ] Sửa database/config.php
[ ] Upload index.html + images/ + api/ + database/
[ ] Bật SSL + (tuỳ chọn) HTTPS trong .htaccess
[ ] Sửa robots.txt + sitemap.xml
[ ] Test form → kiểm tra contact_requests
```

---

Hotline website: **0345 297 862**
