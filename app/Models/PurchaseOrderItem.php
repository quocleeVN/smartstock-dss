<?php

namespace App\Models;

class PurchaseOrderItem extends SmartRecord
{
    public $timestamps = false;
    protected $table = 'purchase_order_items';
    protected $guarded = ['id', 'line_total'];
}
