<?php

namespace App\Models;

class SalesOrder extends SmartRecord
{
    protected $table = 'sales_orders';
    protected $guarded = ['id'];
    public function items() { return $this->hasMany(SalesOrderItem::class); }
}
