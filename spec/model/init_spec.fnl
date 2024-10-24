(local get_todoist_lines (require :Todoist.model))
(local describe (. (require :busted) :describe))
(local it (. (require :busted) :it))
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
                                  {:name :work
                                   :id 3
                                   :child_order 3
                                   :parent_id 2}]
                        comments [{:content :test :id 1 :project_id 1}
                                  {:content :test :id 2 :project_id 2}
                                  {:content :test :id 3 :project_id 3}]
                        expected ["# inbox|>1"
                                  "+ test|>1"
                                  "# work|>2"
                                  "+ test|>2"
                                  "## work|>3"
                                  "+ test|>3"]
                        output (get_todoist_lines projects comments nil)]
                    (assert.are.same expected output))))))

