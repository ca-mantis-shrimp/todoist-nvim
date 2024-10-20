;Intended as a list of pure functions to use for functional data transformations
(local M {})

(fn is_root_project [project]
  "checks if a project is or is not a root project by checking depth"
  (or (= (?. project :parent_id) nil) (= (?. project :parent_id) _G.vim.NIL)))

(fn is_project_comment [project todoist_comment]
  "checks if a comment belongs to a project"
  (= project.id todoist_comment.project_id))

(fn is_project_section [project section]
  "checks if a section belongs to a project"
  (= project.id section.project_id))

(fn is_child_project [project potential_child]
  "checks if a project is a child of another project"
  (= project.id potential_child.parent_id))

(fn is_parent_project [project potential_parent]
  "checks if a project is a child of another project"
  (= project.parent_id potential_parent.id))

(fn is_higher_child_order [type_1 type_2]
  "checks if the first dictionary has a lower child order than the second"
  (< type_1.child_order type_2.child_order))

(fn get_project_str [project]
  "return the stringified version from the project"
  (.. (_G.string.rep "#" (+ project.depth 1)) " " project.name "|>" project.id))

(fn get_comment_str [todoist_comment] ;needed as comment is a reserved keyword
  "return todoist comment as a string"
  (.. "+ " todoist_comment.content "|>" todoist_comment.id))

(fn get_section_str [section]
  "return section as string string"
  (.. "& " section.name "|>" section.id))

(fn list_is_populated [list]
  "returns true if the collection is both non-nil and has atleast one item in it"
  (and list (> (length list) 0)))

(fn add_depth_to_project [project depth]
  "add the depth for the root project and all child projects (recursively) if necessary"
  (tset project :depth depth)
  (when (list_is_populated project.children)
    (each [_ child (ipairs project.children)]
      (add_depth_to_project child (+ depth 1))))
  project)

(fn get_root_project_list [projects]
  "get root projects, sorted and updated with depth"
  (local root_projects
         (icollect [_ project (ipairs projects)]
           (when (is_root_project project)
             (add_depth_to_project project 0))))
  (when (> (length root_projects) 1)
    (table.sort root_projects is_higher_child_order))
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

(fn get_list_lines [?list str_generator]
  "given a list and the function to generate strings for it, make a list of the strings and return the list"
  (icollect [_ value (ipairs ?list)]
    (str_generator value)))

(fn get_project_lines [project]
  "grabs the list of string lines for the project, as well as all comments, sections, and child projects recursively and returns the list"
  (let [lines [(get_project_str project)]]
    (when (list_is_populated project.sections)
      (table.insert lines
                    (_G.unpack (get_list_lines project.sections get_section_str))))
    (when (list_is_populated project.comments)
      (table.insert lines
                    (_G.unpack (get_list_lines project.comments get_comment_str))))
    (when (list_is_populated project.children)
      (table.insert lines
                    (_G.unpack (get_list_lines project.children
                                               get_project_lines))))
    lines))

(get_project_lines {:child_order 2
                    :children [{:child_order 3
                                :children {}
                                :comments [{:content :test :id 3 :project_id 3}]
                                :depth 1
                                :id 3
                                :name :work
                                :parent_id 2}]
                    :comments [{:content :test :id 2 :project_id 2}]
                    :depth 0
                    :id 2
                    :name :work})

(fn add_list_to_project [project list_name list checker]
  "higher order function that takes a project, a list name, a list, and a checker function, and adds the value to the project if the checker function returns true"
  (when (list_is_populated list)
    (tset project list_name (icollect [_ value (ipairs list)]
                              (when (checker project value)
                                value))))
  (when (and (list_is_populated list) (> (length list) 1))
    (table.sort (. project list_name) is_higher_child_order))
  project)

(fn get_expanded_projects [projects ?comments ?sections]
  "add children stuff to project list"
  (each [_ project (ipairs projects)]
    (add_list_to_project project :children projects is_child_project)
    (add_list_to_project project :comments ?comments is_project_comment)
    (add_list_to_project project :sections ?sections is_project_section))
  projects)

(fn M.get_todoist_lines [projects ?comments ?sections]
  "given projects comments (optional) and sections (optional), get the equivalent list of strings"
  (let [expanded_projects (get_expanded_projects projects ?comments ?sections)
        root_projects (get_root_project_list expanded_projects)]
    (icollect [_ project (ipairs root_projects)]
      (_G.unpack (get_project_lines project)))))

;(M.get_todoist_lines [{:name :inbox :id 1 :child_order 1 :parent_id nil}
;                      {:name :work :id 2 :child_order 2 :parent_id nil}
;                      {:name :work :id 3 :child_order 3 :parent_id 2}]
;                     [{:content :test :id 1 :project_id 1}
;                      {:content :test :id 2 :project_id 2}
;                      {:content :test :id 3 :project_id 3}]
;                     nil)

M

