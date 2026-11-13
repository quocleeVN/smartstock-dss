# Cài SmartStock DSS trên WampServer (Windows)

1. Giải nén vào `D:\Do_an_cuoi_ki\smartstock-dss` hoặc nơi khác bạn chọn.
2. WampServer: Apache phải trỏ VirtualHost `smartstock.test` tới `<thu_muc_du_an>/public`, bật `AllowOverride All` và `Require local`.
3. Windows `hosts`: `127.0.0.1 smartstock.test`. Apache PHP và CLI PHP **đều từ 8.3 trở lên**; kiểm tra `where.exe php`, `php -v`, và WampServer > PHP Version.
4. Tạo MySQL schema trống `smartstock_dss`.
5. PowerShell tại thư mục project:

```powershell
composer install
Copy-Item .env.example .env
php artisan key:generate
```

6. Cập nhật MySQL port/user/password trong `.env`. Nếu file `.env` có sẵn, đừng ghi đè. Chạy:

```powershell
php artisan optimize:clear
php artisan migrate
php artisan db:seed
npm ci
php artisan wayfinder:generate --with-form
npm run build
```

7. Mở `http://smartstock.test` và đăng nhập admin demo `admin@smartstock.test` với mật khẩu demo trong README. Có thể chạy `npm run dev` khi phát triển frontend.
8. Khi cần dữ liệu demo có lịch sử bán 18 tuần: `php artisan db:seed --class=SmartStockDemoSeeder`.
9. Chạy `php artisan test --filter=SmartStockWorkflowTest` để kiểm tra các trường hợp cơ bản.

**Không chạy `migrate:fresh` trên database có dữ liệu quan trọng.** Nếu bị lỗi, cung cấp terminal từ dòng lỗi đầu tiên, `php -v` và `php artisan migrate:status` để tìm nguyên nhân.
