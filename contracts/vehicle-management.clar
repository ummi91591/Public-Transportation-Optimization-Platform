;; Vehicle Management Contract

(define-map vehicles
  { vehicle-id: uint }
  {
    type: (string-ascii 20),
    capacity: uint,
    current-location: (tuple (lat int) (lng int)),
    status: (string-ascii 20),
    current-route: uint
  }
)

(define-data-var vehicle-nonce uint u0)

(define-public (register-vehicle
  (type (string-ascii 20))
  (capacity uint))
  (let
    ((new-id (+ (var-get vehicle-nonce) u1)))
    (map-set vehicles
      { vehicle-id: new-id }
      {
        type: type,
        capacity: capacity,
        current-location: (tuple (lat 0) (lng 0)),
        status: "inactive",
        current-route: u0
      }
    )
    (var-set vehicle-nonce new-id)
    (ok new-id)
  )
)

(define-public (update-vehicle-location (vehicle-id uint) (lat int) (lng int))
  (let
    ((vehicle (unwrap! (map-get? vehicles { vehicle-id: vehicle-id }) (err u404))))
    (map-set vehicles
      { vehicle-id: vehicle-id }
      (merge vehicle { current-location: (tuple (lat lat) (lng lng)) })
    )
    (ok true)
  )
)

(define-public (update-vehicle-status (vehicle-id uint) (new-status (string-ascii 20)))
  (let
    ((vehicle (unwrap! (map-get? vehicles { vehicle-id: vehicle-id }) (err u404))))
    (map-set vehicles
      { vehicle-id: vehicle-id }
      (merge vehicle { status: new-status })
    )
    (ok true)
  )
)

(define-public (assign-route (vehicle-id uint) (route-id uint))
  (let
    ((vehicle (unwrap! (map-get? vehicles { vehicle-id: vehicle-id }) (err u404))))
    (map-set vehicles
      { vehicle-id: vehicle-id }
      (merge vehicle { current-route: route-id })
    )
    (ok true)
  )
)

(define-read-only (get-vehicle (vehicle-id uint))
  (map-get? vehicles { vehicle-id: vehicle-id })
)

