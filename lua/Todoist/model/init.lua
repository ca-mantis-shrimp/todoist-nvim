-- [nfnl] Compiled from lua/Todoist/model/init.fnl by https://github.com/Olical/nfnl, do not edit.
local get_projects = require("Todoist.model.project")
local get_tree = require("Todoist.model.tree")
local get_lines = require("Todoist.model.lines")
local function get_todoist_lines(projects, _3fcomments, _3fsections)
  local expanded_projects = get_projects(projects, _3fcomments, _3fsections)
  local root_projects = get_tree(expanded_projects)
  local lines = {}
  local todoist_lines
  do
    local tbl_21_auto = {}
    local i_22_auto = 0
    for _, project in ipairs(root_projects) do
      local val_23_auto = get_lines(project)
      if (nil ~= val_23_auto) then
        i_22_auto = (i_22_auto + 1)
        tbl_21_auto[i_22_auto] = val_23_auto
      else
      end
    end
    todoist_lines = tbl_21_auto
  end
  for _, list in ipairs(todoist_lines) do
    for _0, line in ipairs(list) do
      table.insert(lines, line)
    end
  end
  return lines
end
return get_todoist_lines
