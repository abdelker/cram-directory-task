(in-package :dt)

(defvar *msg-desig* nil)

(defun define-message-desig (sentences)
 (let ((u-resp (understand-call sentences)))
  (let ((query (nth 0 u-resp)) (?communicated-action (nth 1 u-resp)))
   (let ((?communicated-object (get-object query "?0")))
    (setf *msg-desig*
     (desig:a message (type :request) 
                     (:communicated-action ?communicated-action) 
                     (:communicated-object ?communicated-object)))))))

