# Kiểm tra phát hành 2026-10-25

- Xác nhận file SQL gốc có 25 bảng SmartStock: **PASS**.
- `php -l` cho toàn bộ PHP (app/routes/bootstrap/database/tests): **PASS**.
- `tsc --noEmit` trên thư viện JS QA: **PASS**.
- Source không chứa `.env`, `vendor`, `node_modules`: **PASS**.
- Hai line_total của order items được khai báo GENERATED STORED và không ghi trực tiếp từ OrderService: **PASS (static)**.
- `composer install`, `php artisan migrate`, `php artisan test` trên MySQL, `npm run build`, và kiểm thử HTTP/E2E: **CHƯA CHẠY** trong môi trường đóng gói, do không có Composer/vendor/PDO MySQL. Cần chạy trên WampServer của người dùng.
- Kết quả `SmartStockDemoSeeder` là mô phỏng, không phải dữ liệu doanh nghiệp thực.
