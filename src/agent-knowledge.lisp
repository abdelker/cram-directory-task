(in-package :dt)

(defvar *agent1-desig* nil)

(defun define-agent-desig (agent-name)
 (let ((agent-role (svref (onto::get-on agent-name "hasRole" agent-name) 0)))
  (let ((?agent-name agent-name) (?agent-role agent-role))
   (setf *agent1-desig*
    (desig:an agent (type :human) 
                    (:name ?agent-name) 
                    (:role ?agent-role))))))
                         
