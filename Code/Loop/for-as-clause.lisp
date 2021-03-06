;;;; Copyright (c) 2014
;;;;
;;;;     Robert Strandh (robert.strandh@gmail.com)
;;;;
;;;; all rights reserved. 
;;;;
;;;; Permission is hereby granted to use this software for any 
;;;; purpose, including using, modifying, and redistributing it.
;;;;
;;;; The software is provided "as-is" with no warranty.  The user of
;;;; this software assumes any responsibility of the consequences. 

(cl:in-package #:sicl-loop)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Clause FOR-AS-CLAUSE.
;;;
;;; The HyperSpec says that a FOR-AS-CLAUSE has the following syntax:
;;;
;;;    for-as-clause ::= {for | as} for-as-subclause {and for-as-subclause}* 
;;;    for-as-subclause::= for-as-arithmetic | for-as-in-list | 
;;;                        for-as-on-list | for-as-equals-then | 
;;;                        for-as-across | for-as-hash | for-as-package 
;;;
;;; For the purpose of specialization, we need different names for the
;;; main clauses as well as for the subclauses, so we alter this
;;; grammar a bit and define it like this instead:
;;;
;;;    for-as-clause::= 
;;;      for-as-arithmetic-clause | for-as-in-list-clause | 
;;;      for-as-on-list-clause | for-as-equals-then-clause | 
;;;      for-as-across-clause | for-as-hash-clause | for-as-package-clause
;;;    
;;;    for-as-arithmetic-clause ::=
;;;      {for | as} for-as-arithmetic {and for-as-subclause}* 
;;;    
;;;    for-as-in-list-clause ::=
;;;      {for | as} for-as-in-list {and for-as-subclause}* 
;;;    
;;;    for-as-on-list-clause ::=
;;;      {for | as} for-as-on-list {and for-as-subclause}* 
;;;    
;;;    for-as-equals-then-clause ::=
;;;      {for | as} for-as-equals-then {and for-as-subclause}* 
;;;    
;;;    for-as-across-clause ::=
;;;      {for | as} for-as-across {and for-as-subclause}* 
;;;
;;;    for-as-hash-clause ::=
;;;      {for | as} for-as-hash {and for-as-subclause}* 
;;;
;;;    for-as-package-clause ::=
;;;      {for | as} for-as-package {and for-as-subclause}* 

(defclass for-as-clause (clause subclauses-mixin variable-clause-mixin) ())

(defclass for-as-subclause (var-and-type-spec-mixin)
  (;; The value of this slot is a list of bindings of the form
   ;; (<variable> <form>) where <variable> is a either the loop
   ;; variable associated with this subclause, or a symbol created by
   ;; GENSYM and <form> depends on the origin of the binding.
   (%bindings :initarg :bindings :reader bindings)
   ;; The value of this slot is a list of declarations (without the
   ;; `declare' symbol).  These declarations go at the beginning of
   ;; the body of the LET form that introduces the bindings. 
   (%declarations :initarg :declarations :reader declarations)
   ;; The value of this slot is a form that goes in the prologue.  It
   ;; contains assignments of values to the loop variables with the
   ;; forms that appear in the subclause.
   (%prologue :initarg :prologue :reader prologue)
   ;; The value of this slot is either NIL, meaning that there is no
   ;; termination condition for this subclause, or a form to be
   ;; evaluated before the iteration of the loop starts.
   (%termination :initarg :termination :reader termination)
   ;; The value of this slot is a form that goes at the end of the
   ;; loop body.
   (%step :initarg :step :reader step)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Manage a list of FOR-AS subclause parsers. 

(defparameter *for-as-subclause-parsers* '())

(defun add-for-as-subclause-parser (parser)
  (push parser *for-as-subclause-parsers*))

;;; A parser that tries every parser in *FOR-AS-SUBCLAUSE-PARSERS* until one
;;; succeeds.

(defun for-as-subclause-parser (tokens)
  (loop for parser in *for-as-subclause-parsers*
	do (multiple-value-bind (successp result rest)
	       (funcall parser tokens)
	     (when successp
	       (return (values t result rest))))
	finally (return (values nil nil tokens))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Parse a FOR-AS clause.

(define-parser for-as-clause-parser
  (consecutive (lambda (for subclause more-subclauses)
		 (declare (ignore for))
		 (make-instance 'for-as-clause
		   :subclauses (cons subclause more-subclauses)))
	       (alternative (keyword-parser 'for)
			    (keyword-parser 'as))
	       'for-as-subclause-parser
	       (repeat* #'list
			(consecutive (lambda (and subclause)
				       (declare (ignore and))
				       subclause)
				     (keyword-parser 'and)
				     'for-as-subclause-parser))))

(add-clause-parser 'for-as-clause-parser)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Expansion methods for FOR-AS clause.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Compute the bindings.

(defmethod bindings ((clause for-as-clause))
  (reduce #'append (mapcar #'bindings (subclauses clause))
	  :from-end t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Compute the declarations.

(defmethod declarations ((clause for-as-clause))
  (reduce #'append (mapcar #'declarations (subclauses clause))
	  :from-end t))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Compute the prologue.

(defmethod prologue ((clause for-as-clause))
  `(progn ,@(mapcar #'prologue (subclauses clause))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Compute the termination.

(defmethod termination ((clause for-as-clause))
  `(progn ,@(mapcar #'termination (subclauses clause))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Compute the body.

(defmethod body ((clause for-as-clause))
  `(progn ,@(mapcar #'body (subclauses clause))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Step a FOR-AS clause.

(defmethod step ((clause for-as-clause))
  (reduce #'append (mapcar #'step (subclauses clause))
	  :from-end t))
