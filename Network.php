<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Network extends Model
{
    protected $fillable = ['owner_id', 'name', 'description', 'region', 'status'];

    public function vouchers(): HasMany
    {
        return $this->hasMany(Voucher::class);
    }
}
