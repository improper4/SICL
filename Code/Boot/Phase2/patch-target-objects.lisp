(cl:in-package #:sicl-boot-phase2)

(defgeneric patch-instance (object))

(defun analogous-target-class (bridge-class)
  (find-target-class (sicl-boot-phase1::class-name bridge-class)))

(defmethod patch-instance (object)
  (let ((bridge-class (heap-instance-class object)))
    (setf (heap-instance-class object)
	  (analogous-target-class bridge-class))))

(defmethod patch-instance ((object standard-object))
  (let* ((bridge-class (heap-instance-class object))
	 (target-class (analogous-target-class bridge-class)))
    (setf (standard-instance-access object 1)
	  (class-slots target-class))
    (call-next-method)))

(defmethod patch-instance ((object standard-generic-function))
  (let ((mc (generic-function-method-class object)))
    (reinitialize-instance
     object
     :method-class (analogous-target-class mc)))
  (call-next-method))

(defun already-patched-p (heap-instance)
  (heap-instance-p
   (heap-instance-class heap-instance)))

(defun patch-target-objects ()
  (let ((seen '()))
    (labels ((traverse (object)
	       (unless (member object seen)
		 (push object seen)
		 (typecase object
		   (heap-instance
		    (unless (already-patched-p object)
		      (patch-instance object))
		    (traverse (heap-instance-class object))
		    (traverse (heap-instance-slots object)))
		   (cons
		    (traverse (car object))
		    (traverse (cdr object)))
		   (vector
		    (loop for element across object
			  do (traverse element)))
		   (t
		    nil)))))
      (loop for obj in (append *target-generic-functions*
			       *target-classes*)
	    do (traverse obj)))))