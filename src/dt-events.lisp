(in-package :dt)

(defparameter *count* 0)
(defparameter *mvt-duration* 3)


;;event classes for goals

(defclass waiting-for-human1 (event))


(defclass looking-at-cube1 (event))


(defclass waiting-for-human2 (event))


(defclass looking-at-cube2 (event))

;; event classes for cube takes

(defclass wrong-cube-take (event))

(defclass good-cube-take (event))


;;event-handlers

(defmethod on-event ((event waiting-for-human1))
 (setf *count* 0)
;;(perform lookobject)
 (on-event (make-instance 'looking-at-cube1)))


(defmethod on-event ((event looking-at-cube1))
 (setf *count* 0)
;;(perform lookobject)
 (on-event (make-instance 'waiting-for-human2)))


(defmethod on-event ((event waiting-for-human2))
 (cond 
  ((eql *count* *mvt-duration*))
   ;(perform sayWaiting))
   
  ((>= *count* (+ *mvt-duration* 2))
  ;; (perform lookObject)
   (on-event (make-instance 'looking-at-cube2)))))


(defmethod on-event ((event looking-at-cube2))
 (setf *count* 0)
;;(perform lookobject)
 (on-event (make-instance 'wrong-cube-take)))


;; event-handlers for cube takes

(defmethod on-event ((event wrong-cube-take))
 (cond 
  ((eql *count* *mvt-duration*))
   ;(perform sayWaiting))
   
  ((>= *count* (+ *mvt-duration* 2))
  ;; (perform lookObject)
   (on-event (make-instance 'looking-at-cube2)))))