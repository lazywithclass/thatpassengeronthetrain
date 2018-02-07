#lang racket

(require racket/hash)

(define (run packets occurrencies)
  (cond
    ((null? packets) occurrencies)
    (else
     (hash-union (find-all-sequences-in-packet packets 1 occurrencies)
                 (run (cdr packets) occurrencies)
                 #:combine/key (lambda (k v1 v2) (+ v1 v2))))))

(define (find-all-sequences-in-packet packets position occurrencies)
  (cond
    ((= position (+ (length (car packets)) 1)) occurrencies)
    (else
     (hash-union
      (hash-set occurrencies position (count-increments (cdr packets) (car packets) position 10))
      (find-all-sequences-in-packet packets (+ 1 position) occurrencies)
      #:combine/key (lambda (k v1 v2) (+ v1 v2))))))

(define (count-increments packets packet position packets-limit)
  "returns the number of increments at this position in this packet"
  (cond
    ((null? packets) 0)
    ((= packets-limit 0) 0)
    ((= (+ (nth packet position) 1) (nth (car packets) position))
     (+ 1 (count-increments (cdr packets) packet position 10)))
    (else
     (+ 0 (count-increments (cdr packets) packet position (- packets-limit 1))))))

(define (nth l n)
  (cond
    ((null? l) 0)
    ((= n 1) (car l))
    (else (nth (cdr l) (- n 1)))))

(provide run)
