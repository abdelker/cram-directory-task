(in-package :dt)

(defvar *disambiguate-srv* nil "ROS service to disambgiuate")
(defvar *verbalize-srv* nil "ROS service to verbalize")
(defvar *understand-srv* nil "ROS service to understand")
(defvar *merge-srv* nil "ROS service to merge")
(defvar *sparql-srv* nil "ROS service to sparql")
(defvar base-facts-triple nil)
;; (defvar *mementar-sub* nil "ROS sub")
;;(defvar *mementar-cb-value* (make-fluent :name :mementar-cb-value) "")

(defun init-ros-dt ()

  (setf *disambiguate-srv* "/KSP/disambiguate")
  (setf *understand-srv* "/KSP/understand")
  (setf *merge-srv* "/KSP/merge")
  (setf *sparql-srv* "/ontologenius/sparql/pepper")
  (setf *verbalize-srv* "/KSP/verbalize"))
 ;; (setf *mementar-sub* (subscribe (concatenate 'string "/mementar/occasions/" *robot-name*) "mementar/MementarOccasion"  #'mementar-cb))     


;; (defun mementar-cb (msg)
;;   "Callback for mementar. Called by the mementar topic subscriber."
;;   (cond ((eql (roslisp:msg-slot-value msg :id) id-mementar-callback) 
;;     (progn 
;;       (setf *cube* )))
;;   msg))

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
  (write-line "Waiting for KSP merge")
  (write-line (format nil "query: ~a ctx: ~a" query ctx))
  (write-line "merge response: ")
  (princ (call-service *merge-srv* 'knowledge_sharing_planner_msgs-srv:Merge :base_query
                       query :context_query ctx
                       :partial partial)))

(defun call-understand-srv (sentence)
  "Function to call the KSP-understand service."
  (write-line "Waiting for KSP Understand")
  (write-line "understand response: ")
  (princ (call-service *understand-srv* 'knowledge_sharing_planner_msgs-srv:Understand :verbalization
                       sentence)))


(defun create-symbol-table (match)
  (roslisp:make-msg "knowledge_sharing_planner_msgs/SymbolTable"
                    :symbols (msg-slot-value match 'ONTOLOGENIUS-MSG:NAMES)
                    :individuals (msg-slot-value match 'ONTOLOGENIUS-MSG:VALUES)))

(defun call-disambiguate-srv (match ctx)
  "Function to call the Disambgiuate service."
  (handler-case
    (progn
       (loop for fact in (coerce ctx 'list) do 
           (setq base-facts-triple (append base-facts-triple (list (get-triplet fact)))))
       (let  ((response (call-service *disambiguate-srv*
                         'knowledge_sharing_planner_msgs-srv:Disambiguation 
                         :ontology *robot-name*
                         :symbol_table (create-symbol-table match)
                         :individual(svref (msg-slot-value match 'ONTOLOGENIUS-MSG:VALUES) 0)
                         :baseFacts base-facts-triple)))
             (setq base-facts-triple nil)
             (write-line "resp disambiguate :")
             (princ response) (terpri)))  

    (roslisp::ros-rpc-error () 
     (write-line "Service call failed:") (write-line *disambgiuate-srv*)))) 

;