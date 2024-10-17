-- [nfnl] Compiled from lua/Todoist/model/new_transformations.fnl by https://github.com/Olical/nfnl, do not edit.
local M = {}
M.add_root_depth = function(project)
  project["depth"] = 0
  return project
end
M.is_root_project = function(project)
  return ((project.parent_id == nil) or (project.parent_id == _G.vim.NIL))
end
M.is_higher_child_order = function(type_1, type_2)
  return (type_1.child_order < type_2.child_order)
end
M.get_project_str = function(project)
  return (_G.string.rep("#", (project.depth + 1)) .. " " .. project.name .. "|>" .. project.id)
end
M.get_comment_str = function(todoist_comment)
  return ("+ " .. todoist_comment.content .. "|>" .. todoist_comment.id)
end
M.get_section_str = function(section)
  return ("& " .. section.name .. "|>" .. section.id)
end
return M
