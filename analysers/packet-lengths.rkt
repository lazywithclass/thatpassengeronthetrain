#lang racket

(define (run packets occurrencies)
  (cond
    ((null? packets) occurrencies)
    (else
     ())))

;; test if the current byte represents the number of bytes
;; left in this packet
