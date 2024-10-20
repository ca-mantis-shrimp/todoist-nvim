;Intended as a list of pure functions to use for functional data transformations
(local M {})

(fn is_root_project [project]
  "checks if a project is or is not a root project by checking depth"
  (or (not project.parent_id) (= project.parent_id _G.vim.NIL)))

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

(fn get_comment_str [todoist_comment]
  "return todoist comment as a string"
  (.. "+ " todoist_comment.content "|>" todoist_comment.id))

(fn get_section_str [section]
  "return section as string string"
  (.. "& " section.name "|>" section.id))

(fn list_is_populated [list]
  "returns true if the collection is both non-nil and has atleast one item in it"
  (and list (> (length list) 0)))

(fn add_depth_to_project [project projects]
  "add the depth for the root project and all child projects (recursively) if necessary"
  (tset project :depth (or (+ (. (. (icollect [_ potential_parent (ipairs projects)]
                                      (when (is_parent_project project
                                                               potential_parent)
                                        potential_parent))
                                    1)) :depth) 1) 0)
  (when (list_is_populated project.children)
    (each [_ child (ipairs project.children)]
      (add_depth_to_project child projects)))
  project)

(fn append_list_lines [lines list str_generator]
  "given base-list of strings, a list of dictionaries to be converted, and a function to convert each dictionary, append the result of converting the list to the original lines"
  (when (list_is_populated list)
    (table.insert lines
                  (_G.unpack (icollect [_ value (ipairs list)]
                               (str_generator value))))))

(fn get_project_lines [project]
  "grabs the list of string lines for the project, as well as all comments, sections, and child projects recursively and returns the list"
  (let [lines [(get_project_str project)]]
    (append_list_lines lines project.sections get_section_str)
    (append_list_lines lines project.comments get_comment_str)
    (append_list_lines lines project.children get_project_lines)
    lines))

(fn add_depth_to_root_projects [root_projects projects]
  "add the depth to all root projects and their children recursively"
  (each [_ project (ipairs root_projects)]
    (add_depth_to_project project projects))
  root_projects)

(fn add_list_to_project [project list_name list checker]
  "higher order function that takes a project, a list name, a list, and a checker function, and adds the value to the project if the checker function returns true"
  (when (list_is_populated list)
    (tset project list_name (icollect [_ value (ipairs list)]
                              (when (checker project value)
                                value))))
  (when (> (length list) 1)
    (table.sort (. project list_name) is_higher_child_order))
  project)

(fn get_expanded_projects [projects comments sections]
  "add children stuff to project list"
  (each [_ project (ipairs projects)]
    (add_list_to_project project :children projects is_child_project)
    (add_list_to_project project :comments comments is_project_comment)
    (add_list_to_project project :sections sections is_project_section))
  projects)

(fn get_root_project_list [projects]
  "get root projects, sorted and updated with depth"
  (local root_projects (icollect [_ project (ipairs projects)]
                         (when (is_root_project project)
                           project)))
  (when (> (length root_projects) 1)
    (table.sort root_projects is_higher_child_order))
  (add_depth_to_root_projects root_projects projects))

(fn M.get_todoist_lines [projects comments sections]
  "given projects comments (optional) and sections (optional), get the equivalent list of strings"
  (let [expanded_projects (get_expanded_projects projects comments sections)
        root_projects (get_root_project_list expanded_projects)]
    (icollect [_ project (ipairs root_projects)]
      (_G.unpack (get_project_lines project)))))

M

