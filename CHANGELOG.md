## [1.0.33] – 2017 – 05 -17

### Added 
-          iOS  Demo App Enhancements
o   New transactions flows added
o   Retrieve transaction
o   Search transactions
o   Update Transactions
o   Capture functionality
-          Manual card entry on PED

### Fixed 
-          Unsettled debit transactions now correctly fall back to void
o   When this void occurs, the entire transaction will be voided, including cashback amounts
o   This must be taken into account by the merchant when processing a void on debit
-          Assorted bug fixes