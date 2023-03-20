(in-package :dt)

(defvar *disambiguate-srv* nil "ROS service to disambgiuate")
(defvar *verbalize-srv* nil "ROS service to verbalize")
(defvar *understand-srv* nil "ROS service to understand")
(defvar *merge-srv* nil "ROS service to merge")
(defvar *sparql-srv* nil "ROS service to sparql")
(defvar *mementar-sub* nil "ROS sub")


(defun init-ros-dt ()

  (setf *disambiguate-srv* "/KSP/disambiguate")
  (setf *understand-srv* "/KSP/understand")
  (setf *merge-srv* "/KSP/merge")
  (setf *sparql-srv* "/ontologenius/sparql/pepper")
  (setf *verbalize-srv* "/KSP/verbalize")
  ;; (setf *mementar-sub* (subscribe (concatenate 'string "/mementar/occasions/" robot-name) "std_msgs/String"
  ;;     
)


;;verbalize
(defun call-verbalize-srv (sparql)
  (call-service *verbalize-srv* 'knowledge_sharing_planner_msgs-srv:Verbalization :sparqlQuery
                sparql))
;;sparql_ontology
(defun call-sparql-srv (merge-sparql)
  "Function to call the sparql-srv service."
  (princ merge-sparql)
  (terpri)
  ;;(cond 
  ;; ((typep merge-sparql 'list)
  (setq str_sparql (format nil
                           "~{~A~^, ~}"
                           (coerce merge-sparql 'list)))
  ;; ))
  ;;(setq str_sparql merge-sparql)

  (princ str_sparql)
  (terpri)
  (princ "ontology results: ")
  (terpri)
  (princ (call-service *sparql-srv* 'ontologenius-srv:OntologeniusSparqlService :query
                       str_sparql)))
;;merge
(defun call-merge-srv (query ctx partial)
  "Function to call the KSP-merge service."
  (princ "Waiting for KSP merge")
  (terpri)
  (princ (format nil "query: ~a" query))
  (terpri)
  (princ (format nil "ctx: ~a" ctx))
  (terpri)
  (princ "merge response: ")
  (terpri)
  (princ (call-service *merge-srv* 'knowledge_sharing_planner_msgs-srv:Merge :base_query
                       query :context_query ctx
                       :partial partial)))

(defun call-understand-srv (sentence)
  "Function to call the KSP-understand service."
  (princ "Waiting for KSP Understand")
  (terpri)
  (princ "understand response: ")
  (terpri)
  (princ (call-service *understand-srv* 'knowledge_sharing_planner_msgs-srv:Understand :verbalization
                       sentence)))



(defun create-symbol-table (match)
  (roslisp:make-msg "ontologenius/OntologeniusSparqlResponse"
                    :names (slot-value match 'ONTOLOGENIUS-MSG:NAMES):values
                    (slot-value match 'ONTOLOGENIUS-MSG:VALUES)))


(defun call-disambiguate-srv (match ctx)
  "Function to call the SetChestColor service."
  (call-service *disambiguate-srv*
                'knowledge_sharing_planner_msgs-srv:Disambiguation :ontology
                "pepper"
                :symbol_table (create-symbol-table match):individual
                (svref (slot-value match 'ONTOLOGENIUS-MSG:VALUES)
                       0)
                ;;   (loop for n in (coerce match 'list) do (princ n) (return n))
                )) 