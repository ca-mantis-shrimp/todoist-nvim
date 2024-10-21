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

(get_todoist_lines [{:name :inbox :id 1 :child_order 1 :parent_id nil}
                    {:name :work :id 2 :child_order 2 :parent_id nil}
                    {:name :work :id 3 :child_order 3 :parent_id 2}]
                   [{:content :test :id 1 :project_id 1}
                    {:content :test :id 2 :project_id 2}
                    {:content :test :id 3 :project_id 3}] nil)

get_todoist_lines

