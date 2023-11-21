;Chris McLaughlin - V00912353
#lang racket



;; ====================================== Answers ======================================

; 1.1: TODO
; Streams are of form thunk(val1,thunk(val2,thunk(...)))
(define (stream-for-n-steps s n)
  (if (= n 1)
    ;then
    (cons (car (s)) null)
    ;else
    (cons (car (s)) (stream-for-n-steps (cdr (s)) (+ n -1)))
  )
)

; 1.2: TODO
; Streams are of form thunk(val1,thunk(val2,thunk(...)))
; iterative fib func from class examples used as inspiration
(define fibo-stream
  (letrec
    (
      [f (lambda (acc1 acc2)
        (if (and (= acc1 0) (= acc2 0))
          ;then
          (cons 0 (lambda () (f 1 0)))
          ;else
          (cons (+ acc1 acc2) (lambda () (f acc2 (+ acc1 acc2))))
        )
      )
      ]
    )
    (lambda () (f 0 0))
  )
)

; 1.3: TODO
(define (filter-stream f s)
  (if (f (car (s)))
    ;then
    (lambda () (cons (car (s)) (filter-stream f (cdr (s)))))
    ;else
    (filter-stream f (cdr (s)))
  )
)

; 1.4: TODO
;(define create-stream #f) ; replace define with macro definition
(define-syntax create-stream
  (syntax-rules (using starting at with increment)
    [(create-stream stream-name using f starting at i0 with increment delta)
      (define (stream-name)
          (letrec([funct (lambda (val_i) (cons (f val_i) (lambda () (funct(+ val_i delta)))))])
            (funct i0))
      )
    ]
  )
)


;; ==================================== Test suite =====================================

(require rackunit)

;; Sample stream for testing stream-for-n-steps
(define nat-num-stream (letrec ([f (lambda (x) (cons x (lambda () (f (+ x 1)))))]) (lambda () (f 0))))

;; Test create-stream macro
(create-stream squares using (lambda (x) (* x x)) starting at 5 with increment 2)

(define tests
  (test-suite "Sample tests for A3 P1"
   (check-equal? (stream-for-n-steps nat-num-stream 10)
                 '(0 1 2 3 4 5 6 7 8 9)
                 "stream-for-n-steps test")
   (check-equal? (stream-for-n-steps fibo-stream 10) 
                 '(0 1 1 2 3 5 8 13 21 34) 
                 "fibo-stream test")
   (check-equal? (stream-for-n-steps (filter-stream (lambda (i) (> i 5)) nat-num-stream) 5)
                 '(6 7 8 9 10)
                 "filter stream test")
   (check-equal? (stream-for-n-steps squares 5)
                 '(25 49 81 121 169)
                 "stream defined using a macro. only tests is return value")
  )
)

;; Run the tests
(require rackunit/text-ui)
(run-tests tests)
