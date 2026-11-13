<?php

namespace App\Models;

class StockAdjustment extends SmartRecord
{
    public const UPDATED_AT = null;
    protected $table = 'stock_adjustments';
    protected $guarded = ['id'];
}
