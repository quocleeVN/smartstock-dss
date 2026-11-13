# SmartStock DSS — Web quản lý bán hàng, kho và hỗ trợ ra quyết định

**Phiên bản đồng bộ database 1.0 – 25/10/2026.** Nền tảng: Laravel 13, PHP >=8.3, React 19, TypeScript, Inertia 3, Tailwind CSS, MySQL 8.0.16+/8.4, một kho chính MAIN.

> **Điểm khác với bản ZIP trước:** Bản này được đồng bộ với SQL của bạn `dss_db(1).sql`: 25 bảng nghiệp vụ; hai cột `purchase_order_items.line_total` và `sales_order_items.line_total` **GENERATED STORED**; những bảng chỉ có `created_at` hoặc không có timestamps được cấu hình Eloquent tương ứng. Migration được bảo vệ để không tạo lại 25 bảng nếu bạn đã import SQL. Không chứa `.env`, `vendor` hoặc `node_modules`.

## 1. Cài đặt trên Windows / WampServer

1. **Sao lưu database và source cũ**. Không ghi đè `.env` nếu nó đang có giá trị cần giữ. Giải nén ZIP vào `D:\Do_an_cuoi_ki\smartstock-dss`.
2. Cấu hình Apache VirtualHost `ServerName smartstock.test`, DocumentRoot trỏ tới `D:/Do_an_cuoi_ki/smartstock-dss/public`; Windows hosts thêm `127.0.0.1 smartstock.test`. Apache và terminal dùng PHP từ 8.3 trở lên (`php -v`, `where.exe php`).
3. Tạo hoặc chọn database MySQL. Có **hai đường cài đặt an toàn**:
   - **A — Dùng SQL đã import:** Nếu bạn đã import đúng `dss_db(1).sql` vào MySQL database `dss_db`, **không import lại**. Dùng `DB_DATABASE=dss_db` trong `.env`. Các migrations có bảo vệ `Schema::hasTable`, sẽ tạo các bảng nền Laravel còn thiếu và không tạo trùng 25 bảng nghiệp vụ. Nếu cần, migration mới sẽ thêm những CHECK còn thiếu.
   - **B — Cơ sở dữ liệu mới trống:** Tạo `smartstock_dss` và dùng `DB_DATABASE=smartstock_dss`. **Không import SQL**; migrations sẽ tạo bảng nghiệp vụ phù hợp với cấu trúc SQL, bao gồm cột generated.
4. Chỉ làm trên database bạn đã sao lưu hoặc database dành riêng cho dự án:

```powershell
composer install
Copy-Item .env.example .env   # bỏ qua nếu đã có .env
php artisan key:generate     # chỉ khi chưa có APP_KEY
```

5. Chỉnh `.env`: `APP_URL=http://smartstock.test`, `DB_CONNECTION=mysql`, `DB_HOST=127.0.0.1`, `DB_PORT=3306`, `DB_DATABASE=dss_db` **hoặc** `smartstock_dss` theo database bạn chọn, `DB_USERNAME`, `DB_PASSWORD` theo WampServer.

```powershell
php artisan config:clear
php artisan db:show
php artisan migrate
php artisan migrate:status
php artisan smartstock:doctor
```

6. **Chỉ khi muốn tạo dữ liệu demo trên database dành riêng để thử nghiệm**, chạy:

```powershell
php artisan db:seed
php artisan db:seed --class=SmartStockDemoSeeder
```

`db:seed` tạo 5 role, 5 tài khoản, sản phẩm, kho, tồn đầu và ledger; `SmartStockDemoSeeder` tạo lịch sử bán hàng **mô phỏng** phục vụ ABC, KPI và dự báo. Không chạy seed nếu database đang chứa dữ liệu doanh nghiệp thật cần giữ. Seeder có chốt chặn chỉ chạy tại `APP_ENV=local` hoặc `testing`.

7. Frontend:

```powershell
npm ci
php artisan wayfinder:generate --with-form
npm run types:check
npm run build
```

Nếu build lỗi `laravel:fonts` vì mạng như trước, bản này đã bỏ remote fonts; kiểm tra `vite.config.ts` và `resources/css/app.css`. Chạy `npm run dev` nếu cần HMR khi chỉnh React. Không cần `php artisan serve` khi dùng Apache VirtualHost.

8. Mở `http://smartstock.test`; đăng nhập và thử luồng nghiệp vụ. **Không dùng `migrate:fresh` hay import lại SQL** trên database có dữ liệu cần giữ; cả hai có thể làm mất dữ liệu.

### Tài khoản DEMO — không sử dụng trên Internet

Mật khẩu demo: `SmartStock@2026` (chỉ tạo khi chạy `db:seed`).

