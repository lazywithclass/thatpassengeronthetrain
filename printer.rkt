#lang racket

(require math)

(define (format-result result total)
  (print-occurrencies result total))

(define (print-occurrencies occurrencies total)
  (hash-map
   occurrencies
   (lambda (key value)
     ;; TODO have a look at what lenses are https://docs.racket-lang.org/lens/lens-intro.html#%28part._.Why_use_lenses_%29
     (when (not (= value 0))
       (fprintf (current-output-port) "~s increments at byte #~s\n" value key)))))

(provide format-result)
