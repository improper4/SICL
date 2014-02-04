(cl:in-package #:sicl-clos)

;;; The macro DEFINE-BUILT-IN-CLASS expands to a call to this
;;; function, and this function is used only in that situation.  For
;;; that reason, we do not have to be particularly thorough about
;;; checking the validity of arguments.
;;;
;;; The argument DIRECT-SUPERCLASSES is a list of SYMBOLS.  Unlike the
;;; function ENSURE-CLASS we do not allow for class metaobject
;;; superclasses.
;;;
;;; This function is used only during bootstrapping, and bootstrapping
;;; is organized so that the this function will be called only when
;;; the class does not already exist.  Furthermore, the superclasses
;;; (if any) are in the association list *classes*.
(defun ensure-built-in-class (name
			      &rest arguments
			      &key
				direct-superclasses
			      &allow-other-keys)
  (let ((superclasses (loop for name in direct-superclasses
			    for class = (cdr (assoc name *classes*))
			    do (when (null class)
				 ;; This should not happen during
				 ;; bootstrapping.
				 (error "unknown class ~s" name))
			    collect class))
	(remaining-keys (copy-list arguments)))
    (loop while (remf remaining-keys :direct-superclasses))
    ;; During the bootstrapping phase, there is a method on
    ;; INITIALIZE-INSTANCE specialized for BUILT-IN-CLASS, so we can
    ;; safely call MAKE-INSTANCE on BUILT-IN-CLASS here.  Once the
    ;; bootstrapping phase is finished, we remove that method so
    ;; that MAKE-INSTANCE can no longer be used to create built-in
    ;; classes.
    (let ((result (apply #'make-instance 'built-in-class
			 :name name
			 :direct-superclasses superclasses
			 remaining-keys)))
      (push (cons name result) *classes*)
      ;; Since we require for superclasses to exist, and since we
      ;; don't allow for built-in classes to be redefined, we can
      ;; finalize the inheritance immediately. 
      ;; FIXME: uncomment when this function works.
      ;; (finalize-built-in-inheritance result)
      ;; FIXME: this is where we add create the accessors.
      result)))

	
      