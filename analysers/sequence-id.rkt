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
    ((= position (length (car packets))) occurrencies)
    (else
     (hash-union
      (hash-set occurrencies position (count-increments (cdr packets) (car packets) position 10))
      (find-all-sequences-in-packet packets (+ 1 position) occurrencies)
      #:combine/key (lambda (k v1 v2) (+ v1 v2))))))

(define (count-increments packets packet position packets-limit)
  (cond
    ((null? packets) 0)
    ((null? (cdr packets)) 0)
    ((= packets-limit 0) 0)
    ((= (+ 1 (nth packet position)) (nth (car packets) position))
     (+ 1 (count-increments (cdr packets) (car (cdr packets)) position 10)))
    (else
     (+ 0 (count-increments (cdr packets) (car (cdr packets)) position (- packets-limit 1))))))

(define (nth l n)
  (cond
    ((null? l) 0)
    ((= n 1) (car l))
    (else (nth (cdr l) (- n 1)))))

(provide find-all-sequences-in-packet)
(provide count-increments)
(provide run)
