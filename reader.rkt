#lang racket

(define (to-bytes line)
  (map string->number (string-split line ":")))

(define (read-bytes-from-stdin)
  (define line (read-line (current-input-port) 'any))
  (cond
    ((eof-object? line) '())
    (else (cons (to-bytes line) (read-bytes-from-stdin)))))

(provide read-bytes-from-stdin)
