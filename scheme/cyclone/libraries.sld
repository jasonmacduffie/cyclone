(define-library (scheme cyclone libraries)
  (import (scheme base)
          ; TODO: what else? definitely need trans.scm
  )
  (export
    ;; TODO: get these from library scm file
;(define (library? ast)
;(define (lib:name ast) (cadr ast))
;(define (lib:name->string name)
;(define (lib:name->symbol name)
;(define (lib:result result)
;(define (lib:exports ast)
;(define (lib:imports ast)
;(define (lib:body ast)
;(define (lib:includes ast)
;(define (lib:import->filename import . ext)
;(define (lib:import->path import)
;(define (lib:read-imports import)
;(define (lib:import->export-list import)
;(define (lib:resolve-imports imports)
;(define (lib:get-all-import-deps imports)
;(define (lib:get-dep-list libs/deps)
  )
  (include "../../libraries.scm")
  ;(begin
  ;  (define read cyc-read))
)