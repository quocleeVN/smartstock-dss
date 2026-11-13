# SmartStock DSS — Website quản lý bán hàng, tồn kho và hỗ trợ ra quyết định

**Phiên bản triển khai kỹ thuật 0.9 (25/10/2026)** — phát triển **trên source Laravel 13 + React 19 + TypeScript + Inertia 3** do người dùng cung cấp (`smartstock-dss.rar`). Dự án dùng MySQL/InnoDB, một doanh nghiệp và một kho `MAIN`. Các file gốc của Laravel React Starter Kit được giữ, chỉ bổ sung các module SmartStock.

> **Tình trạng xác minh:** Tất cả file PHP mới đã qua `php -l`; TypeScript đã qua `tsc --noEmit`. **Chưa thực thi thành công `composer install`, `php artisan migrate`, test Laravel/MySQL hay kiểm thử E2E trên máy người dùng**, do môi trường dựng gói không có Internet, Composer dependencies và MySQL server. Đây là **bản source triển khai cần nghiệm thu**, chưa thể xác nhận hoạt động 100% trong môi trường thật. Xem `docs/KNOWN_LIMITATIONS.md`.

## Yêu cầu cài đặt

- **Windows 10/11, WampServer 64-bit**, Apache với `mod_rewrite`, PHP **8.3+** ở **cả Apache và CLI**; PHP extension `pdo_mysql`, `mbstring`, `openssl`, `fileinfo`, `xml`, `intl` (tùy Composer).
- **MySQL 8.0.16+**, khuyến nghị MySQL 8.4/InnoDB (không dùng MariaDB nếu muốn giữ nguyên CHECK/generated column trong migration).
- Composer 2, npm, **Node.js 24.11+** hoặc 22.18+ để phù hợp yêu cầu của những package có trong lockfile. Node 20.20 có thể còn chạy một số công cụ nhưng không phải môi trường kiểm thử khuyến nghị.
- Git (tùy chọn).

## Cài trên WampServer với `http://smartstock.test`

1. **Sao lưu source gốc** trước khi thay thế. Giải nén ZIP vào ví dụ `D:\Do_an_cuoi_ki\smartstock-dss`. Không chép đè `.env` hay database thực tế nếu chưa sao lưu.
2. Apache VirtualHost: `ServerName smartstock.test`; `DocumentRoot "D:/Do_an_cuoi_ki/smartstock-dss/public"`; `<Directory .../public>` bật `AllowOverride All` và `Require local`. Windows `hosts`: `127.0.0.1 smartstock.test`. Khởi động lại WampServer.
3. Tạo database MySQL: `CREATE DATABASE smartstock_dss CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;`.
4. Tại project, chạy:

```powershell
composer install
Copy-Item .env.example .env     # nếu chưa tồn tại .env
php artisan key:generate
```

5. Chỉnh `.env`: `APP_URL=http://smartstock.test`, `DB_CONNECTION=mysql`, `DB_HOST=127.0.0.1`, `DB_PORT`, `DB_DATABASE=smartstock_dss`, `DB_USERNAME`, `DB_PASSWORD` theo dịch vụ MySQL thực tế trong WampServer. Đảm bảo Terminal VS Code dùng PHP 8.3+ bằng `php -v`, `where.exe php`.
6. **Database trống**: chạy `php artisan migrate` và `php artisan db:seed`. Chỉ sử dụng `php artisan migrate:fresh --seed` khi **chấp nhận xóa toàn bộ dữ liệu hiện có**.
7. Cài frontend:

```powershell
npm ci
php artisan wayfinder:generate --with-form
npm run build
```

8. Truy cập `http://smartstock.test` (Apache VirtualHost). Trong lúc phát triển, chạy `npm run dev` ở terminal riêng để có HMR. **Không cần `php artisan serve`** nếu dùng Apache.
9. Đăng nhập bằng tài khoản demo seed (bên dưới). Ngay khi sử dụng ngoài môi trường demo, **đổi mật khẩu và loại bỏ tài khoản minh họa**.

### Tài khoản demo (chỉ dùng trên máy local)

Mật khẩu seed dùng chung: **`SmartStock@2026`**. Admin: `admin@smartstock.test`. Các tài khoản vai trò khác: `manager@smartstock.test`, `sales@smartstock.test`, `purchasing@smartstock.test`, `warehouse@smartstock.test`. Việc tự đăng ký công khai đã được tắt. Quản trị viên tạo hoặc sửa tài khoản từ **Nhân sự & phân quyền**.

### Dữ liệu mẫu và dự báo

Chạy `php artisan db:seed` để tạo vai trò, kho chính, 10 sản phẩm, đối tác và số dư đầu có transaction log. Để sinh **18 tuần lịch sử đơn bán mô phỏng** phục vụ ABC, Dashboard và dự báo, chạy thêm (chỉ một lần, trên DB demo):

```powershell
php artisan db:seed --class=SmartStockDemoSeeder
```

