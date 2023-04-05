(in-package :dt)


(defparameter object-property nil)
(defparameter property-value nil)
(defparameter object-of-interest nil)
(defparameter *communicated-action* nil)
(defparameter *communicated-object* nil)
(defvar type-set nil)

;;understand message and return communcated action, object and context
(defun understand (message)
 (setf object-of-interest nil)
 (let ((response-understand-srv (call-understand-srv message)))
      (setq *communicated-action* (msg-slot-value response-understand-srv :ACTION))
      (let ((sparql-query (msg-slot-value response-understand-srv :SPARQLQUERY)))
       (setf *communicated-object* (set-object-properties sparql-query "?0"))
        
       (values sparql-query *communicated-action* *communicated-object*))))

;;understand sentence with given context call merge service

(defun understand-with-context (message)
 (setf *table* "table_lack")
 (setq *ctx-designate* (vector (format nil "?0 isAbove ~a" *table*)
                             "?0 isInContainer ?1" "?1 isA VisibleDtBox"))
 (let ((response-understand-srv (understand message)))         
    (let ((response-merge-srv (call-merge-srv (nth-value 0 response-understand-srv ) *ctx-designate* nil)))
        (let ((merge-sparql (msg-slot-value response-merge-srv :MERGED_QUERY)))
         (setf *communicated-object* (set-object-properties merge-sparql "?0"))
        
         (values merge-sparql *communicated-action* *communicated-object*)))))

; (defun designate-object (sparql-query)
;  (desig:an object (type ?type) 
;                   (:has-color ?has-color) 
;                   (:has-graphic ?has-graphic)
;                   (:has-graphic-color ?has-graphic-color)
;                   (:has-border-color ?has-border-color))
;  (loop for fact in 
;              (coerce sparql-query 'list) do 
;                  (setq base-facts-triples (append base-facts-triples (list (get-triplet fact))))))

(defun find-action (communicated-action))



; (defvar *object-designator* (desig:an object (type cube) (color blue) (has)))

(defun make-cube-designator (?has-color ?has-graphic ?has-graphic-color ?has-border-color)
 (let ((object-desig 
        (desig:an object (type :cube) 
                         (:has-color ?has-color) 
                         (:has-graphic ?has-graphic)
                         (:has-graphic-color ?has-graphic-color)
                         (:has-border-color ?has-border-color))))
      (values object-desig)))
      

(defvar property-list nil)
(defun get-object-designator-properties (object-designator) 
 (let ((type (desig:desig-prop-value object-designator :type))                                                              
       (border-color (desig:desig-prop-value object-designator :has-border-color))                                                                   
       (cube-color (desig:desig-prop-value object-designator :has-color))
       (graphic (desig:desig-prop-value object-designator :has-graphic)) 
       (graphic-color (desig:desig-prop-value object-designator :has-graphic-color)))
      (setf property-list (list type border-color cube-color graphic graphic-color)))
 (values property-list))
                                                                 
(defun set-cube-name (object-designator)
 (let ((object-prop (get-object-designator-properties object-designator)))
  (let ((tc (string-downcase (nth 0 object-prop)))
        (bc (get-first-char-of-prop (nth 1 object-prop)))
        (cc (get-first-char-of-prop (nth 2 object-prop)))
        (g (get-first-char-of-prop (nth 3 object-prop)))
        (gc (get-first-char-of-prop (nth 4 object-prop)))) 
       (let ((cube-name (concatenate 'string tc "_" bc cc g gc)))
        (values cube-name)))))
                                                                   
 
 
 
(defun get-first-char-of-prop (property) 
  (string-upcase (char property 0)))
 


(defun set-object-properties(facts entity)
 ;;(setf object-of-interest (desig:an object))
 (let ((facts-tmp facts))
  (loop for fact in 
              (coerce facts 'list) do
                  (let ((from (get-from fact)))
                       (cond ((string= from entity) 
                              (progn
                               (setf object-property (get-relation fact)) (setf property-value (get-on fact))
                               (princ (format nil "current object property <<<~a>>> and its value <<<~a>>>" object-property property-value)) (terpri)
                               (cond ((string= object-property "isA")
                                      (setf type-set (set-typ property-value))
                                      (princ (format nil "current object type <<<~a>>>" type-set))(terpri))
                                     ((and (not (eql type-set nil)) (not (string= object-property "isA")) (not (string= (char property-value 0) "?")))
                                      (setf object-of-interest (extend-designator-properties object-of-interest 
                                                                (list (get-object-properties-and-values object-property property-value)))))                                  
                                     ((and (not (eql type-set nil))  (not (string= object-property "isA")) (string= (char property-value 0) "?"))
                                      (setf object-of-interest (extend-designator-properties object-of-interest 
                                                                (list (list (parse-keyword object-property) (set-object-properties facts-tmp property-value)))))))))))))           
                                                               
 (values object-of-interest))

(defun parse-keyword (string)
  (intern (string-upcase (string-left-trim ":" string)) :keyword))

;;(defun is-a-variable (var))

(defun set-typ (property-value)
 (let ((?type (parse-keyword property-value)))
      (setf object-of-interest (desig:an object (type ?type))))
 (values object-of-interest))

(defun get-object-properties-and-values (object-property property-value)
 (let ((?obj-prop (parse-keyword object-property)) (?prop-val (parse-keyword property-value)))
  (values (list ?obj-prop ?prop-val))))