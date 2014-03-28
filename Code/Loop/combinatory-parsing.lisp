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

;;; A parser is a function that takes a list of tokens to parse, and
;;; that returns three values:
;;;
;;;   * A generalized Boolean indicating whether the parse succeeded.
;;;
;;;   * The result of the parse.  If the parse does not succeed, then
;;;     this value is unspecified.
;;;
;;;   * A list of the tokens that remain after the parse.  If the
;;;     parse does not succeed, then this list contains the original
;;;     list of tokens passed as an argument.

;;; Functions that take one or more parsers as arguments can take
;;; either a function or the name of a function.

(defmacro define-parser (name &body body)
  `(progn
     ;; At compile time, we define a parser that generates an error
     ;; message if invoked.  The reason for doing that is to avoid
     ;; warnings at compile time saying the function does not exist. 
     (eval-when (:compile-toplevel)
       (defun ,name (tokens)
	 (declare (ignore tokens))
	 (error "Undefined parser: ~s" ',name)))
     ;; At load time, we set the FDEFINITION of the name to the
     ;; result of executing BODY.
     (eval-when (:load-toplevel :execute)
       (setf (fdefinition ',name)
	     (progn ,@body)))))

;;; Take a predicate P and return a parser Q that invokes the
;;; predicate on the first token.  If P returns true then Q succeeds
;;; and returns the result of invoking the predicate on the token
;;; together with the remaining tokens (all tokens except the first
;;; one).  If P returns false, then Q fails.  If there are no tokens,
;;; then Q also fails. 
(defun singleton (predicate)
  (lambda (tokens)
    (if (null tokens)
	(values nil nil tokens)
	(let ((result (funcall predicate (car tokens))))
	  (if result
	      (values t result (cdr tokens))
	      (values nil nil tokens))))))

;;; Take a list of parsers P1, P2, ..., Pn and return a parser Q that
;;; invokes Pi in order until one of them succeeds.  If some Pi
;;; succeeds. then Q also succeeds with the same result as Pi.  If
;;; every Pi fails, then Q also fails.
(defun alternative (&rest parsers)
  (lambda (tokens)
    (loop for parser in parsers
	  do (multiple-value-bind (successp result rest)
		 (funcall parser tokens)
	       (when successp
		 (return (values t result rest))))
	  finally (return (values nil nil tokens)))))

;;; Take a function designator (called the COMBINER) and a list of
;;; parsers P1, P2, ..., Pn and return a parser Q that invokes every
;;; Pi in order.  If any Pi fails, then Q fails as well.  If every Pi
;;; succeeds, then Q also succeeds and returns the result of calling
;;; APPLY on COMBINER and the list of results of the invocation of
;;; each Pi.
(defun consecutive (combiner &rest parsers)
  (lambda (tokens)
    (let ((remaining-tokens tokens)
	  (results '()))
      (loop for parser in parsers
	    do (multiple-value-bind (successp result rest)
		   (funcall parser remaining-tokens)
		 (if successp
		     (progn (push result results)
			    (setf remaining-tokens rest))
		     (return (values nil nil tokens))))
	    finally (return (values t
				    (apply combiner (reverse results))
				    remaining-tokens))))))

;;; Take a function designator (called the COMBINER) and a parser P
;;; and return a parser Q that invokes P repeatedly until it fails,
;;; each time with the tokens remaining from the previous invocation.
;;; The result of the invocation of Q is the result of calling APPLY
;;; on COMBINER and the list of the results of each invocation of P.
;;; Q always succeeds.  If the first invocation of P fails, then Q
;;; succeeds returning the result of calling APPLY on COMBINER and the
;;; empty list of results, and the original list of tokens as usual.
(defun repeat (combiner parser)
  (lambda (tokens)
    (let ((remaining-tokens tokens)
	  (results '()))
      (loop do (multiple-value-bind (successp result rest)
		   (funcall parser remaining-tokens)
		 (if successp
		     (progn (push result results)
			    (setf remaining-tokens rest))
		     (return (values t
				     (apply combiner (reverse results))
				     remaining-tokens))))))))


;;;  LocalWords:  parsers