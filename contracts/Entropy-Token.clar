;; Entropy Token - A token with randomly changing supply
;; Simulates thermodynamic entropy through unpredictable supply fluctuations

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-OWNER-ONLY (err u100))
(define-constant ERR-NOT-AUTHORIZED (err u101))
(define-constant ERR-INSUFFICIENT-BALANCE (err u102))
(define-constant ERR-INVALID-AMOUNT (err u103))

;; Data Variables
(define-data-var token-name (string-ascii 32) "Entropy Token")
(define-data-var token-symbol (string-ascii 10) "ENTROPY")
(define-data-var token-decimals uint u6)
(define-data-var total-supply uint u1000000)
(define-data-var last-entropy-block uint u0)

;; Data Maps
(define-map token-balances principal uint)
(define-map allowed-transfers {owner: principal, spender: principal} uint)

;; Private Functions
(define-private (get-entropy-seed)
  (let ((current-block block-height)
        (block-hash (unwrap-panic (get-block-info? id-header-hash (- block-height u1)))))
    (+ current-block (buff-to-uint-be (unwrap-panic (as-max-len? block-hash u8))))
  )
)

(define-private (calculate-entropy-change (seed uint))
  (let ((random-factor (mod seed u100)))
    (if (< random-factor u30)
      ;; 30% chance to decrease supply (entropy increases)
      (/ (var-get total-supply) u10)
      (if (< random-factor u60)
        ;; 30% chance to increase supply (entropy decreases)  
        (/ (var-get total-supply) u20)
        ;; 40% chance no change (equilibrium)
        u0
      )
    )
  )
)

(define-private (apply-entropy-change)
  (let ((current-block block-height)
        (last-block (var-get last-entropy-block)))
    (if (>= (- current-block last-block) u10) ;; Entropy change every 10 blocks
      (let ((seed (get-entropy-seed))
            (change (calculate-entropy-change seed))
            (current-supply (var-get total-supply)))
        (if (< (mod seed u100) u50)
          ;; 50% chance to subtract
          (begin
            (var-set total-supply (if (> current-supply change) (- current-supply change) u1))
            (var-set last-entropy-block current-block)
          )
          ;; 50% chance to add
          (begin  
            (var-set total-supply (+ current-supply change))
            (var-set last-entropy-block current-block)
          )
        )
      )
      false
    )
  )
)

;; Public Functions

;; Get token info
(define-read-only (get-name)
  (ok (var-get token-name))
)

(define-read-only (get-symbol)
  (ok (var-get token-symbol))
)

(define-read-only (get-decimals)
  (ok (var-get token-decimals))
)

(define-read-only (get-total-supply)
  (ok (var-get total-supply))
)

;; Get balance
(define-read-only (get-balance (who principal))
  (ok (default-to u0 (map-get? token-balances who)))
)

;; Transfer function
(define-public (transfer (amount uint) (from principal) (to principal))
  (begin
    (apply-entropy-change)
    (asserts! (is-eq from tx-sender) ERR-NOT-AUTHORIZED)
    (asserts! (> amount u0) ERR-INVALID-AMOUNT)
    (asserts! (not (is-eq to from)) ERR-INVALID-AMOUNT)
    (let ((from-balance (default-to u0 (map-get? token-balances from))))
      (asserts! (>= from-balance amount) ERR-INSUFFICIENT-BALANCE)
      (map-set token-balances from (- from-balance amount))
      (map-set token-balances to (+ (default-to u0 (map-get? token-balances to)) amount))
      (ok true)
    )
  )
)

;; Mint function (owner only)
(define-public (mint (amount uint) (to principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-OWNER-ONLY)
    (asserts! (> amount u0) ERR-INVALID-AMOUNT)
    (asserts! (is-standard to) ERR-INVALID-AMOUNT)
    (apply-entropy-change)
    (var-set total-supply (+ (var-get total-supply) amount))
    (map-set token-balances to (+ (default-to u0 (map-get? token-balances to)) amount))
    (ok true)
  )
)

;; Get current entropy level (how much supply has changed)
(define-read-only (get-entropy-level)
  (let ((current-supply (var-get total-supply))
        (initial-supply u1000000))
    (if (> current-supply initial-supply)
      (ok (- current-supply initial-supply))
      (ok (- initial-supply current-supply))
    )
  )
)

;; Initialize contract
(begin
  (map-set token-balances CONTRACT-OWNER u1000000)
  (var-set last-entropy-block block-height)
)