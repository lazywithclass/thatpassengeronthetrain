#lang racket

(require "reader.rkt"
         "analysers/sequence-id.rkt"
         "printer.rkt")

(let* ([bytes-read (read-bytes-from-stdin)]
       [sequence-ids-1 (run bytes-read (make-immutable-hash) 1)]
       [sequence-ids-2 (run bytes-read (make-immutable-hash) 2)]
       [sequence-ids-4 (run bytes-read (make-immutable-hash) 4)])
  (format-result sequence-ids-1)
  (format-result sequence-ids-2)
  (format-result sequence-ids-4))
