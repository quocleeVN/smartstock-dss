<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        if (! Schema::hasColumn('users', 'status')) {
            Schema::table('users', function (Blueprint $table) {
                $table->string('status', 20)->default('active');
            });
        }
        if (! Schema::hasTable('roles')) Schema::create('roles', function (Blueprint $table) {
            $table->id(); $table->string('code', 40)->unique(); $table->string('name', 120); $table->timestamps();
        });
        if (! Schema::hasTable('permissions')) Schema::create('permissions', function (Blueprint $table) {
            $table->id(); $table->string('code', 100)->unique(); $table->string('description')->nullable(); $table->timestamps();
        });
        if (! Schema::hasTable('user_roles')) Schema::create('user_roles', function (Blueprint $table) {
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->foreignId('role_id')->constrained()->cascadeOnDelete();
            $table->primary(['user_id', 'role_id']);
        });
        if (! Schema::hasTable('role_permissions')) Schema::create('role_permissions', function (Blueprint $table) {
            $table->foreignId('role_id')->constrained()->cascadeOnDelete();
            $table->foreignId('permission_id')->constrained()->cascadeOnDelete();
            $table->primary(['role_id', 'permission_id']);
        });
    }
    public function down(): void
    {
        // Non-destructive because imported SQL may own existing RBAC tables.
    }
};
