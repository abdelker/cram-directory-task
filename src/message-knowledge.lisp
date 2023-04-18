(in-package :dt)

(defparameter *request-msg-desig* (desig:a message (type :request)))

(defun define-message-desig (sentences)
 (let ((u-resp (understand-call sentences)))
  (let ((query (nth 0 u-resp)) (?communicated-action (nth 1 u-resp)))
   (let ((?communicated-object (nth 2 (designate-object query))))
    (cond ((not (string= ?communicated-action ""))
           (setf *request-msg-desig* (copy-designator *request-msg-desig*
                                      :new-description `((:communicated-action ,?communicated-action))))))
    (cond ((not (eql ?communicated-object nil))      
           (setf *request-msg-desig* (copy-designator *request-msg-desig*
                                      :new-description `((:communicated-object ,?communicated-object)))))))))
 (values *request-msg-desig*))
                     