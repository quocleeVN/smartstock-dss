<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class RequireRole
{
    public function handle(Request $request, Closure $next, string ...$roles)
    {
        abort_unless($request->user() && $request->user()->status === 'active', 403);
        abort_unless($request->user()->hasAnyRole($roles), 403, 'Bạn không có quyền truy cập.');
        return $next($request);
    }
}
