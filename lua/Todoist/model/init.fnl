(local get_projects (require :Todoist.model.project))
(local get_tree (require :Todoist.model.tree))
(local get_lines (require :Todoist.model.lines))
(fn get_todoist_lines [projects ?comments ?sections]
  "given projects comments (optional) and sections (optional), get the equivalent list of strings"
  (-> (get_projects projects ?comments ?sections)
      (get_tree)
      (get_lines)))

get_todoist_lines

