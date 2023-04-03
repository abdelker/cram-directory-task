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


(defun set-object-properties(fact)
 (setf object-property (get-relation fact)) (setf property-value  (get-on fact))
 (let ((?obj-prop (string-upcase object-property)) (?prop-val (string-upcase property-value)))
  (setf object-of-interest (desig:an object (type cube)
                            (?obj-prop ?prop-val)))))

