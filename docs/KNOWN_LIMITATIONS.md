# SmartStock DSS — Các mục còn cần xác minh

**Trạng thái: bản bàn giao source triển khai, chưa nghiệm thu end-to-end.**

## Đã kiểm tra được trong môi trường dựng gói

- Giải nén được file RAR Laravel 13 gốc người dùng cung cấp; giữ cấu trúc starter, tài nguyên frontend và authentication.
- Kiểm tra cú pháp toàn bộ PHP mới bằng `php -l`: **qua**.
- Kiểm tra TypeScript bằng `node node_modules/typescript/bin/tsc --noEmit`: **qua** (thư viện JS lấy từ archive gốc).
- Kiểm tra cấu trúc thư mục, tên lớp, các route mới và loại trừ `.env` / `node_modules` / `vendor` khỏi ZIP.

## Chưa thể kiểm chứng ở đây

- `composer install` / `php artisan migrate` / `php artisan test` / `npm run build` trên toàn bộ ứng dụng: môi trường tạo gói thiếu Composer deps, MySQL và Internet để tải package. Các bước này phải chạy tại Windows/WampServer.
- MySQL CHECK, generated index ở `inventory_alerts`, lockForUpdate và vấn đề deadlock dưới tải đồng thời.
- Hành vi thực tế của Laravel 13 + Inertia 3 trong Apache VirtualHost của người dùng.
- Định lượng p95 hiệu năng theo NFR, backup/restore, bảo mật runtime, trải nghiệm di động và tính đầy đủ của các luồng qua trình duyệt.

## Giới hạn của phạm vi hiện tại

1. Dự báo chỉ sử dụng **Moving Average 3 kỳ** và đánh giá **MAE rolling**; chưa triển khai Exponential Smoothing hoặc so sánh nhiều mô hình; xem là chức năng P2 mẫu.
2. Xuất báo cáo mới ở dạng **ABC CSV**; chưa hỗ trợ tệp XLSX và các báo cáo chuyên biệt đầy đủ.
3. Audit log ghi các chuyển trạng thái đơn, tài khoản, điều chỉnh kho; chưa log tất cả thao tác CRUD danh mục.
4. Notification tạo khi quản lý chạy quét alert; cũng có lệnh `smartstock:scan-alerts` và lịch chạy 08:00 nhưng cần Windows Task Scheduler/cron để kích hoạt; chưa kiểm thử queue worker.
5. Dashboard có KPI và biểu đồ ngày; chưa tích hợp bộ lọc phức tạp và drill-down tất cả báo cáo.
6. POS là nhập đơn nội bộ, không thu tiền, không máy quét, không in hóa đơn, không quản lý công nợ.
7. Không hỗ trợ đơn trả hàng, nhận/xuất từng phần, nhiều kho, chuyển kho, tồn theo lô hoặc sản phẩm phân số.
8. `purchase_recommendations` gắn snapshot; khi chuyển thành PO Draft chưa tính lại đề xuất để tự thay đổi số lượng nếu dữ liệu mới thay đổi.
9. Chưa có automated E2E browser tests, workflow load tests; đã cung cấp PHP Feature tests để chạy tại máy.
10. Chưa có Docker/deploy production trên VPS; Apache VirtualHost local là đường đi chính.

## Kiểm thử bắt buộc để chốt bàn giao

- `composer install`, `php artisan migrate`, `php artisan db:seed` hoàn tất trên MySQL của WampServer.
- `npm ci`, `npm run build` hoàn tất; giao diện đăng nhập và các trang SmartStock mở được qua `smartstock.test`.
- Mỗi vai trò chỉ làm được nghiệp vụ cấp quyền.
- PO chờ duyệt, quản lý duyệt, kho nhận một lần; yêu cầu nhận lặp bị từ chối và tồn chỉ tăng một lần.
- SO Draft/Confirmed không giảm tồn; Warehouse fulfill giảm một lần; test song song 2 đơn tranh 1 lượng tồn không âm.
- Audit và ledger hiển thị đúng; dữ liệu báo cáo ABC/ROP đối soát với phép tính thủ công.
- Dự báo MA3 chạy sau khi seed dữ liệu 18 tuần mô phỏng.

**Không nên dùng dữ liệu khách hàng thật, triển khai lên Internet hay khẳng định hệ thống production-ready trước khi hoàn thành checklist trên.**

## Cập nhật đồng bộ dump 2026-10-25

- Hai cột `line_total` đã được đồng bộ thành GENERATED STORED, không còn Application Service ghi trực tiếp.
- Các migrations đã có guard bảo vệ khi bảng tồn tại trong SQL import, kèm command `smartstock:doctor`.
- Trên môi trường hiện tại chưa có runtime MySQL/Composer để chứng thực migration trên WampServer.