| Vai trò | Email |
|---|---|
| Admin | `admin@smartstock.test` |
| Manager | `manager@smartstock.test` |
| Sales | `sales@smartstock.test` |
| Purchasing | `purchasing@smartstock.test` |
| Warehouse | `warehouse@smartstock.test` |

Chức năng đăng ký công khai đã được tắt. **Hãy đổi mật khẩu / xóa tài khoản demo trước khi triển khai ngoài máy local.**

## 2. Các phân hệ

- **Người dùng/RBAC:** Laravel Fortify login/2FA/passkeys (starter), custom RBAC 5 vai trò, Admin tạo người dùng.
- **Danh mục:** sản phẩm, SKU, danh mục, đơn vị, khách hàng, nhà cung cấp; trạng thái hoạt động/khóa.
- **Mua hàng:** tạo PO Draft, sửa nháp, gửi Manager duyệt (không tự duyệt), nhận đủ một lần, đóng hồ sơ.
- **Bán hàng và POS:** chọn khách, tìm SKU, giỏ hàng, tạo SO Draft/Confirmed, Warehouse kiểm tra thực tế và xuất hàng. **Confirmed không giảm/giữ chỗ tồn**.
- **Kho:** tồn thực tế, khởi tạo số dư, điều chỉnh với lý do, ledger bất biến, transaction và row locks.
- **Dashboard và DSS:** doanh thu SO Completed, phân loại ABC theo doanh thu, nhu cầu trung bình theo cấu hình (SQL mặc định 30 ngày), ROP, Safety Stock, hàng PO Approved chờ nhận, đề xuất mua và chuyển thành PO Draft.
- **Dự báo P2:** Moving Average 3 tuần, tối thiểu 8 tuần lịch sử, dự báo 4 tuần và MAE. Thông báo cảnh báo và CSV ABC.

## 3. Lưu ý kỹ thuật và độ tương thích

- SQL người dùng là thiết kế **25 bảng nghiệp vụ**. Laravel Starter Kit tự cần bổ sung `migrations`, `sessions`, `cache`, `jobs`, `password_reset_tokens`, `passkeys` và 2FA. Đây không phải các bảng nghiệp vụ bị thiếu trong dump.
- `line_total` là **generated column**. Code không truyền `line_total` khi INSERT/UPDATE; đọc kết quả do MySQL tính. `total_amount` là snapshot do Service tính, làm tròn đến hai chữ số thập phân.
- Nhận/xuất kho chạy đồng bộ trong `DB::transaction` và `lockForUpdate`; `inventory_transactions` có unique reference đến từng order item / adjustment.
- Một số migration có `down()` không xóa bảng vì có thể đó là bảng SQL **được import trước khi chạy Laravel**. Để thay đổi schema hãy dùng migration bổ sung rõ ràng; không dựa vào rollback để hủy database gốc.
- File `docs/reference/dss_db_2026_10_25_REFERENCE_ONLY.sql` chứa `DROP TABLE IF EXISTS` và **chỉ dùng đối chiếu**, không import lại lên database có dữ liệu.
- Bộ kiểm thử PHP sử dụng SQLite in-memory theo `phpunit.xml`; PHP test phải bật `pdo_sqlite`, hoặc cấu hình MySQL **database test riêng biệt**. Không chạy migrate:fresh trên dữ liệu nghiệp vụ.

## 4. Kiểm tra nghiệm thu

```powershell
php artisan smartstock:doctor
php artisan test --filter=SmartStockWorkflowTest
npm run types:check
npm run build
```

Sau đó test trên giao diện: đăng nhập năm vai trò, tạo/sửa đơn nháp, PO Approval → Warehouse Receive, SO Draft → Confirm → Warehouse Fulfill, kiểm lại `inventories` và `inventory_transactions`, dashboard ABC/ROP, dự báo bằng dữ liệu demo. Kiểm tra kết quả frontend bằng cách mở `http://smartstock.test`.

## 5. Giới hạn và trung thực về kiểm thử

Đây là **bộ mã nguồn được lập trình và đối chiếu schema**. Ở môi trường đóng gói chưa có Composer dependencies, PDO MySQL và MySQL server để chạy migrate, PHPUnit hay E2E; do đó **chưa xác nhận build/test chạy thành công trên WampServer của bạn**. Không xem dự án là production-ready cho đến khi hoàn tất nghiệm thu. Các giới hạn P2 và kế hoạch test chi tiết nằm ở `docs/KNOWN_LIMITATIONS.md`.

### Optional: scheduled low-stock alerts

Run once manually with `php artisan smartstock:scan-alerts`. The daily schedule is registered in `routes/console.php` for 08:00 app time. **On Windows the scheduler does not start itself**; configure Windows Task Scheduler to execute `php artisan schedule:run` from the project directory each minute (with correct PHP CLI PATH), or use the Manager button *Quét cảnh báo* in the DSS UI.
