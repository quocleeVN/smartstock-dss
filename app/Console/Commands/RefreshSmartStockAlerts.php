<?php

namespace App\Console\Commands;

use App\Services\DecisionService;
use Illuminate\Console\Command;
use Throwable;

class RefreshSmartStockAlerts extends Command
{
    protected $signature = 'smartstock:scan-alerts';
    protected $description = 'Recalculate open low-stock alerts from on-hand inventory and ROP';

    public function handle(DecisionService $decision): int
    {
        try {
            $created = $decision->scan();
            $this->info("Low-stock scan completed. New alerts: {$created}");
            return self::SUCCESS;
        } catch (Throwable $e) {
            $this->error('Alert scan failed: '.$e->getMessage());
            return self::FAILURE;
        }
    }
}
