<?php

namespace App\Models;

class SalesOrderItem extends SmartRecord
{
    public $timestamps = false;
    protected $table = 'sales_order_items';
    protected $guarded = ['id', 'line_total'];
}
