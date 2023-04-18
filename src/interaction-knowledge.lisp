(in-package :dt)

(defparameter *you-interact-desig* nil)
(defparameter *me-interact-desig* nil)

(defun construct-you-interaction-designator (agent-name message)
 (let ((?from-agent-desig (construct-agent-desig agent-name)) 
       (?from-msg-desig (construct-message-desig message)))
   (setf *you-interact-desig*
    (desig:an interaction (type :receiving) 
                          (:from-agent ?from-agent-desig)
                          (:with-content message) 
                          (:from-msg ?from-msg-desig)))))

(defun construct-me-interaction-designator ()
 (cond ((eql *you-interact-desig* nil)
        (write-line "There is nothing to reply to"))
       ((progn 
         (let ((?to-agent-desig (desig-prop-value *you-interact-desig* :from-agent)) 
               (?to-msg-desig (desig-prop-value *you-interact-desig* :from-msg)))
          (setf *me-interact-desig*
           (desig:an interaction (type :replying) 
                                 (:to ?to-agent-desig)
                                 (:with-content message) 
                                 (:to-msg ?to-msg-desig))))))))
                          