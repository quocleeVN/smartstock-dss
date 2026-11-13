<?php

namespace App\Models;

class Customer extends SmartRecord
{
    protected $table = 'customers';
    protected $guarded = ['id'];
}
