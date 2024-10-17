(local M {})

(fn M.add_root_depth [project]
  "Given a project, add the root depth to the project"
  (tset project :depth 0)
  project)

(fn M.is_root_project [project]
  "checks if a project is or is not a root project by checking depth"
  (or (= project.parent_id nil) (= project.parent_id _G.vim.NIL)))

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

M

