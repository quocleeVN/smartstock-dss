<?php

use Illuminate\Foundation\Inspiring;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Schedule;

Artisan::command('inspire', function () {
    $this->comment(Inspiring::quote());
})->purpose('Display an inspiring quote');

// Schedule is active only when Windows Task Scheduler (or cron) invokes artisan schedule:run.
Schedule::command('smartstock:scan-alerts')->dailyAt('08:00')->withoutOverlapping();
