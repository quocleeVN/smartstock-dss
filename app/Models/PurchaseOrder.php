<?php

namespace App\Models;

class PurchaseOrder extends SmartRecord
{
    protected $table = 'purchase_orders';
    protected $guarded = ['id'];
    public function items() { return $this->hasMany(PurchaseOrderItem::class); }
}
