<?php

namespace App\Models;

class ForecastRun extends SmartRecord
{
    public const UPDATED_AT = null;
    protected $table = 'forecast_runs';
    protected $guarded = ['id'];
}
