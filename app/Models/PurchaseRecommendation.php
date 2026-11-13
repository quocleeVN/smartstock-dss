<?php

namespace App\Models;

class PurchaseRecommendation extends SmartRecord
{
    public const UPDATED_AT = null;
    protected $table = 'purchase_recommendations';
    protected $guarded = ['id'];
}
