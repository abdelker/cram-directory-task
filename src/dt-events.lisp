(in-package :dt)

(defparameter *count* 0)
(defparameter *mvt-duration* 3)
(defparamter *agent-state* "in-progress")

;;demo




(defun init-dt-demo ()

;;set goal/event to WaitingHuman1

 (on-event (make-instance 'waiting-for-human1))
 (roslisp:loop-at-most-every 1  (on-event (make-instance 'monitor))))


(defun reset-goal ()

;;set goal/event to WaitingHuman1
 (on-event (make-instance 'waiting-for-human1)))


;;event classes for goals

(defclass monitor (event) ())


(defclass waiting-for-human1 (event) ())


; (defclass looking-at-cube1 (event))


; (defclass waiting-for-human2 (event))


; (defclass looking-at-cube2 (event))

; ;; event classes for cube takes

; (defclass wrong-cube-take (event)
;  ((no-cube-taken
;    :init-arg :no-take :reader no-take
;    :init-form nil)))


; (defclass good-cube-take (event))


;;event-handlers

(defmethod on-event ((event monitor))
 (write-line "I am monitoring")
 (cond ((string= *agent-state* "in-progress")
        (setf *count* (+ count 1)))
       ((reset-goal))))


(defmethod on-event ((event waiting-for-human1))
 (cond ((>= *count* (+ *mvt-duration* 2))
        (progn 
               (setf *count* 0)
;;(perform lookobject)
         (princ "waiting for human")))))
        ;; (on-event (make-instance 'looking-at-cube1))))))


; (defmethod on-event ((event looking-at-cube1))
;  (setf *count* 0)
; ;;(perform lookobject)
;  (on-event (make-instance 'waiting-for-human2)))


; (defmethod on-event ((event waiting-for-human2))
;  (cond 
;   ((eql *count* *mvt-duration*))
;    ;(perform sayWaiting))
   
;   ((>= *count* (+ *mvt-duration* 2))
;   ;; (perform lookObject)
;    (on-event (make-instance 'looking-at-cube2)))))


; (defmethod on-event ((event looking-at-cube2))
;  (setf *count* 0)
; ;;(perform lookobject)
;  (on-event (make-instance 'wrong-cube-take)))


; ;; event-handlers for cube takes

; (defmethod on-event ((event wrong-cube-take))
; ;;(perform lookAt)
;  (cond 
;   ((eql (no-take event) t))))
;    ;(perfom sayNoCubeTake))
   
;    ;(perform sayWaiting))
   
;  ;; ((perform sayWrongCubeTake))
;   ;; (perform lookObject)
;   ;; (perform lookExperimentator)
;   ;; (perform pointAt)
; ;;   (perform sayhelp)
;   ;; (on-event (make-instance 'looking-at-cube2)))))