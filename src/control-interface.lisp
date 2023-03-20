(in-package :dt)


(defun designateCube (sentences)
  (setq response-understand-srv (call-understand-srv sentences))
  (setq action (slot-value response-understand-srv 'KNOWLEDGE_SHARING_PLANNER_MSGS-SRV:ACTION))
  (setq sparql (slot-value response-understand-srv 'KNOWLEDGE_SHARING_PLANNER_MSGS-SRV:SPARQLQUERY))
  (setq result "")
  (setq state nil)
  ;; (cond 
  ;;((not ctx-designate)
  (setq ctx-designate (vector (format nil "?0 isAbove ~a" table1)
                              "?0 isInContainer ?1"
                              "?1 isA VisibleDtBox"))
        ;;  ))
        
  (setq response-merge-srv (call-merge-srv sparql ctx-designate nil))
  (setq merge-sparql (slot-value response-merge-srv 'KNOWLEDGE_SHARING_PLANNER_MSGS-SRV:MERGED_QUERY))
  (setq response-sparql-srv (call-sparql-srv merge-sparql))
  (setq matches (slot-value response-sparql-srv 'ONTOLOGENIUS-SRV:RESULTS))
  (cond
   ((> (length matches) 1)
    (progn
      (terpri)
      (princ "I am not sure of what you are speaking about...")
      (terpri)
      (setq new-context merge-sparql)
      (setq question "")
      ;;(setq onematch 
      (loop for
            match
            in
            (coerce matches 'list)
            do
            ;;(
            (setq response-disambiguate-srv (call-disambiguate-srv match new-context))
            (terpri)
            (princ "Sparql result: ")
            (terpri)
            (princ (setq sparql-result (slot-value response-disambiguate-srv 'KNOWLEDGE_SHARING_PLANNER_MSGS-SRV:SPARQLRESULT)))
            (setq ambiguous (slot-value response-disambiguate-srv 'KNOWLEDGE_SHARING_PLANNER_MSGS-SRV:AMBIGUOUS))
            (cond
             ((not (coerce ambiguous 'list))
              (setq match-sparql sparql-result))
             ((progn
                (setq result "not understand")
                (princ result)
                (terpri)
                ;;(return action)
                (values state result action))))
            (terpri)
            (princ "sparql : ")
            (princ match-sparql)
            (terpri)
            (setq response-merge-match-srv (call-merge-srv match-sparql new-context t))
            (setq match-sparql (slot-value response-merge-match-srv 'KNOWLEDGE_SHARING_PLANNER_MSGS-SRV:MERGED_QUERY))
            (setq response-verbalize-srv (call-verbalize-srv match-sparql))
            (setq question-part (slot-value response-verbalize-srv 'KNOWLEDGE_SHARING_PLANNER_MSGS-SRV:VERBALIZATION))
            (princ "Question part : ")
            (princ question-part)
            (terpri)
            (cond
             ((string= question "")
              (setq question question-part))
             ((setq question (concatenate 'string question ", or, " question-part)))))
      (princ "Do you mean : ")
      (princ question)
      (princ "?")
      (setq ctx-designate new-context)
      (values state question action)))
   ((= (length matches) 1)
    (progn
      (terpri)
      (princ "cube find:")
      (terpri)
      (princ matches)
      (setq ctx-designate nil)
      (setq state t)
      (values state matches action)))
   ((progn
      (setq result "not understand")
      (princ result)
      (terpri)
      (setq state nil)
      (values state result action)))))

(defun set-ontology ()

 (cond 
   ((eq cheat t)
    (progn
      (setf onto (onto::get-onto robot-name))
      (setf onto (onto::set-lang lang))))
  
  
   (progn
     (setf onto (onto::get-onto "human_0"))
     (setf onto (onto::set-lang lang)))))

(defun change-context ()

 (princ "--> Change ctx")
 (setf cheat (not cheat))
 (princ (concatenate 'string "cheat :" cheat))
 (set-ontology)
 (update-cube-list))

(defun update-cube-list ()

 (cond 
  ((eq cheat t)
   (progn 
    (setf cubes (onto::get-from "isAbove" table1 "Cube")) 
    (princ (concatenate 'string "list cubes :" cubes))
    (setf cubes nil)
    (loop for cube in cubes do
     (setf boxes (onto::get-from "containerHasIn" cube "VisibleDtBox"))
     (princ boxes)
     (if (> (length boxes) 0)
      (append cubes cube)))))

  (setf cubes onto::get-from "isAbove" table1 "Cube"))
  (setf nb-cubes (length cubes)))
  
(defun reset ()
)
  
 
 
 




