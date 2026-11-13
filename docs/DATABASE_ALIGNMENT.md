# Database alignment — source `dss_db(1).sql` (2026-10-25)

## Phạm vi đối chiếu

Cơ sở dữ liệu gốc là SQL dump phpMyAdmin của `dss_db` (MySQL 8.4.7), gồm 25 bảng nghiệp vụ, không có bản ghi INSERT và không chứa bảng `migrations`. File tham chiếu nằm tại `docs/reference/dss_db_2026_10_25_REFERENCE_ONLY.sql`.

## Những thay đổi trong source

1. Giữ 25 bảng nghiệp vụ và cấu trúc quan hệ từ dump. Bảng của Laravel Framework (sessions, cache, password_reset_tokens, jobs, passkeys, migrations...) sẽ được tạo thêm bằng migrations bình thường.
2. Chuyển `purchase_order_items.line_total` và `sales_order_items.line_total` sang MySQL GENERATED STORED như file SQL. OrderService không còn ghi trực tiếp các cột này.
3. Các model không có `updated_at` trong dump sử dụng `UPDATED_AT = null`. Model bảng không có cả `created_at` lẫn `updated_at` thì tắt Eloquent timestamps (đặc biệt inventory_alerts / order_items).
4. Migrations dùng điều kiện `Schema::hasTable` cho bảng đã import; tránh SQLSTATE[42S01]. Migration bổ sung CHECK và unique alert một cách có điều kiện khi MySQL chưa có.
5. Thêm `php artisan smartstock:doctor` kiểm tra driver, 25 bảng/cột trọng yếu, đặc biệt hai trường generated.
6. Cấm tạo tài khoản đăng ký tự do, tăng kiểm tra role/active cho dashboard, seed chỉ dùng local/testing.

## Rủi ro / giới hạn

- File SQL có DROP TABLE IF EXISTS, **không được import lại lên database có dữ liệu**.
- Source chỉ nhận biết bảng/cột hiện có, không tự ý xóa/sửa cột nguồn; nếu người dùng đã tùy biến dữ liệu cần migration riêng sau khi sao lưu.
- CHECK constraints mới có thể từ chối dữ liệu cũ sai quy tắc; hãy sao lưu và kiểm tra dữ liệu trước khi migrate đối với DB đã có record (dump gửi trong cuộc trò chuyện này không chứa INSERT).
- Kiểm thử E2E, concurrency và p95 trên MySQL thật vẫn cần chạy trên máy WampServer.
- `line_total` do DB tạo, `total_amount` tính trong OrderService bằng đơn giá snapshot × số lượng; đơn vị theo hệ thống VND.

## Workflow an toàn

- Cách A: import SQL vào một **database chưa có dữ liệu quan trọng**, cấu hình `.env` tới đúng database đó → `php artisan migrate` → `php artisan smartstock:doctor`.
- Cách B: tạo MySQL database trống và để migrate tạo tất cả bảng; không import SQL.
- Seed chỉ khi thử nghiệm. Không chạy `migrate:fresh` với dữ liệu cần giữ.

- Default policy từ SQL: `demand_window_days=30`, `target_cover_days=14`, `safety_stock_qty=0`; dữ liệu seed dùng safety stock demo 10, lead time 5.
