(defpackage :codewordsolver-asd
  (:use :cl :asdf))

(in-package :codewordsolver-asd)

(defsystem codewordsolver
  :license "MIT"
  :author "Kevin Galligan"
  :depends-on (:alexandria)
  :pathname "src"
  :serial t
  :components ((:file "package")
               (:file "solve")))
