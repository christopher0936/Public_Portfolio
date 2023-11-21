;Chris McLaughlin - V00912353
#lang racket



;; ===================================== Preamble ======================================

(provide (all-defined-out)) ;; so we can put tests in a second file

;; Definition of structures for MF/PL programs - Do NOT change
(struct var (string) #:transparent) ;; a variable, e.g., (var "foo")
(struct int (num) #:transparent) ;; a constant number, e.g., (int 17)
(struct add (e1 e2) #:transparent) ;; add two expressions
(struct if> (e1 e2 e3 e4) #:transparent) ;; if e1 > e2 then e3 else e4
(struct fun (nameopt formal body) #:transparent) ;; a recursive(?) 1-argument function
(struct call (funexp actual) #:transparent) ;; function call
(struct mlet (var e body) #:transparent) ;; a local binding (let var = e in body)
(struct apair (e1 e2) #:transparent) ;; make a new pair
(struct fst (e) #:transparent) ;; get first part of a pair
(struct snd (e) #:transparent) ;; get second part of a pair
(struct aunit () #:transparent) ;; unit value -- good for ending a list
(struct isaunit (e) #:transparent) ;; evaluate to 1 if e is unit else 0
;; a closure is not in "source" programs; it is what functions evaluate to
(struct closure (env fun) #:transparent)



;; ====================================== Answers ======================================

; 2.1: TODO
(define (mfpl-list->rkt-list lst)
  ;list is apair of apairs. Basic case is a (mfpl_val aunit) pair
  ;if lst is apair then it directly corresponds to a list, if lst is aunit, then it directly corresponds to null, otherwise its just a value for our purposes, which can remain unchanged, recursion is on both elements of pairs to handle nested lists.
  (cond [(apair? lst) (cons (mfpl-list->rkt-list (apair-e1 lst)) (mfpl-list->rkt-list (apair-e2 lst)))]
        [(aunit? lst) null]
        [#t lst]
  )
)

; 2.2: TODO
(define (rkt-list->mfpl-list lst)
  ;Same kinda deal - if lst is a pair then it directly corresponds to an apair, if its null it directly corresponds to a aunit, otherwise it can be treated as just a value
  (cond [(pair? lst) (apair (rkt-list->mfpl-list (car lst)) (rkt-list->mfpl-list (cdr lst)))]
        [(null? lst) (aunit)]
        [#t lst]
  )
)

; 2.3
;; Lookup a variable in an environment
;; Do NOT change this function
(define (envlookup env str)
  (cond
    [(null? env) (error "unbound variable during evaluation" str)]
    [(equal? (car (car env)) str) (cdr (car env))]
    [#t (envlookup (cdr env) str)]))

(define (getextendenv env str e)
  (cons(cons str e) env)
)


; TODO:
;; DO NOT change the two cases given to you.
;; DO add more cases for other kinds of MF/PL expressions.
;; We will test eval-under-env by calling it directly even though
;; "in real life" it would be a helper function of eval-exp (see below).
(define (eval-under-env e env)
  (cond
    [(var? e) (envlookup env (var-string e))]
    [(add? e)
     (let ([v1 (eval-under-env (add-e1 e) env)] [v2 (eval-under-env (add-e2 e) env)])
       (if (and (int? v1) (int? v2))
           (int (+ (int-num v1) (int-num v2)))
           (error "MF/PL addition applied to non-number")
       )
     )
    ]
    ; TODO
    ; add more cases here
    ; one for each type of expression
    ;
    [(int? e) e] ;int is a value
    [(if>? e)
      (let ([v1 (eval-under-env (if>-e1 e) env)] [v2 (eval-under-env (if>-e2 e) env)])
        (if (and (int? v1) (int? v2))
            (if (> (int-num v1) (int-num v2))
              (eval-under-env (if>-e3 e) env)
              (eval-under-env (if>-e4 e) env)
            )
            (error "MF/PL if> applied with e1, e2 not both numbers")
        )
      )
    ]
    [(apair? e) ;value but "special" - recoomputes itself every time, reducing components to values in the process
      (let ([v1 (eval-under-env (apair-e1 e) env)] [v2 (eval-under-env (apair-e2 e) env)])
        (apair v1 v2)
      )
    ]
    [(fst? e) (let ([value (eval-under-env (fst-e e) env)])
      (if (apair? value)
          (apair-e1 value)
          (error "MF/PL fst passed subexpression that did not evaluate to a pair")
      )
    )]
    [(snd? e) (let ([value (eval-under-env (snd-e e) env)])
      (if (apair? value) (apair-e2 value) (error "MF/PL snd passed subexpression that did not evaluate to a pair")))
    ]
    [(aunit? e) e] ;value
    [(isaunit? e) (if (aunit? (eval-under-env (isaunit-e e) env)) (int 1) (int 0))]
    ; var e body
    [(mlet? e) (let ([val-subexpr-e (eval-under-env (mlet-e e) env)])
      (eval-under-env (mlet-body e) (getextendenv env (mlet-var e) val-subexpr-e)))
    ]
    ;nameopt formal body
    [(fun? e) (closure env e)]
    ;env fun
    [(closure? e) e] ;value
    ;funexp actual
    [(call? e) (let ([closure-evald (eval-under-env (call-funexp e) env)]
                     [actual-val (eval-under-env (call-actual e) env)] 
                    )
                    (if (false? (closure? closure-evald))
                        (error "MF/PL call funexp did not evaluate to a closure")
                        ; proceed
                        (if (false? (fun-nameopt (closure-fun closure-evald)))
                            ;anon func
                            (eval-under-env (fun-body (closure-fun closure-evald)) (getextendenv (closure-env closure-evald) (fun-formal (closure-fun closure-evald)) actual-val))
                            ;named func
                            (eval-under-env (fun-body (closure-fun closure-evald)) (getextendenv (
                                                                                                  getextendenv (closure-env closure-evald) (fun-nameopt (closure-fun closure-evald)) closure-evald
                                                                                                 ) (fun-formal (closure-fun closure-evald)) actual-val))
                        )
                    )
               )
    ]

    [#t (error (format "bad MF/PL expression: ~v" e))]))

;; Do NOT change (modify eval-under-env instead!)
;; Note how evaluating an expression start with an empty environment
(define (eval-exp e)
  (eval-under-env e null))









; 2.4: TODO
(define (ifaunit e1 e2 e3)
  ;if e1 > e2 then e3 else e4
  (if> (isaunit e1) (int 0) e2 e3)
)

; 2.5: TODO
(define (mlet* lstlst e2)
  ;var e body
  (if (null? lstlst)
      e2
      (mlet (car (car lstlst)) (cdr (car lstlst)) (mlet* (cdr lstlst) e2))
  )
)

; 2.6: TODO
(define (if= e1 e2 e3 e4)
  (mlet "x" e1 (mlet "y" e2 (if> (var "x") (var "y") e4 (if> (add (var "x") (int 1)) (var "y") e3 e4))))
)

; 2.7: TODO
;; This binding is a bit tricky. it must return a function.
;; the first two lines should be something like this:
;;
;;   (fun "mfpl-map" "f"    ;; it is  function "mfpl-map" that takes a function f
;;       (fun #f "lst"      ;; and it returns an anonymous function
;;          ...
;;
;; also remember that we can only call functions with one parameter, but
;; because they are curried instead of
;;    (call funexp1 funexp2 exp3)
;; we do
;;    (call (call funexp1 funexp2) exp3)
;;
(define mfpl-map
  (fun "mfpl-map" "f"
    (fun #f "lst"
      (ifaunit (var "lst")
               (aunit)
               (apair (call (var "f") (fst (var "lst"))) (call (call (var "mfpl-map") (var "f")) (snd (var "lst"))))
      )
    )
  )
)

; 2.8: TODO
(define mfpl-map-add-N
  (mlet "map" mfpl-map ; (notice map is now in MF/PL scope)
    (fun #f "in-int"
      (fun #f "in-lst"
        (call (call (var "map") (fun #f "x" (add (var "x") (var "in-int")))) (var "in-lst"))
      )
    )
  )
)



;; ==================================== Test suite =====================================
; See prob2_test.rkt
