(cl:in-package #:common-lisp-user)

(defpackage #:sicl-global-environment
  (:nicknames #:sicl-env)
  (:use #:common-lisp)
  ;; When this package is defined in a host implementation for the
  ;; purpose of cross compilation, we shadow the symbols of the
  ;; COMMON-LISP package that name functions and variables that have
  ;; to do with manipulating the environment.
  (:shadow #:type
	   #:proclaim
	   #:macroexpand-1
	   #:macroexpand
	   #:macro-function
	   #:*macroexpand-hook*
	   #:fdefinition
	   #:symbol-function
	   #:fboundp
	   #:fmakunbound
	   #:special-operator-p
	   #:compiler-macro-function
	   #:symbol-value
	   #:boundp
	   #:makunbound
	   #:constantp
	   )
  (:export
   #:proclaim
   #:definition
   #:location
   #:lexical-location #:make-lexical-location
   #:global-location #:make-global-location
   #:special-location #:make-special-location
   #:storage
   #:name
   #:type
   #:*global-environment*
   #:add-to-global-environment
   #:make-entry-from-declaration
   #:find-variable
   #:find-function
   #:macroexpand-1
   #:macroexpand
   #:fully-expand-form
   #:find-type
   #:find-ftype
   #:augment-environment
   #:augment-environment-with-declarations
   #:add-lexical-variable-entry
   #:add-symbol-macro-entry
   #:add-local-function-entry
   #:add-local-macro-entry
   #:add-block-entry
   #:add-go-tag-entry
   #:constant-variable-info
   #:macro-info
   #:symbol-macro-info
   #:block-info
   #:tag-info
   #:location-info
   #:special-location-info
   #:lexical-location-info
   #:global-location-info
   #:function-info
   #:inline-info #:ast #:parameters
   #:variable-info
   #:fdefinition
   #:fboundp
   #:fmakunbound
   #:find-function-cell
   #:special-operator-p
   #:symbol-macro-function
   #:symbol-value
   #:boundp
   #:makunbound
   #:find-value-cell
   #:constantp
   #:defmacro
   #:deftype
   #:define-compiler-macro
   #:ensure-global-function-entry
   ))

