#lang racket

(require rackunit
         "../analysers/sequence-id.rkt")

(test-case
    "finds sequence id in equal length packets"
  (let ([packets '((#x01 #x02 #x03) (#x02 #x02 #x03))]
        [expected (make-immutable-hash (list (cons 1 1) (cons 3 0) (cons 2 0)))])
    (check-equal? (run packets (make-immutable-hash)) expected)))

(test-case
    "finds sequence id in actual byte packets"
  (let ([packets '((#x01 #x0f #x03) (#x01 #x10 #x03))]
        [expected (make-immutable-hash (list (cons 1 0) (cons 3 0) (cons 2 1)))])
    (check-equal? (run packets (make-immutable-hash)) expected)))

(test-case
    "returns no results if no sequence was found"
  (let ([packets '((#x01 #x02 #x03) (#x01 #x02 #x03))]
        [expected (make-immutable-hash (list (cons 1 0) (cons 3 0) (cons 2 0)))])
    (check-equal? (run packets (make-immutable-hash)) expected)))

(test-case
    "returns no results if there's no second packet"
  (let ([packets '((#x01 #x02 #x03))]
        [expected (make-immutable-hash (list (cons 1 0) (cons 3 0) (cons 2 0)))])
    (check-equal? (run packets (make-immutable-hash)) expected)))

(test-case
    "finds sequence id if packets have different length"
  (let ([packets '((#x01 #x01 #x03) (#x01 #x02))]
        [expected (make-immutable-hash (list (cons 1 0) (cons 3 0) (cons 2 1)))])
    (check-equal? (run packets (make-immutable-hash)) expected)))

(test-case
    "finds sequence id if packets are not one right after the other"
  (let ([packets '((#x00 #x10 #x03)
                   (#x01 #x00)
                   (#x00 #x11)
                   (#x02 #x00 #x04)
                   (#x00 #x12 #x04)
                   (#x03 #x00 #x04)
                   (#x02 #x01 #x04)
                   (#x01 #x11 #x04))]
        [expected (make-immutable-hash (list (cons 1 7) (cons 3 5) (cons 2 6)))])
    (check-equal? (run packets (make-immutable-hash)) expected)))
