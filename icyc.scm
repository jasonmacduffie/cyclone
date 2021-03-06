;;;; Cyclone Scheme
;;;; https://github.com/justinethier/cyclone
;;;;
;;;; Copyright (c) 2014-2016, Justin Ethier
;;;; All rights reserved.
;;;;
;;;; This module contains a simple Read-Eval-Print Loop
;;;;
(import (scheme cyclone common)
        (scheme cyclone libraries)
        (scheme base)
        (scheme char)
        (scheme lazy)
        (scheme load)
        (scheme read)
        (scheme write)
        (scheme inexact)
        (scheme process-context)
        (scheme time)
        (scheme eval)
        (srfi 69))
(cond-expand
  (cyclone
    (display *Cyc-version-banner*))
  (else #f))

(define *icyc-env* (setup-environment))
(define (repl:next-line)
  (call/cc
    (lambda (k)
      (with-exception-handler
        (lambda (obj)
          (display "Error: ")
          (cond
            ((pair? obj)
             (for-each
               (lambda (o)
                 (display o)
                 (display " "))
               obj))
            (else
              (display obj)))
          (display "\n")
          (k #t))
        (lambda ()
          (repl)))))
  (repl:next-line))

(define (repl)
  (display "cyclone> ")
  (let ((c (eval (read) *icyc-env*)))
    (cond
      ((not (eof-object? c))
       (write c)
       (newline)
       (repl:next-line))
      (else 
        (display "\n")
        (exit 0)))))

(repl:next-line)
