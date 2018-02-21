#lang racket

(require rackunit
         "../byte-utils.rkt")

(test-case
    "nth given a dimension and a packet returns the proper byte"
  (let ([packet '(#x01 #x02 #x03 #x04)])
    (check-equal? (nth 1 1 packet) '(#x01))
    (check-equal? (nth 1 2 packet) '(#x01 #x02))
    (check-equal? (nth 1 4 packet) packet)))

(test-case
    "nth given an offset a dimension and a packet returns the proper byte"
  (let ([packet '(#x01 #x02 #x03 #x04 #x05 #x06 #x07 #x08 #x09)])
    (check-equal? (nth 1 1 packet) '(#x01))
    (check-equal? (nth 3 2 packet) '(#x03 #x04))
    (check-equal? (nth 6 4 packet) '(#x06 #x07 #x08 #x09))))

(test-case
    "add-one given a number of bytes adds one to that"
  (check-equal? (add-one '(#x00)) '(#x01))
  (check-equal? (add-one '(#x01)) '(#x02))
  (check-equal? (add-one '(#xff)) '(#x00))
  (check-equal? (add-one '(#x00 #x00)) '(#x00 #x01))
  (check-equal? (add-one '(#x00 #xff)) '(#x01 #x00))
  (check-equal? (add-one '(#xff #xff)) '(#x00 #x00))
  (check-equal? (add-one '(#xff #xff #xff #xff)) '(#x00 #x00 #x00 #x00))
  (check-equal? (add-one '(#xff #xff #xff #x01)) '(#xff #xff #xff #x02))
  (check-equal? (add-one '(#x00 #xff #xff #xff)) '(#x01 #x00 #x00 #x00))
  (check-equal? (add-one '(#x00 #xff #xff #xff)) '(#x01 #x00 #x00 #x00))
  (check-equal? (add-one '(#x00 #x00 #x01 #xff)) '(#x00 #x00 #x02 #x00)))
