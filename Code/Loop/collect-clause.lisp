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

(defclass collect-it-clause
    (accumulate-it-clause list-accumulation-mixin)
  ())

(defclass collect-form-clause
    (accumulate-form-clause list-accumulation-mixin)
  ())

(defclass collect-it-into-clause
    (accumulate-it-into-clause list-accumulation-mixin)
  ())

(defclass collect-form-into-clause
    (accumulate-form-into-clause list-accumulation-mixin)
  ())

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Parsers.

(define-parser collect-it-into-clause-parser
  (consecutive (lambda (collect it into var)
		 (declare (ignore collect it into))
		 (make-instance 'collect-it-into-clause
		   :into-var var))
	       (alternative (keyword-parser 'collect)
			    (keyword-parser 'collecting))
	       (keyword-parser 'it)
	       (keyword-parser 'into)
	       (singleton #'identity
			  (lambda (x)
			    (and (symbolp x) (not (constantp x)))))))

(define-parser collect-it-clause-parser
  (consecutive (lambda (collect it)
		 (declare (ignore collect it))
		 (make-instance 'collect-it-clause))
	       (alternative (keyword-parser 'collect)
			    (keyword-parser 'collecting))
	       (keyword-parser 'it)))

(define-parser collect-form-into-clause-parser
  (consecutive (lambda (collect form into var)
		 (declare (ignore collect into))
		 (make-instance 'collect-form-into-clause
		   :form form
		   :into-var var))
	       (alternative (keyword-parser 'collect)
			    (keyword-parser 'collecting))
	       (singleton #'identity (constantly t))
	       (keyword-parser 'into)
	       (singleton #'identity
			  (lambda (x)
			    (and (symbolp x) (not (constantp x)))))))

(define-parser collect-form-clause-parser
  (consecutive (lambda (collect form)
		 (declare (ignore collect))
		 (make-instance 'collect-form-clause
		   :form form))
	       (alternative (keyword-parser 'collect)
			    (keyword-parser 'collecting))
	       (singleton #'identity (constantly t))))

(define-parser collect-clause-parser
  (alternative 'collect-it-into-clause-parser
	       'collect-it-clause-parser
	       'collect-form-into-clause-parser
	       'collect-form-clause-parser))

