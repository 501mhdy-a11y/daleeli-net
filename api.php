<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\NetworkController;
use App\Http\Controllers\Api\VoucherController;
use App\Http\Controllers\Api\OrderController;

Route::get('/v1/networks', [NetworkController::class, 'index']);
Route::get('/v1/networks/{network}', [NetworkController::class, 'show']);
Route::get('/v1/networks/{network}/vouchers', [VoucherController::class, 'index']);

// Production note: protect order creation with authentication, throttling,
// idempotency keys and server-side payment verification.
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/v1/orders', [OrderController::class, 'store']);
    Route::get('/v1/orders', [OrderController::class, 'index']);
});
