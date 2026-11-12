<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Models\Voucher;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

class OrderController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        return response()->json(
            Order::query()->where('user_id', $request->user()->id)
                ->latest()->paginate(20)
        );
    }

    public function store(Request $request): JsonResponse
    {
        $data = $request->validate([
            'voucher_id' => ['required', 'integer', 'exists:vouchers,id'],
            'idempotency_key' => ['required', 'string', 'max:100'],
        ]);

        $order = DB::transaction(function () use ($request, $data) {
            $voucher = Voucher::query()->lockForUpdate()->findOrFail($data['voucher_id']);

            if ($voucher->status !== 'available') {
                throw ValidationException::withMessages([
                    'voucher_id' => 'هذا الكرت غير متاح حالياً.',
                ]);
            }

            // This starter reserves inventory only. Payment confirmation and
            // credential delivery must be implemented via a verified provider webhook.
            $voucher->status = 'reserved';
            $voucher->save();

            return Order::create([
                'user_id' => $request->user()->id,
                'network_id' => $voucher->network_id,
                'voucher_id' => $voucher->id,
                'amount_minor' => $voucher->price_minor,
                'currency' => $voucher->currency,
                'status' => 'awaiting_payment',
                'idempotency_key' => $data['idempotency_key'],
            ]);
        });

        return response()->json($order, 201);
    }
}
