<?php

namespace App\Models;

class Role extends SmartRecord
{
    protected $table = 'roles';
    protected $guarded = ['id'];
    public function permissions() { return $this->belongsToMany(Permission::class, "role_permissions"); }
}
