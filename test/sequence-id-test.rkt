#lang racket

(require rackunit
         "../analysers/sequence-id.rkt")

(test-case
    "count-increments returns the total increments found at position"
  (let ([packets '((#x01 #x02 #x03) (#x02 #x00 #x04) (#x02 #x03 #x05))])
    (check-equal? (count-increments packets #xff 1) 1)
    (check-equal? (count-increments packets #xff 2) 1)
    (check-equal? (count-increments packets #xff 3) 3)))

(test-case
    "find-all-sequences-in-packet returns all possible sequences positions
in packet"
  (let ([packets '((#x01 #x02 #x03) (#x02 #x02 #x04) (#x02 #x02 #x05))]
        [expected (make-immutable-hash (list (cons 1 1) (cons 3 3) (cons 2 0)))])
    (check-equal? (find-all-sequences-in-packet packets (car packets) 1
                   (make-immutable-hash '())) expected)))

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
  (let ([packets '(
                   (#x01 #x01 #x03)
                   (#x01 #x01)
                   (#x01 #x01)
                   (#x01 #x01 #x04))]
        [expected (make-immutable-hash (list (cons 1 0) (cons 3 1) (cons 2 0)))])
    (check-equal? (run packets (make-immutable-hash)) expected)))
