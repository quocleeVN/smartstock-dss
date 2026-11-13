<?php

namespace App\Models;

class InventoryAlert extends SmartRecord
{
    public $timestamps = false;
    protected $table = 'inventory_alerts';
    protected $guarded = ['id'];
}
