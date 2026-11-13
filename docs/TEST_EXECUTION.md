# Test guide (actual execution required on WampServer)

1. Set up **dedicated local development MySQL database**, not production.
2. `composer install`, `npm ci`, then `php artisan migrate` and `php artisan smartstock:doctor`.
3. `php artisan db:seed`, then `php artisan test --filter=SmartStockWorkflowTest` with proper PHP `pdo_sqlite` or a separate testing MySQL database (see phpunit.xml).
4. `npm run types:check`, `npm run build` and browser test at `http://smartstock.test`.
5. Verify CLI `php artisan smartstock:scan-alerts` (if desired, configure Windows Task Scheduler later).
6. Manual verification: PO Draft -> Submit -> Approved by *different user* -> Received once -> Completed (no extra stock), SO/POS Draft -> Confirmed (no stock decrease) -> Warehouse Fulfill once, insufficient stock rollback, RBAC direct URL access 403, ABC with completed sales, ROP and incoming approved PO, 8+ weeks demand forecast.
6. Concurrency needs a **real MySQL InnoDB** test (two requests vying for the same stock); SQLite tests aren't a substitute.

**Do not run migrate:fresh on important databases or use the demo seeder in production.**
