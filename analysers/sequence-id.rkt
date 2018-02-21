#lang racket

(require racket/trace
         racket/hash
         "../byte-utils.rkt")

(define (run packets occurrencies word-size)
  (cond
    ((null? packets) occurrencies)
    (else
     (hash-union (find-all-sequences-in-packet packets word-size 1 occurrencies)
                 (run (cdr packets) occurrencies word-size)
                 #:combine/key (lambda (k v1 v2) (+ v1 v2))))))

(define (find-all-sequences-in-packet packets word-size position occurrencies)
  (cond
    ((= position (+ (length (car packets)) 1)) occurrencies)
    (else
     (hash-union
      (hash-set occurrencies position (count-increments (cdr packets) (car packets) word-size position 10))
      (find-all-sequences-in-packet packets word-size (+ 1 position) occurrencies)
      #:combine/key (lambda (k v1 v2) (+ v1 v2))))))

(define (count-increments packets packet word-size position packets-limit)
  "returns the number of increments at this position in this packet"
  (cond
    ((= packets-limit 0) 0)
    ((null? packets) 0)
    ((> (+ position word-size) (length packet)) 0)
    ((> (+ position word-size) (length (car packets))) 0)
    ((equal?
      (add-one (nth position word-size packet))
      (nth position word-size (car packets)))
     (+ 1 (count-increments (cdr packets) packet word-size position 10)))
    (else
     (+ 0 (count-increments (cdr packets) packet word-size position (- packets-limit 1))))))

(provide run)
