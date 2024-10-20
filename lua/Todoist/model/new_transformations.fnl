(local M {})

(fn M.add_root_depth [project]
  "Given a project, add the root depth to the project"
  (tset project :depth 0)
  project)

(fn M.is_root_project [project]
  "checks if a project is or is not a root project by checking depth"
  (or (not project.parent_id) (= project.parent_id _G.vim.NIL)))

(fn M.is_project_comment [project todoist_comment]
  "checks if a comment belongs to a project"
  (= project.id todoist_comment.project_id))

(fn M.is_project_section [project section]
  "checks if a section belongs to a project"
  (= project.id section.project_id))

(fn M.is_child_project [project potential_child]
  "checks if a project is a child of another project"
  (= project.id potential_child.parent_id))

(fn M.is_parent_project [project potential_parent]
  "checks if a project is a child of another project"
  (= project.parent_id potential_parent.id))

(fn M.is_higher_child_order [type_1 type_2]
  "checks if the first dictionary has a lower child order than the second"
  (< type_1.child_order type_2.child_order))

(fn M.get_project_str [project]
  "return the stringified version from the project"
  (.. (_G.string.rep "#" (+ project.depth 1)) " " project.name "|>" project.id))

(fn M.get_comment_str [todoist_comment]
  "return todoist comment as a string"
  (.. "+ " todoist_comment.content "|>" todoist_comment.id))

(fn M.get_section_str [section]
  "return section as string string"
  (.. "& " section.name "|>" section.id))

(fn M.list_is_populated [list]
  "returns true if the collection is both non-nil and has atleast one item in it"
  (and list (> (length list) 0)))

(fn M.add_list_to_project [project list_name list checker]
  "higher order function that takes a project, a list name, a list, and a checker function, and adds the value to the project if the checker function returns true"
  (when (M.list_is_populated list)
    (tset project list_name (icollect [_ value (ipairs list)]
                              (when (checker project value)
                                value)))))

(fn M.add_lists_to_projects [opts]
  "add children stuff to project list"
  (each [_ project (ipairs opts.response.projects)]
    (M.add_list_to_project project :children opts.response.projects
                           ;We can assume projects are there
                           M.is_project_child)
    (M.add_list_to_project project :comments (?. opts :response :comments)
                           ;comments and sections however we cannot assume are there
                           M.is_project_comment)
    (M.add_list_to_project project :sections (?. opts :response :sections)
                           M.is_project_section))
  opts)

(fn M.add_root_project_list [opts]
  "add new 'root_projects' key that will actually return the structure of the work"
  (tset opts :root_projects (icollect [_ project (ipairs opts.response.projects)]
                              (when (M.is_root_project project)
                                project)))
  opts)

(fn M.add_depth_to_root_project [project projects]
  "add the depth for the root project and all child projects (recursively) if necessary"
  (tset project :depth (or (+ (. (. (icollect [_ potential_parent (ipairs projects)]
                                      (when (M.is_project_parent project
                                                                 potential_parent)
                                        potential_parent))
                                    1)) :depth) 1) 0)
  (when (M.list_is_populated project.children)
    (each [_ child (ipairs project.children)]
      (M.add_depth_to_project child projects)))
  project)

(fn M.add_depth_to_root_projects [opts]
  "add the depth to all root projects and their children recursively"
  (each [_ project (ipairs opts.response.root_projects)]
    (M.add_depth_to_root_project project opts.response.projects)))

(fn M.append_list_lines [lines list str_generator]
  "given base-list of strings, a list of dictionaries to be converted, and a function to convert each dictionary, append the result of converting the list to the original lines"
  (when (M.list_is_populated list)
    (table.insert lines
                  (_G.unpack (icollect [_ value (ipairs list)]
                               (str_generator value))))))

(fn M.get_project_lines [project]
  "grabs the list of string lines for the project, as well as all comments, sections, and child projects recursively and returns the list"
  (let [lines [(M.get_project_str project)]]
    (M.append_list_lines lines project.sections M.get_section_str)
    (M.append_list_lines lines project.comments M.get_comment_str)
    (M.append_list_lines lines project.children M.add_project_lines)
    lines))

(fn M.add_todoist_lines [opts]
  "adds all lines from the list of root projects to the new 'lines' key"
  (tset opts :lines
        (icollect [_ project (ipairs opts.response.root_projects)]
          (_G.unpack (M.get_project_lines project))))
  opts)

M

