<?php

namespace App\Models;

class InventoryTransaction extends SmartRecord
{
    public const UPDATED_AT = null;
    protected $table = 'inventory_transactions';
    protected $guarded = ['id'];
}
