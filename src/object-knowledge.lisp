

(in-package :dt)

(defvar property-list nil)

(defparameter *table* "table_1")                              
(defparameter *ctx-designate* (vector (format nil "?0 isAbove ~a" *table*)
                               "?0 isInContainer ?1" "?1 isA VisibleDtBox"))
(defparameter *partial* nil)

(defun designate-object (query)
 (let ((merge-sparql (merge-query-call query *ctx-designate* nil))) 
     (let ((matches (sparql-matches-call merge-sparql)))
     ;;check length of matches
      (let ((check-matches (check-sparql-matches matches)))
         (cond
             ((string= check-matches "multiple matches")
              (progn
                  (let ((result (disambiguate-matches matches merge-sparql)))
                   (multiple-value-list (values nil result nil)))))

             ((string= check-matches "one match")
              (progn
                  (let ((matched-object (get-object query "?0" *ctx-designate*)))
                   (multiple-value-list (values t matches matched-object)))))

             ((progn
                 (multiple-value-list (values nil "not understand" nil)))))))
     ))


(defun get-object (query entity &optional (context nil))
 (cond ((eql context nil)
        (set-object-properties query entity))
       ((set-object-properties (sort-query (merge-query-call query context nil)) entity))))

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
 (setf object-of-interest nil)
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

;;;;;
(defun reset-context ()
(setf *ctx-designate* (vector (format nil "?0 isAbove ~a" *table*)
                               "?0 isInContainer ?1" "?1 isA VisibleDtBox"))
)
(defun set-new-context (new-context)
(setf *partial* t)
(setf *ctx-designate* nil)
 (setf *ctx-designate* new-context))


; (defun get-context()
;  (setf *table* "table_1")
;  (setq *ctx-designate* (vector (format nil "?0 isAbove ~a" *table*)
;                              "?0 isInContainer ?1" "?1 isA VisibleDtBox")))


(defun sort-query (query)
  (coerce (adjoin "?0 isA Cube"  (remove "?0 isA Cube" (coerce query 'list) :test 'equal)) 'vector))  


(defun make-cube-designator (?has-color ?has-graphic ?has-graphic-color ?has-border-color)
 (let ((object-desig 
        (desig:an object (type :cube) 
                         (:has-color ?has-color) 
                         (:has-graphic ?has-graphic)
                         (:has-graphic-color ?has-graphic-color)
                         (:has-border-color ?has-border-color))))
      (values object-desig)))