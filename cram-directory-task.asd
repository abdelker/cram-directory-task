(defsystem cram-directory-task
  :depends-on (
               :roslisp
               :actionlib_msgs-msg
               :actionlib
               :geometry_msgs-msg
               :cl-transforms
               :cl-transforms-stamped
               :cl-tf
               :cl-tf2
               :cram-tf
               :cram-language
               :cram-designators 
               :cram-prolog
               :cram-process-modules 
               :cram-language-designator-support
               :cram-executive 
               :cram-cloud-logger
               :ontologenius-srv
               :ontologenius-msg
              :resource_management_msgs-msg
              :knowledge_sharing_planner_msgs-msg
              :knowledge_sharing_planner_msgs-srv
              :mementar-msg
              :pepper_head_manager_msgs-msg
              :cram-ontologenius)
            

  :components
  ((:module "src"
            :components
            (
              (:file "package")

              (:file "ros-interface" :depends-on ("package"))

              (:file "dt-init" :depends-on ("package""ros-interface"))
                                                  

              (:file "control-interface" :depends-on ("package"
                                                    "dt-init"))))))