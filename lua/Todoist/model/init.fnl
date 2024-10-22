(local get_projects (require :Todoist.model.project))
(local get_tree (require :Todoist.model.tree))
(local get_lines (require :Todoist.model.lines))
(fn get_todoist_lines [projects ?comments ?sections]
  "given projects comments (optional) and sections (optional), get the equivalent list of strings"
  (let [expanded_projects (get_projects projects ?comments ?sections)
        root_projects (get_tree expanded_projects)
        lines []
        todoist_lines (icollect [_ project (ipairs root_projects)]
                        (get_lines project))]
    (each [_ list (ipairs todoist_lines)]
      (each [_ line (ipairs list)]
        (table.insert lines line)))
    lines))

get_todoist_lines

