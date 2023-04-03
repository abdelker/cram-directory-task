(in-package :dt)

(defun understand (message)


 (defparameter object-property nil)
 (defparameter property-value nil)
 (defparameter object-of-interest nil)

 (let ((response-understand-srv (call-understand-srv sentences)))
      (setq communicated-action (msg-slot-value response-understand-srv :ACTION))
      (setq sparql-query (msg-slot-value response-understand-srv :SPARQLQUERY)))  

 (values *action))


(defun designate-object (sparql-query)
 (desig:an object (type ?type) 
                  (:has-color ?has-color) 
                  (:has-graphic ?has-graphic)
                  (:has-graphic-color ?has-graphic-color)
                  (:has-border-color ?has-border-color))
 (loop for fact in 
             (coerce sparql-query 'list) do 
                 (setq base-facts-triples (append base-facts-triples (list (get-triplet fact))))))


(defun set-object-properties(facts entity)
 (setf object-of-interest (desig:an object))
 (loop for fact in 
             (coerce facts 'list) do
                 (let ((from (get-from fact)))
                      (cond ((string= from entity) 
                             (progn
                              (setf object-property (get-relation fact)) (setf property-value (get-on fact))
                              (cond ((string= object-property "isA")
                                     (set-typ property-value))
                                    ((not (string= object-property "isA"))
                                     (setf object-of-interest (extend-designator-properties object-of-interest 
                                                               (list (get-object-properties-and-values object-property property-value)))))))))))
 (values object-of-interest))

(defun parse-keyword (string)
  (intern (string-upcase (string-left-trim ":" string)) :keyword))

(defun is-a-variable (var))

(defun set-typ (property-value)
 (let ((?type (parse-keyword property-value)))
      (setf object-of-interest (desig:an object (type ?type))))
 (values object-of-interest))

(defun get-object-properties-and-values (object-property property-value)
 (let ((?obj-prop (parse-keyword object-property)) (?prop-val (parse-keyword property-value)))
  (values (list ?obj-prop ?prop-val))))