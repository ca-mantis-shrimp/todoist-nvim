(local util (require :Todoist.model.util))

(fn is_root_project [project]
  "checks if a project is or is not a root project by checking depth"
  (or (= (?. project :parent_id) nil) (= (?. project :parent_id) _G.vim.NIL)))

(fn add_depth_to_project [project depth]
  "add the depth for the root project and all child projects (recursively) if necessary"
  (tset project :depth depth)
  (when (util.list_is_populated project.children)
    (each [_ child (ipairs project.children)]
      (add_depth_to_project child (+ depth 1))))
  project)

(fn get_project_tree [projects]
  "get root projects, sorted and updated with depth"
  (local root_projects
         (icollect [_ project (ipairs projects)]
           (when (is_root_project project)
             (add_depth_to_project project 0))))
  (when (> (length root_projects) 1)
    (table.sort root_projects util.is_higher_child_order))
  root_projects)

;(get_root_project_list [{:child_order 1
;                         :children {}
;                         :comments [{:content :test :id 1 :project_id 1}]
;                         :id 1
;                         :name :inbox}
;                        {:child_order 2
;                         :children [{:child_order 3
;                                     :children {}
;                                     :comments [{:content :test
;                                                 :id 3
;                                                 :project_id 3}]
;                                     :id 3
;                                     :name :work
;                                     :parent_id 2}]
;                         :comments [{:content :test :id 2 :project_id 2}]
;                         :id 2
;                         :name :work}]
;                       [{:name :inbox :id 1 :child_order 1 :parent_id nil}
;                        {:name :work :id 2 :child_order 2 :parent_id nil}
;                        {:name :work :id 3 :child_order 3 :parent_id 2}])

get_project_tree

