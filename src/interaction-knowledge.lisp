(in-package :dt)

(defvar *interact-desig* nil)

(defun define-interaction-designator (agent-name message)
 (let ((?agent-desig (define-agent-desig agent-name)) 
       (?msg-desig (define-message-desig message)))
   (setf *interact-desig*
    (desig:an interaction (type :receiving) 
                (:from ?agent-desig) 
                (:msg ?msg-desig)))))
                         