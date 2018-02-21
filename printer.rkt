#lang racket

(require math)

(define (format-result occurrencies)
  (hash-map
   occurrencies
   (lambda (key value)
     (when (not (= value 0))
       (fprintf (current-output-port) "~s increments at byte #~s\n" value key)))))

(provide format-result)
