;; Route Optimization Contract

(define-map routes
  { route-id: uint }
  {
    stops: (list 20 (tuple (lat int) (lng int))),
    estimated-duration: uint,
    assigned-vehicle: uint
  }
)

(define-data-var route-nonce uint u0)

(define-public (create-route (stops (list 20 (tuple (lat int) (lng int)))) (estimated-duration uint))
  (let
    ((new-id (+ (var-get route-nonce) u1)))
    (map-set routes
      { route-id: new-id }
      {
        stops: stops,
        estimated-duration: estimated-duration,
        assigned-vehicle: u0
      }
    )
    (var-set route-nonce new-id)
    (ok new-id)
  )
)

(define-public (update-route (route-id uint) (new-stops (list 20 (tuple (lat int) (lng int)))) (new-duration uint))
  (let
    ((route (unwrap! (map-get? routes { route-id: route-id }) (err u404))))
    (map-set routes
      { route-id: route-id }
      (merge route { stops: new-stops, estimated-duration: new-duration })
    )
    (ok true)
  )
)

(define-public (assign-vehicle-to-route (route-id uint) (vehicle-id uint))
  (let
    ((route (unwrap! (map-get? routes { route-id: route-id }) (err u404))))
    (map-set routes
      { route-id: route-id }
      (merge route { assigned-vehicle: vehicle-id })
    )
    (ok true)
  )
)

(define-read-only (get-route (route-id uint))
  (map-get? routes { route-id: route-id })
)

