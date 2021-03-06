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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Clauses FOR-AS-HASH-CLAUSE and FOR-AS-HASH

(defclass for-as-hash-clause (for-as-clause) ())

(defclass for-as-hash (for-as-subclause)
  ((%hash-table-form :initarg :hash-table-form :reader hash-table-form)
   (%other-var :initarg :other-var :reader other-var)))

(defclass for-as-hash-key (for-as-hash) ())

(defclass for-as-hash-value (for-as-hash) ())
