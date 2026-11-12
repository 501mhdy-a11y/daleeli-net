<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Voucher extends Model
{
    protected $fillable = [
        'network_id', 'package_name', 'price_minor', 'currency',
        'duration_label', 'delivery_mode', 'status'
    ];

    protected $casts = ['price_minor' => 'integer'];

    public function network(): BelongsTo
    {
        return $this->belongsTo(Network::class);
    }
}
