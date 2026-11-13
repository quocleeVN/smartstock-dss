<?php

namespace App\Models;

class DemandForecast extends SmartRecord
{
    public const UPDATED_AT = null;
    protected $table = 'demand_forecasts';
    protected $guarded = ['id'];
}
