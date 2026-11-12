<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Network;
use Illuminate\Http\JsonResponse;

class VoucherController extends Controller
{
    public function index(Network $network): JsonResponse
    {
        abort_unless($network->status === 'active', 404);

        return response()->json(
            $network->vouchers()
                ->where('status', 'available')
                ->orderBy('price_minor')
                ->get(['id', 'network_id', 'package_name', 'price_minor',
                       'currency', 'duration_label', 'delivery_mode'])
        );
    }
}
