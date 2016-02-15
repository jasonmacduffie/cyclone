;;;; Cyclone Scheme
;;;; https://github.com/justinethier/cyclone
;;;;
;;;; Copyright (c) 2014-2016, Justin Ethier
;;;; All rights reserved.
;;;;
;;;; This module contains the char library from r7rs.
;;;;
(define-library (scheme char)
  (export
    char-alphabetic?
    char-downcase
    char-lower-case?
    char-numeric?
    char-upcase
    char-upper-case?
    char-whitespace?
    digit-value
    string-upcase
    string-downcase
    ; TODO:
    ;string-foldcase
  )
  (import (scheme base))
  (begin
    (define (char-upcase c) ;; ASCII-only
      (if (char-lower-case? c)
        (integer->char
          (- (char->integer c)
              (- (char->integer #\a)
                 (char->integer #\A))))
        c))
    (define (char-downcase c) ;; ASCII-only
      (if (char-upper-case? c)
        (integer->char
          (+ (char->integer c)
              (- (char->integer #\a)
                 (char->integer #\A))))
        c))
    ; TODO: char-foldcase
    (define (char-alphabetic? c) (and (char>=? c #\A) (char<=? c #\z))) ;; ASCII-only
    (define (char-upper-case? c) (and (char>=? c #\A) (char<=? c #\Z))) ;; ASCII-only
    (define (char-lower-case? c) (and (char>=? c #\a) (char<=? c #\z))) ;; ASCII-only
    (define (char-numeric? c) (member c '(#\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9)))
    (define (char-whitespace? c) (member c '(#\tab #\space #\return #\newline)))
    (define (digit-value c)
      (if (char-numeric? c)
          (- (char->integer c) (char->integer #\0))
          #f))
    (define (string-upcase str) (string-map char-upcase str))
    (define (string-downcase str) (string-map char-downcase str))
))
