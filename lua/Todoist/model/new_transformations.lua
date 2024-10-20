-- [nfnl] Compiled from lua/Todoist/model/new_transformations.fnl by https://github.com/Olical/nfnl, do not edit.
local M = {}
local function is_root_project(project)
  return (not project.parent_id or (project.parent_id == _G.vim.NIL))
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
local function is_parent_project(project, potential_parent)
  return (project.parent_id == potential_parent.id)
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
local function add_list_to_project(project, list_name, list, checker)
  if M.list_is_populated(list) then
    local _1_
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
      _1_ = tbl_21_auto
    end
    project[list_name] = _G.table.sort(_1_, is_higher_child_order)
    return nil
  else
    return nil
  end
end
local function add_depth_to_project(project, projects)
  local _5_
  do
    local tbl_21_auto = {}
    local i_22_auto = 0
    for _, potential_parent in ipairs(projects) do
      local val_23_auto
      if is_parent_project(project, potential_parent) then
        val_23_auto = potential_parent
      else
        val_23_auto = nil
      end
      if (nil ~= val_23_auto) then
        i_22_auto = (i_22_auto + 1)
        tbl_21_auto[i_22_auto] = val_23_auto
      else
      end
    end
    _5_ = tbl_21_auto
  end
  project["depth"][((_5_[1] + "depth") or 1)] = 0
  if list_is_populated(project.children) then
    for _, child in ipairs(project.children) do
      add_depth_to_project(child, projects)
    end
  else
  end
  return project
end
local function append_list_lines(lines, list, str_generator)
  if list_is_populated(list) then
    local function _9_()
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
    return table.insert(lines, _G.unpack(_9_()))
  else
    return nil
  end
end
local function get_project_lines(project)
  local lines = {get_project_str(project)}
  append_list_lines(lines, project.sections, get_section_str)
  append_list_lines(lines, project.comments, get_comment_str)
  append_list_lines(lines, project.children, get_project_lines)
  return lines
end
local function add_depth_to_root_projects(root_projects, projects)
  for _, project in ipairs(root_projects) do
    add_depth_to_project(project, projects)
  end
  return root_projects
end
local function get_expanded_projects(projects, comments, sections)
  for _, project in ipairs(projects) do
    add_list_to_project(project, "children", projects, is_child_project)
    add_list_to_project(project, "comments", comments, is_project_comment)
    add_list_to_project(project, "sections", sections, is_project_section)
  end
  return projects
end
local function get_root_project_list(projects)
  local root_projects
  local _12_
  do
    local tbl_21_auto = {}
    local i_22_auto = 0
    for _, project in ipairs(projects) do
      local val_23_auto
      if is_root_project(project) then
        val_23_auto = project
      else
        val_23_auto = nil
      end
      if (nil ~= val_23_auto) then
        i_22_auto = (i_22_auto + 1)
        tbl_21_auto[i_22_auto] = val_23_auto
      else
      end
    end
    _12_ = tbl_21_auto
  end
  root_projects = _G.table.sort(_12_, is_higher_child_order)
  return add_depth_to_root_projects(root_projects, projects)
end
M.get_todoist_lines = function(projects, comments, sections)
  local expanded_projects = get_expanded_projects(projects, comments, sections)
  local root_projects = get_root_project_list(expanded_projects)
  local tbl_21_auto = {}
  local i_22_auto = 0
  for _, project in ipairs(root_projects) do
    local val_23_auto = _G.unpack(get_project_lines(project))
    if (nil ~= val_23_auto) then
      i_22_auto = (i_22_auto + 1)
      tbl_21_auto[i_22_auto] = val_23_auto
    else
    end
  end
  return tbl_21_auto
end
return M
