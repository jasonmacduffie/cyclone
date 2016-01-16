; TODO:
; try having multiple producers writing to a queue, and 
; a consumer reading from it
; an important consideration is how to let the producers write values, since they would be on their stacks! 
; ideally do not want the application to have to worry about what value came from what thread...

(import 
  (scheme base)
  (scheme read)
  (scheme write)
  (srfi 18))


(define *lock* (make-mutex))
(define *queue* (->heap (list)))

(define (producer)
  (let loop ((n 10))
    (cond
      ((> n 0)
       (mutex-lock! *lock*)
       (set! *queue* (->heap (cons (->heap n) *queue*)))
       (mutex-unlock! *lock*)
       (loop (- n 1)))
      (else
        (write "producer thread done")))))

(define (consumer)
  (let loop ()
    ;(write (list (null? *queue*) *queue*))
    (define sleep? #f)
    ;; looks like the main issue is a macro expansion problem, because cond never expands below. WTF?
    ;; above named let works fine, and this one does too if expressions are removed or re-ordered 
    ;; between the named let and the cond.
    ;;
    ;; 2 issues here:
    ;; - the mutex-lock seems to skip over cond; there is some kind of
    ;;   control flow problem
    ;; - try compiling this but commenting out the Cyc_mutex_lock
    ;;   code in the C. there is a gc_move bag tag error at runtime
    ;;   also get the same result by using read-char below... WTF?
    (read-char) ;(mutex-lock! *lock*)`
    (cond
      ((not (null? *queue*))
       (write (car *queue*))
       (set! *queue* (cdr *queue*)))
      (else
       (write "consumer sleeping")
       (set! sleep? #t)))
    (mutex-unlock! *lock*)
    (if sleep? (thread-sleep! 1000))
    (loop)
    ))

;(thread-start! (make-thread producer))
;(producer)   
(consumer)
;(read)