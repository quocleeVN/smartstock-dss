<?php

namespace App\Models;

class Category extends SmartRecord
{
    protected $table = 'categories';
    protected $guarded = ['id'];
}
