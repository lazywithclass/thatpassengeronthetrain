#lang racket

(require math)

(define (format-result result total)
  (print-occurrencies result total))

(define (print-occurrencies occurrencies total)
  (hash-map
   occurrencies
   (lambda (key value)
     (fprintf (current-output-port)
              "~s increments at byte #~s\n" value key))))

(provide format-result)
