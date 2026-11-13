# Căn cứ viết báo cáo đồ án sau khi nghiệm thu SmartStock DSS

Đề tài: *Xây dựng hệ thống hỗ trợ ra quyết định trong quản lý bán hàng và tồn kho cho doanh nghiệp vừa và nhỏ*.

| Nhóm yêu cầu | Cài đặt mã nguồn | Minh chứng nên chụp/test |
|---|---|---|
| FR01–04 | Starter Auth/Fortify, User, Role, Permission, AdminController | Login, phân quyền 5 vai trò, 403 trái quyền |
| FR05–09 | CatalogController, Product/Category/Unit/Customer/Supplier | Danh sách, tìm kiếm, thêm/sửa, khóa hoạt động |
| FR10–16 | OrderController (purchase), OrderService | PO Draft → Pending → Approved → Received → Completed; reject/cancel |
| FR17–21 | OrderController (sale), order-create POS React, OrderService | POS thêm giỏ hàng, SO Draft/Confirmed → Warehouse fulfill |
| FR22–26 | StockService, InventoryController, inventory_transactions | Tồn đầu, điều chỉnh, ledger, transaction, chống lặp |
| FR27–29 | AnalyticsController dashboard, charts React | KPI Completed sales, daily revenue, thống kê tồn |
| FR30 | DecisionService::abc | Doanh thu SKU / tích lũy 80% 95% / phân nhóm ABC |
| FR31–33 | inventory_policies, DecisionService::inventoryInfo + scan | SS, ROP, out_of_stock/low_stock |
| FR34–35 | purchase_recommendations, convert → PO Draft | Công thức đề xuất trừ incoming Approved chưa nhận |
| FR36–37 | ForecastRun/DemandForecast, DecisionService::forecast | Moving average tuần, MAE khi đủ 8 tuần; P2 cơ bản |
| FR38–40 | AuditLog, NotificationController, ABC CSV | Log trạng thái + thay đổi kho, quét cảnh báo, CSV |

## Dữ liệu và tính nhất quán

- MySQL source of truth; 01 warehouse MAIN trong bản demo.
- Tồn không cập nhật khi chỉ xác nhận SO; chỉ trừ tồn khi Warehouse fulfill thành công.
- Purchase PO tăng tồn tại Received; Completed chỉ kết thúc hồ sơ.
- Giá mua/bán được snapshot vào line items; doanh thu chỉ lấy đơn bán Completed.
- Row lock + unique source transaction + transaction rollback chống double receiving/overselling.
- `Status` không được thay đổi bằng CRUD chung; qua OrderService/StockService.
- Seed demo 18 tuần được ghi nhãn **mô phỏng**, không là dữ liệu khảo sát doanh nghiệp.

## Chương 4 – Kiến trúc thực thi

- Monorepo Laravel 13 + React TypeScript + Inertia 3.
- Service Layer: `OrderService`, `StockService`, `DecisionService`.
- `app/Http/Controllers/SmartStock` cho HTTP, Form Request validation trực tiếp trong controller; policy theo Middleware Role và kiểm tra trong action.
- MySQL migrations Bước 11+ có điều chỉnh so với DDL học thuật Bước 7 như đã ghi trong README.

## Chương 5 – Trình bày giao diện

- Dashboard, catalog, orders, POS, inventory, analytics DSS, staff RBAC, notifications, audit.
- Chụp ảnh thực tế sau khi chạy trên Windows. Không thay ảnh wireframe bằng ảnh minh họa hoặc khẳng định ảnh đã chạy nếu chưa có.

## Chương 6 – Kiểm thử

- Test PHP: `tests/Feature/SmartStockWorkflowTest.php` cho sale/PO/RBAC.
- Bổ sung test MySQL concurrency/idempotency và đo tải theo NFR trước khi ghi kết quả vào báo cáo.
- Cần cập nhật bảng đánh giá FR có phần mới đạt một phần (forecast, xuất báo cáo, notification) theo tình trạng thực tế.
