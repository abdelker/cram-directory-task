(in-package :dt)

(defparameter *count* 0)
(defparameter *mvt-duration* 3)
(defparameter *agent-state* "in-progress")
(defparameter *agent-goal* "waitinghuman1")

                  
;;demo

(defun init-dt-demo ()

;;set goal/event to WaitingHuman1

 (occasions-events:on-event (make-instance 'waiting-for-human1))
 (roslisp:loop-at-most-every 1  (occasions-events:on-event (make-instance 'monitor))))


(defun reset-goal ()

;;set goal/event to WaitingHuman1
 (occasions-events:on-event (make-instance 'waiting-for-human1)))


;;event classes for goals

(defclass monitor (occasions-events:event) ())


(defclass waiting-for-human1 (occasions-events:event) ())


(defclass looking-at-cube1 (occasions-events:event) ())


(defclass waiting-for-human2 (occasions-events:event) ())


(defclass looking-at-cube2 (occasions-events:event) ())

;; event classes for cube takes

(defclass wrong-cube-take (occasions-events:event)
 ((no-cube-taken
   :initarg :no-take 
   :reader no-take
   :initform nil)))


(defclass good-cube-take (occasions-events:event) ())


;;event-handlers

(defmethod occasions-events:on-event ((occasions-events:event monitor))
 (write-line "I am monitoring the environment")
 (cond ((string= *agent-state* "in-progress")
        (setf *count* (+ *count* 1)))
       ((reset-goal))))


(defmethod occasions-events:on-event ((occasions-events:event waiting-for-human1))
 (write-line "I am waiting now for human1")
 (cond ((>= *count* (+ *mvt-duration* 2))
        (progn 
               (setf *count* 0)
;;(perform lookobject)
         (princ "looking now at cube1")
         (occasions-events:on-event (make-instance 'looking-at-cube1))))))


(defmethod occasions-events:on-event ((occasions-events:event looking-at-cube1))
 (write-line "I am looking now on cube1")
 (cond ((>= *count* (+ *mvt-duration* 2))
        (progn 
               (setf *count* 0)
;;(perform lookobject)
         (occasions-events:on-event (make-instance 'waiting-for-human2))))))


(defmethod occasions-events:on-event ((occasions-events:event waiting-for-human2))
 (write-line "I am waiting now for human1")
 (cond 
  ((eql *count* *mvt-duration*))
   ;(perform sayWaiting))
   
  ((>= *count* (+ *mvt-duration* 2))
  ;; (perform lookObject)
   (occasions-events:on-event (make-instance 'looking-at-cube2)))))


(defmethod occasions-events:on-event ((occasions-events:event looking-at-cube2))
 (write-line "I am looking now on cube2")
 (cond ((>= *count* (+ *mvt-duration* 2))
        (progn 
         (setf *count* 0)
;;(perform lookobject)))
         (occasions-events:on-event (make-instance 'wrong-cube-take :no-take t))))))


; ;; event-handlers for cube takes

(defmethod occasions-events:on-event ((occasions-events:event wrong-cube-take))
;;(perform lookAt)
 (cond 
  ((eql (no-take event) t))))
   ;(perfom sayNoCubeTake))
   
   ;(perform sayWaiting))
   
 ;; ((perform sayWrongCubeTake))
  ;; (perform lookObject)
  ;; (perform lookExperimentator)
  ;; (perform pointAt)
;;   (perform sayhelp)
  ;; (occasions-events:on-event (make-instance 'looking-at-cube2)))))