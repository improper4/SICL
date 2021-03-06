(in-package #:sicl-global-environment)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Macro DEFCONSTANT.
;;;
;;; The HyperSpec says that we have a choice as to whether the
;;; initial-value form is evaluated at compile-time, at load-time, or
;;; both, but that in either case, the compiler must recognize the
;;; name as a constant variable.  We have chosen to evaluate it both
;;; at compile-time and at load-time.  We evaluate it at compile time
;;; so that successive references to the variable can be replaced by
;;; the value.
;;;
;;; This is not the final version of the macro.  For one thing, we
;;; need to handle the optional DOCUMENTATION argument.

(defmacro defconstant (name initial-value &optional documentation)
  (declare (ignore documentation))
  `(eval-when (:compile-toplevel :load-toplevel :execute)
     (defconstant-function ',name ,initial-value)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Macro DEFVAR.
;;;
;;; The HyperSpec says that when DEFVAR is processed as a top-level
;;; form, then the rest of the compilation must treat the variable as
;;; special, but the initial-value form must not be evaluated, and
;;; there must be no assignment of any value to the variable.
;;;
;;; This is not the final version of DEFVAR, because we ignore the
;;; documentation for now.

(defmacro defvar
    (name &optional (initial-value nil initial-value-p) documentation)
  (declare (ignore documentation))
  (if initial-value-p
      `(progn
	 (eval-when (:compile-toplevel)
	   (ensure-defined-variable ,name))
	 (eval-when (:load-toplevel :execute)
	   (unless (boundp ,name)
	     (setf (symbol-value ,name) ,initial-value))))
      `(eval-when (:compile-toplevel :load-toplevel :execute)
	 (ensure-defined-variable ,name))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Macro DEFPARAMETER.
;;;
;;; The HyperSpec says that when DEFPARAMETER is processed as a
;;; top-level form, then the rest of the compilation must treat the
;;; variable as special, but the initial-value form must not be
;;; evaluated, and there must be no assignment of any value to the
;;; variable.
;;;
;;; This is not the final version of DEFPARAMETER, because we ignore
;;; the documentation for now.

(defmacro defparameter (name initial-value &optional documentation)
  (declare (ignore documentation))
  `(progn
     (eval-when (:compile-toplevel)
       (ensure-defined-variable ,name))
     (eval-when (:load-toplevel :execute)
       (setf (symbol-value ,name) ,initial-value))))
