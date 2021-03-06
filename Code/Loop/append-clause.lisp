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

(defclass append-it-clause
    (accumulate-it-clause list-accumulation-mixin)
  ())

(defclass append-form-clause
    (accumulate-form-clause list-accumulation-mixin)
  ())

(defclass append-it-into-clause
    (accumulate-it-into-clause list-accumulation-mixin)
  ())

(defclass append-form-into-clause
    (accumulate-form-into-clause list-accumulation-mixin)
  ())

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Parsers.

(define-parser append-it-into-clause-parser
  (consecutive (lambda (append it into var)
		 (declare (ignore append it into))
		 (make-instance 'append-it-into-clause
		   :into-var var))
	       (alternative (keyword-parser 'append)
			    (keyword-parser 'appending))
	       (keyword-parser 'it)
	       (keyword-parser 'into)
	       (singleton #'identity
			  (lambda (x)
			    (and (symbolp x) (not (constantp x)))))))

(define-parser append-it-clause-parser
  (consecutive (lambda (append it)
		 (declare (ignore append it))
		 (make-instance 'append-it-clause))
	       (alternative (keyword-parser 'append)
			    (keyword-parser 'appending))
	       (keyword-parser 'it)))

(define-parser append-form-into-clause-parser
  (consecutive (lambda (append form into var)
		 (declare (ignore append into))
		 (make-instance 'append-form-into-clause
		   :form form
		   :into-var var))
	       (alternative (keyword-parser 'append)
			    (keyword-parser 'appending))
	       (singleton #'identity (constantly t))
	       (keyword-parser 'into)
	       (singleton #'identity
			  (lambda (x)
			    (and (symbolp x) (not (constantp x)))))))

(define-parser append-form-clause-parser
  (consecutive (lambda (append form)
		 (declare (ignore append))
		 (make-instance 'append-form-clause
		   :form form))
	       (alternative (keyword-parser 'append)
			    (keyword-parser 'appending))
	       (singleton #'identity (constantly t))))

(define-parser append-clause-parser
  (alternative 'append-it-into-clause-parser
	       'append-it-clause-parser
	       'append-form-into-clause-parser
	       'append-form-clause-parser))

