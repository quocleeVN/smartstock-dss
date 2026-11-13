<?php

namespace App\Models;

class AuditLog extends SmartRecord
{
    public const UPDATED_AT = null;
    protected $table = 'audit_logs';
    protected $guarded = ['id'];
    protected function casts(): array { return ['old_values'=>'array','new_values'=>'array']; }
}
