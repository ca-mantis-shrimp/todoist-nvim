(local M {})

(fn M.add_root_depth [project]
  "Given a project, add the root depth to the project"
  (tset project :depth 0)
  project)

(fn M.is_root_project [project]
  "checks if a project is or is not a root project by checking depth"
  (or project.parent_id (= project.parent_id _G.vim.NIL)))

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

(fn M.append_list_lines [lines list str_generator]
  "given base list of strings, a list of dictionaries to be converted, and a function to convert each dictionary, append the result of converting the list to the original lines"
  (table.insert lines
                (_G.unpack (icollect [_ value (ipairs list)]
                             (str_generator value)))))

(fn M.get_project_lines [project]
  "grabs the list of string lines for the project, as well as all comments, sections, and child projects recursively and returns the list"
  (let [lines [(M.get_project_str project)]]
    (when (M.list_is_populated project.comments)
      (M.append_list_lines lines project.comments M.get_comment_str))
    (when (M.list_is_populated project.sections)
      (M.append_list_lines lines project.sections M.get_section_str))
    (when (M.list_is_populated project.children)
      (M.append_list_lines lines project.children M.add_project_lines))
    lines))

M

