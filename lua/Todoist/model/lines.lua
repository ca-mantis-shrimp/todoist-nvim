-- [nfnl] Compiled from lua/Todoist/model/lines.fnl by https://github.com/Olical/nfnl, do not edit.
local util = require("Todoist.fnl_util")
local function get_project_str(project)
  return (_G.string.rep("#", (project.depth + 1)) .. " " .. project.name .. "|>" .. project.id)
end
local function get_comment_str(todoist_comment)
  return ("+ " .. todoist_comment.content .. "|>" .. todoist_comment.id)
end
local function get_section_str(section)
  return ("& " .. section.name .. "|>" .. section.id)
end
local function get_list_lines(_3flist, str_generator)
  local tbl_21_auto = {}
  local i_22_auto = 0
  for _, value in ipairs(_3flist) do
    local val_23_auto = str_generator(value)
    if (nil ~= val_23_auto) then
      i_22_auto = (i_22_auto + 1)
      tbl_21_auto[i_22_auto] = val_23_auto
    else
    end
  end
  return tbl_21_auto
end
local function get_project_lines(project)
  local lines = {get_project_str(project)}
  if util.list_is_populated(project.sections) then
    for _, section_str in ipairs(get_list_lines(project.sections, get_section_str)) do
      table.insert(lines, section_str)
    end
  else
  end
  if util.list_is_populated(project.comments) then
    for _, comment_str in ipairs(get_list_lines(project.comments, get_comment_str)) do
      table.insert(lines, comment_str)
    end
  else
  end
  if util.list_is_populated(project.children) then
    for _, child_project_strs in ipairs(get_list_lines(project.children, get_project_lines)) do
      for _0, project_str in ipairs(child_project_strs) do
        table.insert(lines, project_str)
      end
    end
  else
  end
  return lines
end
local function get_todoist_lines(root_projects)
  local lines = {}
  local todoist_lines
  do
    local tbl_21_auto = {}
    local i_22_auto = 0
    for _, project in ipairs(root_projects) do
      local val_23_auto = get_project_lines(project)
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
