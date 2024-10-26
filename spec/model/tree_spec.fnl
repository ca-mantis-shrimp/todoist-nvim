(local get_root_project_list (require :Todoist.model.tree))
(local describe (. (require :busted) :describe))
(local it (. (require :busted) :it))
(describe "create tree from extended projects"
          (fn []
            (it "should be able to create tree if given proper project tree"
                (fn []
                  (let [test_tree (get_root_project_list [{:child_order 1
                                                           :children {}
                                                           :comments [{:content :test
                                                                       :id 1
                                                                       :project_id 1}]
                                                           :id 1
                                                           :name :inbox}
                                                          {:child_order 2
                                                           :children [{:child_order 3
                                                                       :children {}
                                                                       :comments [{:content :test
                                                                                   :id 3
                                                                                   :project_id 3}]
                                                                       :id 3
                                                                       :name :work
                                                                       :parent_id 2}]
                                                           :comments [{:content :test
                                                                       :id 2
                                                                       :project_id 2}]
                                                           :id 2
                                                           :name :work}]
                                                         [{:name :inbox
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
                                                           :parent_id 2}])
                        expected_tree [{:child_order 1
                                        :children {}
                                        :comments [{:content :test
                                                    :id 1
                                                    :project_id 1}]
                                        :depth 0
                                        :id 1
                                        :name :inbox}
                                       {:child_order 2
                                        :children [{:child_order 3
                                                    :children {}
                                                    :comments [{:content :test
                                                                :id 3
                                                                :project_id 3}]
                                                    :depth 1
                                                    :id 3
                                                    :name :work
                                                    :parent_id 2}]
                                        :comments [{:content :test
                                                    :id 2
                                                    :project_id 2}]
                                        :depth 0
                                        :id 2
                                        :name :work}]]
                    assert.are.same
                    test_tree
                    expected_tree)))))

