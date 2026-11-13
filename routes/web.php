<?php

use App\Http\Controllers\SmartStock\{CatalogController,OrderController,InventoryController,AnalyticsController,AdminController,NotificationController};
use Illuminate\Support\Facades\Route;

Route::redirect('/', '/dashboard')->name('home');

Route::middleware(['auth', 'verified', 'role:admin,manager,sales,purchasing,warehouse'])->group(function () {
    Route::get('/dashboard',[AnalyticsController::class,'dashboard'])->name('dashboard');
    Route::get('/notifications',[NotificationController::class,'index'])->name('notifications.index');
    Route::post('/notifications/{id}/read',[NotificationController::class,'read'])->name('notifications.read');

    Route::middleware('role:admin,manager,sales,purchasing,warehouse')->group(function(){
        Route::get('/manage/{entity}',[CatalogController::class,'index'])->name('catalog.index');
        Route::post('/manage/{entity}',[CatalogController::class,'save'])->name('catalog.store');
        Route::put('/manage/{entity}/{id}',[CatalogController::class,'save'])->name('catalog.update');
        Route::get('/inventory',[InventoryController::class,'index'])->name('inventory.index');
    });

    Route::middleware('role:admin,warehouse')->group(function(){
        Route::post('/inventory/adjust',[InventoryController::class,'adjust'])->name('inventory.adjust');
    });
    Route::middleware('role:admin,manager')->group(function(){
        Route::post('/inventory/policy',[InventoryController::class,'policy'])->name('inventory.policy');
        
        Route::post('/analytics/scan',[AnalyticsController::class,'scan'])->name('analytics.scan');
        Route::post('/analytics/forecast',[AnalyticsController::class,'forecast'])->name('analytics.forecast');
        Route::post('/analytics/recommend',[AnalyticsController::class,'recommendation'])->name('analytics.recommend');
    });
    Route::middleware('role:admin,manager,purchasing')->get('/analytics',[AnalyticsController::class,'analysis'])->name('analytics.index');
    Route::middleware('role:admin,manager,purchasing')->get('/analytics/export',[AnalyticsController::class,'export'])->name('analytics.export');
    Route::middleware('role:admin,purchasing')->post('/analytics/convert',[AnalyticsController::class,'convert'])->name('analytics.convert');
    Route::middleware('role:admin,manager,sales,purchasing,warehouse')->group(function(){
        Route::get('/{kind}-orders',[OrderController::class,'index'])->where('kind','purchase|sale')->name('orders.index');
        Route::get('/{kind}-orders/create',[OrderController::class,'make'])->where('kind','purchase|sale')->name('orders.create');
        Route::get('/{kind}-orders/{id}/edit',[OrderController::class,'edit'])->where(['kind'=>'purchase|sale','id'=>'[0-9]+'])->name('orders.edit');
        Route::put('/{kind}-orders/{id}',[OrderController::class,'update'])->where(['kind'=>'purchase|sale','id'=>'[0-9]+'])->name('orders.update');
        Route::post('/{kind}-orders',[OrderController::class,'store'])->where('kind','purchase|sale')->name('orders.store');
        Route::get('/{kind}-orders/{id}',[OrderController::class,'show'])->where(['kind'=>'purchase|sale','id'=>'[0-9]+'])->name('orders.show');
        Route::post('/{kind}-orders/{id}/{action}',[OrderController::class,'action'])->where(['kind'=>'purchase|sale','id'=>'[0-9]+'])->name('orders.action');
        Route::redirect('/pos','/sale-orders/create?pos=1')->name('pos');
    });
    Route::middleware('role:admin')->group(function(){
        Route::get('/staff',[AdminController::class,'index'])->name('staff.index');
        Route::get('/audit',[NotificationController::class,'audit'])->name('audit.index');
        Route::post('/staff',[AdminController::class,'save'])->name('staff.store');
        Route::put('/staff/{id}',[AdminController::class,'save'])->name('staff.update');
    });
});

require __DIR__.'/settings.php';
