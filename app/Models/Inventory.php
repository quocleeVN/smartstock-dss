<?php

namespace App\Models;

class Inventory extends SmartRecord
{
    protected $table = 'inventories';
    protected $guarded = ['id'];
}
