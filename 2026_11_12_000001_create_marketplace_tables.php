<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
    {
        Schema::create('networks', function (Blueprint $table) {
            $table->id();
            $table->foreignId('owner_id')->constrained('users');
            $table->string('name');
            $table->text('description')->nullable();
            $table->string('region')->nullable();
            $table->string('status')->default('pending')->index();
            $table->timestamps();
        });

        Schema::create('vouchers', function (Blueprint $table) {
            $table->id();
            $table->foreignId('network_id')->constrained()->cascadeOnDelete();
            $table->string('package_name');
            $table->unsignedBigInteger('price_minor');
            $table->string('currency', 8);
            $table->string('duration_label')->nullable();
            $table->string('delivery_mode')->default('manual');
            $table->string('status')->default('available')->index();
            // Never store voucher credentials in plaintext in this table.
            // Add encrypted credential storage or a dedicated secrets vault.
            $table->timestamps();
        });

        Schema::create('orders', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained();
            $table->foreignId('network_id')->constrained();
            $table->foreignId('voucher_id')->constrained();
            $table->unsignedBigInteger('amount_minor');
            $table->string('currency', 8);
            $table->string('status')->default('awaiting_payment')->index();
            $table->string('idempotency_key', 100)->unique();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('orders');
        Schema::dropIfExists('vouchers');
        Schema::dropIfExists('networks');
    }
};
