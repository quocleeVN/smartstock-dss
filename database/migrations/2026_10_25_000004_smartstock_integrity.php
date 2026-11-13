<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/** Additive safeguards for both a fresh Laravel install and an imported SQL dump. */
return new class extends Migration {
    public function up(): void
    {
        if (DB::getDriverName() !== 'mysql') return;
        $checks = [
            ['inventories','ck_ss_nonnegative','qty_on_hand >= 0'],
            ['purchase_order_items','ck_ss_po_quantity','quantity > 0 AND unit_cost >= 0'],
            ['sales_order_items','ck_ss_so_quantity','quantity > 0 AND unit_price >= 0'],
            ['inventory_transactions','ck_ss_ledger_balance','quantity_delta <> 0 AND CAST(qty_before AS SIGNED) + quantity_delta = CAST(qty_after AS SIGNED)'],
            ['inventory_transactions','ck_ss_ledger_source','(purchase_order_item_id IS NOT NULL) + (sales_order_item_id IS NOT NULL) + (stock_adjustment_id IS NOT NULL) = 1'],
            ['purchase_orders','ck_ss_no_self_approve','approved_by IS NULL OR approved_by <> created_by'],
            ['stock_adjustments','ck_ss_adjust_balance','CAST(qty_before AS SIGNED) + quantity_delta = CAST(qty_after AS SIGNED) AND quantity_delta <> 0'],
        ];
        foreach ($checks as [$table,$name,$expression]) {
            if (! Schema::hasTable($table)) continue;
            $exists = DB::table('information_schema.table_constraints')
                ->where('table_schema', DB::getDatabaseName())
                ->where('table_name', $table)->where('constraint_name', $name)->exists();
            if (! $exists) DB::statement("ALTER TABLE `{$table}` ADD CONSTRAINT `{$name}` CHECK ({$expression})");
        }
        if (Schema::hasTable('inventory_alerts')) {
            if (! Schema::hasColumn('inventory_alerts', 'open_inventory_id')) {
                DB::statement("ALTER TABLE `inventory_alerts` ADD COLUMN `open_inventory_id` BIGINT UNSIGNED GENERATED ALWAYS AS (CASE WHEN `status` = 'open' THEN `inventory_id` ELSE NULL END) STORED");
            }
            $index = DB::table('information_schema.statistics')->where('table_schema', DB::getDatabaseName())
                ->where('table_name', 'inventory_alerts')->whereIn('index_name', ['uq_alert_active','uq_open_inventory_alert'])->exists();
            if (! $index) DB::statement('CREATE UNIQUE INDEX uq_alert_active ON inventory_alerts(open_inventory_id,alert_type)');
        }
    }
    public function down(): void
    {
        // Do not remove safeguards from a database imported independently of Laravel.
    }
};
