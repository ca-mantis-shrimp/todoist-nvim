(local util (require :Todoist.fnl_util))
(fn get_project_str [project]
  "return the stringified version from the project"
  (.. (_G.string.rep "#" (+ project.depth 1)) " " project.name "|>" project.id))

(fn get_comment_str [todoist_comment] ;needed as comment is a reserved keyword
  "return todoist comment as a string"
  (.. "+ " todoist_comment.content "|>" todoist_comment.id))

(fn get_section_str [section]
  "return section as string string"
  (.. "& " section.name "|>" section.id))

(fn get_list_lines [?list str_generator]
  "given a list and the function to generate strings for it, make a list of the strings and return the list"
  (icollect [_ value (ipairs ?list)]
    (str_generator value)))

(fn get_project_lines [project]
  "grabs the list of string lines for the project, as well as all comments, sections, and child projects recursively and returns the list"
  (let [lines [(get_project_str project)]]
    (when (util.list_is_populated project.sections)
      (each [_ section_str (ipairs (get_list_lines project.sections
                                                   get_section_str))]
        (table.insert lines section_str)))
    (when (util.list_is_populated project.comments)
      (each [_ comment_str (ipairs (get_list_lines project.comments
                                                   get_comment_str))]
        (table.insert lines comment_str)))
    (when (util.list_is_populated project.children)
      (each [_ child_project_strs (ipairs (get_list_lines project.children
                                                          get_project_lines))]
        (each [_ project_str (ipairs child_project_strs)]
          (table.insert lines project_str))))
    ;for children we need to unpack twice as they are double-nested (this returns a list remember!)
    lines))

(fn get_todoist_lines [root_projects]
  "given a root project list, get the lines of the list as a string"
  (let [lines []
        todoist_lines (icollect [_ project (ipairs root_projects)]
                        (get_project_lines project))]
    (each [_ list (ipairs todoist_lines)]
      (each [_ line (ipairs list)]
        (table.insert lines line))) ; we need to unpack the list of lists into a single list of lines
    lines))

get_todoist_lines

