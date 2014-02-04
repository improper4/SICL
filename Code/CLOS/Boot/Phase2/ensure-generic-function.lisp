(cl:in-package #:sicl-clos)

(defun ensure-generic-function (function-name &rest args)
  (declare (ignore args))
  (cdr (assoc function-name *generic-functions* :test #'equal)))