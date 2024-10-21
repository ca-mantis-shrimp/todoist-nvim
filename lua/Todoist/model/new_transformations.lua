-- [nfnl] Compiled from lua/Todoist/model/new_transformations.fnl by https://github.com/Olical/nfnl, do not edit.
local M = {}
local function is_root_project(project)
  local _2_
  do
    local t_1_ = project
    if (nil ~= t_1_) then
      t_1_ = t_1_.parent_id
    else
    end
    _2_ = t_1_
  end
  local or_4_ = (_2_ == nil)
  if not or_4_ then
    local _6_
    do
      local t_5_ = project
      if (nil ~= t_5_) then
        t_5_ = t_5_.parent_id
      else
      end
      _6_ = t_5_
    end
    or_4_ = (_6_ == _G.vim.NIL)
  end
  return or_4_
end
local function is_project_comment(project, todoist_comment)
  return (project.id == todoist_comment.project_id)
end
local function is_project_section(project, section)
  return (project.id == section.project_id)
end
local function is_child_project(project, potential_child)
  return (project.id == potential_child.parent_id)
end
local function is_higher_child_order(type_1, type_2)
  return (type_1.child_order < type_2.child_order)
end
local function get_project_str(project)
  return (_G.string.rep("#", (project.depth + 1)) .. " " .. project.name .. "|>" .. project.id)
end
local function get_comment_str(todoist_comment)
  return ("+ " .. todoist_comment.content .. "|>" .. todoist_comment.id)
end
local function get_section_str(section)
  return ("& " .. section.name .. "|>" .. section.id)
end
local function list_is_populated(list)
  return (list and (#list > 0))
end
local function add_depth_to_project(project, depth)
  project["depth"] = depth
  if list_is_populated(project.children) then
    for _, child in ipairs(project.children) do
      add_depth_to_project(child, (depth + 1))
    end
  else
  end
  return project
end
local function get_root_project_list(projects)
  local root_projects
  do
    local tbl_21_auto = {}
    local i_22_auto = 0
    for _, project in ipairs(projects) do
      local val_23_auto
      if is_root_project(project) then
        val_23_auto = add_depth_to_project(project, 0)
      else
        val_23_auto = nil
      end
      if (nil ~= val_23_auto) then
        i_22_auto = (i_22_auto + 1)
        tbl_21_auto[i_22_auto] = val_23_auto
      else
      end
    end
    root_projects = tbl_21_auto
  end
  if (#root_projects > 1) then
    table.sort(root_projects, is_higher_child_order)
  else
  end
  return root_projects
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
  if list_is_populated(project.sections) then
    for _, section_str in ipairs(get_list_lines(project.sections, get_section_str)) do
      table.insert(lines, section_str)
    end
  else
  end
  if list_is_populated(project.comments) then
    for _, comment_str in ipairs(get_list_lines(project.comments, get_comment_str)) do
      table.insert(lines, comment_str)
    end
  else
  end
  if list_is_populated(project.children) then
    for _, child_project_strs in ipairs(get_list_lines(project.children, get_project_lines)) do
      for _0, project_str in ipairs(child_project_strs) do
        table.insert(lines, project_str)
      end
    end
  else
  end
  return lines
end
local function add_list_to_project(project, list_name, list, checker)
  if list_is_populated(list) then
    local _16_
    do
      local tbl_21_auto = {}
      local i_22_auto = 0
      for _, value in ipairs(list) do
        local val_23_auto
        if checker(project, value) then
          val_23_auto = value
        else
          val_23_auto = nil
        end
        if (nil ~= val_23_auto) then
          i_22_auto = (i_22_auto + 1)
          tbl_21_auto[i_22_auto] = val_23_auto
        else
        end
      end
      _16_ = tbl_21_auto
    end
    project[list_name] = _16_
  else
  end
  if (list_is_populated(list) and (#list > 1)) then
    table.sort(project[list_name], is_higher_child_order)
  else
  end
  return project
end
local function get_expanded_projects(projects, _3fcomments, _3fsections)
  for _, project in ipairs(projects) do
    add_list_to_project(project, "children", projects, is_child_project)
    add_list_to_project(project, "comments", _3fcomments, is_project_comment)
    add_list_to_project(project, "sections", _3fsections, is_project_section)
  end
  return projects
end
M.get_todoist_lines = function(projects, _3fcomments, _3fsections)
  local expanded_projects = get_expanded_projects(projects, _3fcomments, _3fsections)
  local root_projects = get_root_project_list(expanded_projects)
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
return M
