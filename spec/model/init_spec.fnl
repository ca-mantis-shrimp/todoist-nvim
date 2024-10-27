(local get_todoist_lines (require :Todoist.model))
(local describe (. (require :plenary.busted) :describe))
(local it (. (require :plenary.busted) :it))
(describe "the main module function for extracting the project lines from the various lists"
          (fn []
            (it "should be able to work without a section view"
                (fn []
                  (let [projects [{:name :inbox
                                   :id 1
                                   :child_order 1
                                   :parent_id nil}
                                  {:name :work
                                   :id 2
                                   :child_order 2
                                   :parent_id nil}
                                  {:name :child
                                   :id 3
                                   :child_order 3
                                   :parent_id 2}]
                        comments [{:content :inbox-comment :id 4 :project_id 1}
                                  {:content :work-comment :id 5 :project_id 2}
                                  {:content :child-comment :id 6 :project_id 3}]
                        expected ["# inbox|>1"
                                  "+ inbox-comment|>4"
                                  "# work|>2"
                                  "+ work-comment|>5"
                                  "## child|>3"
                                  "+ child-comment|>6"]
                        output (get_todoist_lines projects comments nil)]
                    (assert.are.same expected output))
                  nil))))

