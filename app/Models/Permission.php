<?php

namespace App\Models;

class Permission extends SmartRecord
{
    protected $table = 'permissions';
    protected $guarded = ['id'];
}
