<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Throwable;

class SmartStockDoctor extends Command
{
    protected $signature = 'smartstock:doctor';
    protected $description = 'Check the actual MySQL database against the SmartStock SQL baseline without changing data';

    public function handle(): int
    {
        $this->info('SmartStock database compatibility check (read-only)');
        try {
            $driver = DB::getDriverName();
            $name = DB::getDatabaseName();
            DB::select('SELECT 1');
        } catch (Throwable $e) {
            $this->error('Database connection failed: ' . $e->getMessage());
            return self::FAILURE;
        }
        $this->line('Driver: ' . $driver . ' | Database: ' . $name);
        $expected = [
            'users' => ['id', 'email', 'status'],
            'roles' => ['id', 'code'],
            'permissions' => ['id', 'code'],
            'user_roles' => ['user_id', 'role_id'],
            'role_permissions' => ['role_id', 'permission_id'],
            'categories' => ['id', 'code'],
            'units' => ['id', 'code'],
            'products' => ['id', 'sku', 'category_id', 'unit_id', 'cost_price', 'selling_price'],
            'customers' => ['id', 'name'],
            'suppliers' => ['id', 'name'],
            'warehouses' => ['id', 'code'],
            'inventories' => ['id', 'product_id', 'warehouse_id', 'qty_on_hand'],
            'purchase_orders' => ['id', 'code', 'status', 'created_by', 'approved_by', 'received_at'],
            'purchase_order_items' => ['id', 'purchase_order_id', 'product_id', 'quantity', 'unit_cost', 'line_total'],
            'sales_orders' => ['id', 'code', 'customer_id', 'status', 'completed_at'],
            'sales_order_items' => ['id', 'sales_order_id', 'product_id', 'quantity', 'unit_price', 'line_total'],
            'stock_adjustments' => ['id', 'inventory_id', 'quantity_delta', 'reason'],
            'inventory_transactions' => ['id', 'inventory_id', 'quantity_delta', 'purchase_order_item_id', 'sales_order_item_id', 'stock_adjustment_id'],
            'inventory_policies' => ['id', 'inventory_id', 'lead_time_days', 'safety_stock_qty'],
            'inventory_alerts' => ['id', 'inventory_id', 'alert_type', 'open_inventory_id'],
            'forecast_runs' => ['id', 'product_id', 'method', 'mae'],
            'demand_forecasts' => ['id', 'forecast_run_id', 'predicted_qty'],
            'purchase_recommendations' => ['id', 'inventory_id', 'suggested_qty'],
            'audit_logs' => ['id', 'user_id', 'action'],
            'notifications' => ['id', 'notifiable_id', 'data'],
        ];
        $fail = false;
        foreach ($expected as $table => $columns) {
            if (! Schema::hasTable($table)) {
                $this->error('MISSING TABLE: ' . $table);
                $fail = true;
                continue;
            }
            $missing = array_filter($columns, fn($column) => ! Schema::hasColumn($table, $column));
            if ($missing) {
                $this->error('MISSING COLUMNS: ' . $table . '.' . implode(', ', $missing));
                $fail = true;
            } else {
                $this->line('<info>OK</info> ' . $table);
            }
        }
        if ($driver === 'mysql' && Schema::hasTable('purchase_order_items')) {
            foreach (['purchase_order_items' => 'line_total', 'sales_order_items' => 'line_total'] as $table => $column) {
                $record = DB::selectOne(
                    "SELECT EXTRA AS column_extra
     FROM information_schema.COLUMNS
     WHERE TABLE_SCHEMA = ?
       AND TABLE_NAME = ?
       AND COLUMN_NAME = ?",
                    [$name, $table, $column],
                );

                $extra = strtoupper((string) ($record->column_extra ?? ''));

                if (! str_contains($extra, 'STORED GENERATED')) {
                    $this->error("{$table}.{$column} must be a STORED GENERATED column to match dss_db.sql");
                    $fail = true;
                }
            }
        }
        $this->newLine();
        if ($fail) {
            $this->error('Compatibility check failed; verify migrations and the selected database.');
            return self::FAILURE;
        }
        $this->info('Schema baseline is compatible with SmartStock DSS.');
        return self::SUCCESS;
    }
}
