#lang racket

(require racket/trace)

(define (nth position word-size packet)
  "returns 1 2 or 4 bytes depending on the dimension"
  (take (list-tail packet (- position 1)) word-size))

(define (add-one bytes)
  "adds one to bytes taking into account the type of that (uint8 uint16 uint32)"
  (define (-add-one bytes to-add)
    (cond
      ((null? bytes) '())
      ((= (car bytes) #xff) (cons #x00 (-add-one (cdr bytes) 1)))
      (else (cons (+ (car bytes) 1) (cdr bytes)))))
  (reverse (-add-one (reverse bytes) 0)))

(provide nth)
(provide add-one)
