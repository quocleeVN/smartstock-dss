<?php

namespace App\Models;

class InventoryPolicy extends SmartRecord
{
    protected $table = 'inventory_policies';
    protected $guarded = ['id'];
}
