(local get_extended_projects (require :Todoist.model.project))
(local describe (. (require :busted) :describe))
(local it (. (require :busted) :it))
(describe "create extended projects from the various lists"
          (fn []
            (it "should be able to create extended projects if given all proper lists"
                (fn []
                  (let [projects [{:name :inbox :id 1 :child_order 1}
                                  {:name :child
                                   :id 4
                                   :child_order 2
                                   :parent_id 1}]
                        doist_comments [{:content :test :id 2 :project_id 1}]
                        sections [{:content :test-section :id 3 :project_id 1}]
                        expected_output [{:name :inbox
                                          :id 1
                                          :child_order 1
                                          :comments [{:content :test
                                                      :id 2
                                                      :project_id 1}]
                                          :sections [{:content :test-section
                                                      :id 3
                                                      :project_id 1}]
                                          :children [{:name :child
                                                      :id 4
                                                      :child_order 2
                                                      :parent_id 1
                                                      :sections []
                                                      :comments []
                                                      :children []}]}
                                         {:name :child
                                          :id 4
                                          :child_order 2
                                          :parent_id 1
                                          :sections []
                                          :comments []
                                          :children []}]
                        test_output (get_extended_projects projects
                                                           doist_comments
                                                           sections)]
                    (assert.are.same expected_output test_output))))))

