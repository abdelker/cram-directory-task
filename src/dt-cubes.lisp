(in-package :dt)

(defun designateCube (sentences)
  (setq response-understand-srv (call-understand-srv sentences))
  (setq action (msg-slot-value response-understand-srv :ACTION))
  (setq sparql (msg-slot-value response-understand-srv :SPARQLQUERY))
  (setq result "")
  (setq state nil)
  ;; (cond 
  ;;((not *ctx-designate*)
  (setq *ctx-designate* (vector (format nil "?0 isAbove ~a" table1)
                              "?0 isInContainer ?1"
                              "?1 isA VisibleDtBox"))
                              
  (setq response-merge-srv (call-merge-srv sparql *ctx-designate* nil))
  (setq merge-sparql (msg-slot-value response-merge-srv :MERGED_QUERY))
  (setq response-sparql-srv (call-sparql-srv merge-sparql))
  (setq matches (msg-slot-value response-sparql-srv :RESULTS))
  (cond
   ((> (length matches) 1)
    (progn
      (terpri)
      (princ "I am not sure of what you are speaking about...")
      (terpri)
      (setq new-context merge-sparql)
      (setq question "")
      ;;(setq onematch 
      (loop for match in (coerce matches 'list) do
            (setq response-disambiguate-srv (call-disambiguate-srv match new-context))
            (terpri)
            (princ "Sparql result: ")
            (terpri)
            (princ (setq sparql-result (msg-slot-value response-disambiguate-srv :SPARQLRESULT)))
            (setq ambiguous (msg-slot-value response-disambiguate-srv :AMBIGUOUS))
            (cond
             ((not (coerce ambiguous 'list))
              (setq match-sparql sparql-result))
             ((progn
                (setq result "not understand")
                (princ result)
                (values state result action))))
            (terpri)
            (princ "sparql : ")
            (princ match-sparql)
            (terpri)
            (setq response-merge-match-srv (call-merge-srv match-sparql new-context t))
            (setq match-sparql (msg-slot-value response-merge-match-srv :MERGED_QUERY))
            (setq response-verbalize-srv (call-verbalize-srv match-sparql))
            (setq question-part (msg-slot-value response-verbalize-srv :VERBALIZATION))
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
      (setq *ctx-designate* new-context)
      (values state question action)))
   ((= (length matches) 1)
    (progn
      (terpri)
      (princ "cube find:")
      (terpri)
      (princ matches)
      (setq *ctx-designate* nil)
      (setq state t)
      (values state matches action)))
   ((progn
      (setq result "not understand")
      (princ result)
      (terpri)
      (setq state nil)
      (values state result action)))))


; (defun select-current-cube ()
;     (cond 
;         ((> (length boxes) 0))))
        
        
; (defun order-cubes ()
;     (let ((tmp-cubes (sort '*cubes*  :key (value-cube cube))))
;         (setf *cubes* tmp-cubes)))
    

; (defun value-cube (cube-name)
;     (let ((response-disambiguate-srv (call-disambiguate-srv match new-context)))
;          (let ((sparql-result (roslisp:msg-slot-value response-disambiguate-srv :SPARQLRESULT))
;                (ambiguous (roslisp:msg-slot-value response-disambiguate-srv :AMBIGUOUS))))))
;         ;;    (if ((eql (length ambiguous) 0))
;         ;;     (values (length sparql-result))
;         ;;     (expt 2 63))
           
            

(defun get-triplet (fact)
    (let ((match (split-sequence:SPLIT-SEQUENCE #\Space fact)))
       (let ((triples (roslisp:make-msg "knowledge_sharing_planner_msgs/Triplet"
                     :from (car match)
                     :relation (second match)
                     :on (last match))))
                    
         (princ (concatenate 'string "triplet :" triples))
         (values triples))))


; (defun update-cube-list ()
;     (cond 
;        ((eq cheat t)
;         (progn 
;              (setf *cubes* (onto::get-from "isAbove" table1 "Cube")) 
;              (princ (concatenate 'string "list cubes :" *cubes*))
;              (setf *cubes* nil)
;              (loop for cube in *cubes* do
;                      (setf boxes (onto::get-from "containerHasIn" cube "VisibleDtBox"))
;                      (princ boxes)
;                      (if (> (length boxes) 0)
;                          (append *cubes* cube)))))

;        (setf *cubes* onto::get-from "isAbove" table1 "Cube"))
;     (setf nb-cubes (length *cubes*)))
  
; (defun reset ()
;     (setf current-cube nil)
;     (setf *cubes* nil)
;     (setf nb-cubes 0))


(defun set-ontology ()
    (cond 
       ((eql cheat t)
            (progn
                (setf onto (onto::get-onto *robot-name*))
                (setf onto (onto::set-lang lang)))))
       (progn
            (setf onto (onto::get-onto "human_0"))
            (setf onto (onto::set-lang lang))))

; (defun change-context ()
;     (princ "--> Change ctx")
;     (setf cheat (not cheat))
;     (princ (concatenate 'string "cheat :" cheat))
;     (set-ontology)
;     (update-cube-list))
