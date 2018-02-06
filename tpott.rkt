#lang racket

(require "reader.rkt"
         "analysers/sequence-id.rkt"
         "printer.rkt")

(let* ([bytes-read (read-bytes-from-stdin)]
       [sequence-ids (run bytes-read (make-immutable-hash))])
  (format-result sequence-ids (length bytes-read)))
