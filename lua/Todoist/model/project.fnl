(local util (require :Todoist.fnl_util))
(fn is_project_comment [project todoist_comment]
  "checks if a comment belongs to a project"
  (= project.id todoist_comment.project_id))

(fn is_project_section [project section]
  "checks if a section belongs to a project"
  (= project.id section.project_id))

(fn is_child_project [project potential_child]
  "checks if a project is a child of another project"
  (= project.id potential_child.parent_id))

(fn add_list_to_project [project list_name list checker]
  "higher order function that takes a project, a list name, a list, and a checker function, and adds the value to the project if the checker function returns true"
  (when (util.list_is_populated list)
    (tset project list_name (icollect [_ value (ipairs list)]
                              (when (checker project value)
                                value))))
  (when (and (util.list_is_populated list) (> (length list) 1))
    (table.sort (. project list_name) util.is_higher_child_order))
  project)

(fn get_expanded_projects [projects ?comments ?sections]
  "given a list of projects, add the appropriate comments (optional), sections (optional) and child projects to each project"
  (each [_ project (ipairs projects)]
    (add_list_to_project project :children projects is_child_project)
    (add_list_to_project project :comments ?comments is_project_comment)
    (add_list_to_project project :sections ?sections is_project_section))
  projects)

get_expanded_projects

