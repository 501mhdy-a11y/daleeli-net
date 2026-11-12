<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Network;
use Illuminate\Http\JsonResponse;

class NetworkController extends Controller
{
    public function index(): JsonResponse
    {
        return response()->json(
            Network::query()->where('status', 'active')->latest()->paginate(20)
        );
    }

    public function show(Network $network): JsonResponse
    {
        abort_unless($network->status === 'active', 404);
        return response()->json($network);
    }
}
