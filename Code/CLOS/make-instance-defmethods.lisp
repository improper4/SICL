(cl:in-package #:sicl-clos)

(defmethod make-instance ((class symbol) &rest initargs)
  (apply #'make-instance (find-class class) initargs))


(defmethod make-instance ((class standard-class) &rest initargs)
  (apply #'make-instance-default class initargs))

;;; The HyperSpec only recognizes methods on MAKE-INSTANCE specialized
;;; for SYMBOL and STANDARD-CLASS.  However, the AMOP clearly says
;;; that ENSURE-GENERIC-FUNCTION calls MAKE-INSTANCE, and the default
;;; class that is instantiated is STANDARD-GENERIC-FUNCTION.  But
;;; STANDARD-GENERIC-FUNCTION is not and instance of STANDARD-CLASS,
;;; and instead of FUNCALLABLE-STANDARD-CLASS.
;;;
;;; We have two possible ways of solving this conflict.  Way number 1
;;; (which is what we do here) is to define another method on
;;; MAKE-INSTANCE, in violation of the HyperSpec.  Way number 2 would
;;; be for ENSURE-GENERIC-FUNCTION to call some other function to
;;; instantiate the generic function class, in violation of the AMOP.
;;;
;;; SBCL "solves" this conflict by defining two methods on
;;; make-instance, specialized for SYMBOL and CLASS, again in
;;; violation of the HyperSpec.  So for instance, it is possible to
;;; call (MAKE-INSTANCE 'SYMBOL) in SBCL.  It does not
;;; complain in MAKE-INSTANCE, but in ALLOCATE-INSTANCE.
(defmethod make-instance ((class funcallable-standard-class) &rest initargs)
  (apply #'make-instance-default class initargs))