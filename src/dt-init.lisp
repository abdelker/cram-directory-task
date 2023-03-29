(in-package :dt)

;;(defvar *ctx-designate* nil)
(defvar *robot-name* nil)
(defvar table nil)
(defvar str_sparql nil)

(defvar cheat nil)
(defvar *robot-name* nil)
(defvar lang nil)

(defvar *cubes* nil)
(defvar current-cube nil)
(defvar nb-cubes nil)

(defvar id-mementar-callback nil)
(defvar id-mementar-add-callback nil)

(defvar pick-callback nil)
(defvar add-callback nil)

(defun init-dt (robot-name lang)
  
 ;; (start-ros-node "cram_dt")
  (init-ros-dt)
  (setf *robot-name* robot-name)
  (setf table1 "table_lack")
  (setf cheat nil)

  (onto::init-ontologies-man)
  ;;(onto::init-manager)
  (onto::wait-init)
  (onto::add-onto *robot-name*)
  (onto::get-onto *robot-name*)
  (onto::close-onto)
  (onto::add-onto "human_0")
  (onto::get-onto "human_0")
  (onto::close-onto)
;   (set-ontology)

;   (setf *ctx-designate* nil)

;   (setf *cubes* nil)
;   (setf current-cube nil)
;   (setf nb-cubes 0)

;   (setf id-mementar-callback -1)
;   (setf id-mementar-add-callback -1)

;   (setf pick-callback nil)
;   (setf add-callback nil)

  )
  




