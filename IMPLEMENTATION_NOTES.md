# Backend implementation notes

This is a starter scaffold, not a production-ready marketplace backend.

Required next steps:
1. Add Laravel Sanctum authentication and role/permission policies (customer, seller, admin).
2. Add seller onboarding, network approval, package management, payments, commissions, wallet ledger and withdrawals.
3. Add voucher credential storage encrypted at application level or via a secrets manager.
4. Implement payment-provider webhook signature validation and reconciliation.
5. Implement reservation expiry and safe release of inventory after failed/expired payments.
6. Add an outbox/queue pattern for reliable voucher delivery and notifications.
7. Add MikroTik connector service with per-network isolated credentials and secure outbound connectivity.
8. Add audit logs, rate limits, monitoring, backups and automated tests.