Dữ liệu này **hoàn toàn giả lập**, không phải dữ liệu doanh nghiệp thật. `SmartStockDemoSeeder` có mã đơn cố định nhằm tránh seed trùng; không chạy trên production. Khi báo cáo đồ án cần ghi rõ nguồn mô phỏng.

## Các chức năng đã có source

- **Xác thực & RBAC**: giữ Fortify (login/2FA/passkey từ starter); 5 role custom qua `roles`, `permissions`, `user_roles`, `role_permissions`; Admin quản lý tài khoản.
- **Danh mục**: đơn vị, danh mục, sản phẩm, khách hàng, nhà cung cấp; sửa/khóa trạng thái, không xóa cứng dữ liệu giao dịch.
- **Bán hàng/POS**: chọn khách, giỏ hàng, tạo và sửa SO Draft, Confirmed, Warehouse xác nhận xuất kho, Completed; chống xuất lặp.
- **Mua hàng**: PO Draft, sửa nháp, gửi duyệt, Manager duyệt (không tự duyệt), từ chối, Warehouse nhận đủ một lần, Purchasing đóng hồ sơ, hủy trước khi nhận.
- **Kho**: `inventories` + ledger `inventory_transactions`, opening balance, điều chỉnh có lý do; transaction + khóa hàng `lockForUpdate`, ràng buộc nguồn giao dịch duy nhất.
- **Dashboard**: doanh thu Completed, số lượng tồn, thẻ KPI, doanh thu theo ngày, đơn gần đây.
- **DSS**: ABC theo doanh thu, nhu cầu bình quân 28 ngày, ROP, safety stock cấu hình, cảnh báo tồn thấp/hết hàng, lượng hàng PO Approved chờ nhận, khuyến nghị nhập và tạo PO Draft từ khuyến nghị.
- **Dự báo nâng cao (phiên bản cơ bản)**: dự báo 4 tuần bằng Moving Average 3 tuần, MAE rolling, yêu cầu tối thiểu 8 tuần dữ liệu; không ngụy tạo kết quả khi thiếu lịch sử.
- **Bổ sung**: thông báo cảnh báo được tạo khi manager thực hiện quét, audit log các thao tác trọng yếu, xuất ABC CSV UTF-8.

## Cấu trúc mã nguồn

| Nơi lưu | Trách nhiệm |
|---|---|
| `app/Http/Controllers/SmartStock` | Các điểm vào HTTP, validation, phân quyền thao tác |
| `app/Services/OrderService.php` | Trạng thái PO/SO, nhận và xuất kho atomic |
| `app/Services/StockService.php` | Duy nhất cập nhật tồn và tạo ledger |
| `app/Services/DecisionService.php` | ABC, nhu cầu, ROP, alert, MA3 forecast |
| `database/migrations/2026_10_25_*` | Bổ sung schema nghiệp vụ, RBAC và thông báo |
| `database/seeders/` | Tài khoản, danh mục, tồn đầu và lịch sử demo tùy chọn |
| `resources/js/pages/smartstock/` | Các trang React mới |
| `routes/web.php` | Điểm vào Inertia và route hành động nghiệp vụ |
| `tests/Feature/SmartStockWorkflowTest.php` | Kiểm thử đơn bán, PO và phân quyền |
| `docs/` | Truy vết thiết kế, nghiệm thu và phần chưa kiểm chứng |

## Kiểm thử trên máy của bạn

```powershell
php artisan migrate:status
php artisan db:show
php artisan test --filter=SmartStockWorkflowTest
npm run types:check
npm run build
```

Nếu câu lệnh `php artisan test` dùng SQLite trong bộ test, PHP CLI cần có `pdo_sqlite`. Nếu không, cấu hình riêng database MySQL dành cho test; **không bao giờ chỉ định database dữ liệu thật để chạy `migrate:fresh`**. Để kiểm tra tranh chấp tồn kho, cần thêm thử nghiệm chạy đồng thời trên **MySQL/InnoDB**; SQLite in-memory không phản ánh khóa dòng MySQL.

## Nhật ký thay đổi so với thiết kế bước 7–10

- `users` giữ cấu trúc mặc định Laravel/Fortify (gồm 2FA/passkey) rồi bổ sung `status` và pivot role, thay vì tạo lại bảng `users` như DDL học thuật.
- Dòng chi tiết đơn `line_total` hiện được tính trong Application Service và lưu snapshot (không phải MySQL `GENERATED STORED`), cần cập nhật Data Dictionary khi viết báo cáo chính thức.
- Warehouse `MAIN` giữ một kho cho MVP. PO/SO nhập/xuất đủ một lần, không stock reservation.
- Mọi tác động tồn chính thức đi qua `StockService` và `inventory_transactions`; không tăng/giảm tồn khi SO chỉ mới Confirmed.
- UI **Bán hàng nhanh** sử dụng chung Service và schema với Sales Orders; không phải website ecommerce.

Đọc `docs/KNOWN_LIMITATIONS.md` và `docs/REPORT_TRACEABILITY.md` trước khi xem bản này là hoàn tất nghiệm thu.
