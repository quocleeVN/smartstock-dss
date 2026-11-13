<?php

namespace App\Models;

class Product extends SmartRecord
{
    protected $table = 'products';
    protected $guarded = ['id'];
    public function inventory() { return $this->hasOne(Inventory::class); }
}
