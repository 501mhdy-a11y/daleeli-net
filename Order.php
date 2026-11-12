<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Order extends Model
{
    protected $fillable = [
        'user_id', 'network_id', 'voucher_id', 'amount_minor',
        'currency', 'status', 'idempotency_key'
    ];

    public function network(): BelongsTo
    {
        return $this->belongsTo(Network::class);
    }

    public function voucher(): BelongsTo
    {
        return $this->belongsTo(Voucher::class);
    }
}
