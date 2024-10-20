-- [nfnl] Compiled from lua/Todoist/model/new_transformations.fnl by https://github.com/Olical/nfnl, do not edit.
local M = {}
M.add_root_depth = function(project)
  project["depth"] = 0
  return project
end
M.is_root_project = function(project)
  return (project.parent_id or (project.parent_id == _G.vim.NIL))
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
M.list_is_populated = function(list)
  return (list and (#list > 0))
end
M.append_list_lines = function(lines, list, str_generator)
  local function _1_()
    local tbl_21_auto = {}
    local i_22_auto = 0
    for _, value in ipairs(list) do
      local val_23_auto = str_generator(value)
      if (nil ~= val_23_auto) then
        i_22_auto = (i_22_auto + 1)
        tbl_21_auto[i_22_auto] = val_23_auto
      else
      end
    end
    return tbl_21_auto
  end
  return table.insert(lines, _G.unpack(_1_()))
end
M.get_project_lines = function(project)
  local lines = {M.get_project_str(project)}
  if M.list_is_populated(project.comments) then
    M.append_list_lines(lines, project.comments, M.get_comment_str)
  else
  end
  if M.list_is_populated(project.sections) then
    M.append_list_lines(lines, project.sections, M.get_section_str)
  else
  end
  if M.list_is_populated(project.children) then
    M.append_list_lines(lines, project.children, M.add_project_lines)
  else
  end
  return lines
end
return M
