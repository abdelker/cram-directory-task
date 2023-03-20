(in-package :dt)

(defvar ctx-designate nil)
(defvar table "table_1")
(defvar table1 "table_1")
(defvar str_sparql nil)

(defvar cheat nil)
(defvar robot-name nil)
(defvar lang nil)

(defvar cubes nil)
(defvar current-cube nil)
(defvar nb-cubes nil)

(defvar id-mementar-callback nil)
(defvar id-mementar-add-callback nil)

(defvar pick-callback nil)
(defvar add-callback nil)

(defun init-dt (robot-name lang)

  (setf robot-name robot-name)
  (setf table1 "table_1")
  (setf cheat nil)

  (onto::wait-init)
  (onto::add-onto robot-name)
  (onto::get-onto robot-name)
  (onto::add-onto "human_0")
  (onto::get-onto "human_0")
  (set-ontology)

  (setf cubes nil)
  (setf current-cube nil)
  (setf nb-cubes 0)

  (setf id-mementar-callback -1)
  (setf id-mementar-add-callback -1)

  (setf pick-callback nil)
  (setf add-callback nil)

)


