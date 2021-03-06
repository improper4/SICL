(cl:in-package #:common-lisp-user)

(defpackage #:cleavir-mir
  (:use #:common-lisp)
  (:export
   #:datum
   #:immediate-input
   #:word-input
   #:constant-input #:make-constant-input
   #:value
   #:lexical-location #:make-lexical-location
   #:simple-location #:make-simple-location #:new-temporary
   #:captured-location #:make-captured-location
   #:name
   #:special-location #:make-special-location
   #:global-input #:make-global-input
   #:load-time-input
   #:external-input #:make-external-input
   #:register-location
   #:static-location
   #:dynamic-location
   #:layer #:index
   #:insert-instruction-before
   #:insert-instruction-between
   #:insert-instruction-after
   #:delete-instruction
   #:reinitialize-data
   #:instruction
   #:no-successors-mixin
   #:one-successor-mixin
   #:two-successors-mixin
   #:inputs #:outputs
   #:successors #:predecessors
   #:enter-instruction #:make-enter-instruction #:lambda-list
   #:nop-instruction #:make-nop-instruction
   #:assignment-instruction #:make-assignment-instruction
   #:funcall-instruction #:make-funcall-instruction
   #:tailcall-instruction #:make-tailcall-instruction
   #:get-values-instruction #:make-get-values-instruction
   #:return-instruction #:make-return-instruction
   #:enclose-instruction #:make-enclose-instruction #:code
   #:typeq-instruction #:make-typeq-instruction #:value-type
   #:catch-instruction #:make-catch-instruction
   #:unwind-instruction #:make-unwind-instruction
   #:eq-instruction #:make-eq-instruction
   #:phi-instruction #:make-phi-instruction
   #:fixnum-+-instruction #:make-fixnum-+-instruction
   #:fixnum---instruction #:make-fixnum---instruction
   #:fixnum-<-instruction #:make-fixnum-<-instruction
   #:fixnum-<=-instruction #:make-fixnum-<=-instruction
   #:fixnum-=-instruction #:make-fixnum-=-instruction
   #:car-instruction #:make-car-instruction
   #:cdr-instruction #:make-cdr-instruction
   #:rplaca-instruction #:make-rplaca-instruction
   #:rplacd-instruction #:make-rplacd-instruction
   #:slot-read-instruction #:make-slot-read-instruction
   #:slot-write-instruction #:make-slot-write-instruction))

(defpackage #:cleavir-mir-graphviz
  (:use #:common-lisp #:cleavir-mir)
  (:export
   #:draw-flowchart))
