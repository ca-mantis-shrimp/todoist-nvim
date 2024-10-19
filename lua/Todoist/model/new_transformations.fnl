(local M {})

(fn M.add_root_depth [project]
  (tset project :depth 0)
  project)

(fn M.is_root_project [project]
  (or (= project.parent_id nil) (= project.parent_id _G.vim.NIL)))

(fn M.is_higher_child_order [type_1 type_2]
  (< type_1.child_order type_2.child_order))

(fn M.get_project_str [project]
  (.. (_G.string.rep "#" (+ project.depth 1)) " " project.name "|>" project.id))

(fn M.get_comment_str [cmnt]
  (.. "+ " cmnt.content "|>" cmnt.id))

(fn M.get_section_str [section]
  (.. "& " section.name "|>" section.id))

(fn M.list_is_populated [list]
  (and list (> (length list) 0)))

(fn M.append_list_lines [lines list str_generator]
  (table.insert lines
                (_G.unpack (icollect [_ value (ipairs list)]
                             (str_generator value)))))

(fn M.get_project_lines [project]
  (local lines [(M.get_project_str project)])
  (when (M.list_is_populated project.comments)
    (M.append_list_lines lines project.comments M.get_comment_str))
  (when (M.list_is_populated project.sections)
    (M.append_list_lines lines project.sections M.get_section_str))
  (when (M.list_is_populated project.children)
    (M.append_list_lines lines project.children M.add_project_lines))
  lines)

(fn M.add_comments_to_projects [opts]
  (let [add_comments_to_project (fn [project]
                                  (local is_project_comment
                                         #(= $1.project_id project.id))
                                  (icollect [_ value (ipairs opts.response.projects)]))]))

(M.add_project_lines {:comments nil :depth 0 :name :test-proj :id 2421})

M

