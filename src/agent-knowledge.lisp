(in-package :dt)

(defvar *you-agent-desig* nil)

(defun construct-you-agent-desig (agent-name)
 (let ((agent-role (svref (onto::get-on agent-name "hasRole" agent-name) 0)))
  (let ((?agent-name agent-name) (?agent-role agent-role))
   (setf *you-agent-desig*
    (desig:an agent (type :human) 
                    (:name ?agent-name) 
                    (:role ?agent-role))))))
                         
