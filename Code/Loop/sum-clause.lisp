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

(defclass sum-it-clause
    (accumulate-it-clause numeric-accumulation-mixin)
  ())

(defclass sum-form-clause
    (accumulate-form-clause numeric-accumulation-mixin)
  ())

(defclass sum-it-into-clause
    (accumulate-it-into-clause numeric-accumulation-mixin)
  ())

(defclass sum-form-into-clause
    (accumulate-form-into-clause numeric-accumulation-mixin)
  ())

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Parsers.

(define-parser sum-it-into-clause-parser
  (consecutive (lambda (sum it into var)
		 (declare (ignore sum it into))
		 (make-instance 'sum-it-into-clause
		   :into-var var))
	       (alternative (keyword-parser 'sum)
			    (keyword-parser 'summing))
	       (keyword-parser 'it)
	       (keyword-parser 'into)
	       (singleton #'identity
			  (lambda (x)
			    (and (symbolp x) (not (constantp x)))))))

(define-parser sum-it-clause-parser
  (consecutive (lambda (sum it)
		 (declare (ignore sum it))
		 (make-instance 'sum-it-clause))
	       (alternative (keyword-parser 'sum)
			    (keyword-parser 'summing))
	       (keyword-parser 'it)))

(define-parser sum-form-into-clause-parser
  (consecutive (lambda (sum form into var)
		 (declare (ignore sum into))
		 (make-instance 'sum-form-into-clause
		   :form form
		   :into-var var))
	       (alternative (keyword-parser 'sum)
			    (keyword-parser 'summing))
	       (singleton #'identity (constantly t))
	       (keyword-parser 'into)
	       (singleton #'identity
			  (lambda (x)
			    (and (symbolp x) (not (constantp x)))))))

(define-parser sum-form-clause-parser
  (consecutive (lambda (sum form)
		 (declare (ignore sum))
		 (make-instance 'sum-form-clause
		   :form form))
	       (alternative (keyword-parser 'sum)
			    (keyword-parser 'summing))
	       (singleton #'identity (constantly t))))

(define-parser sum-clause-parser
  (alternative 'sum-it-into-clause-parser
	       'sum-it-clause-parser
	       'sum-form-into-clause-parser
	       'sum-form-clause-parser
