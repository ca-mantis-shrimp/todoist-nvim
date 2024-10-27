-- [nfnl] Compiled from lua/Todoist/model/project.fnl by https://github.com/Olical/nfnl, do not edit.
local util = require("Todoist.fnl_util")
local function is_project_comment(project, todoist_comment)
  return (project.id == todoist_comment.project_id)
end
local function is_project_section(project, section)
  return (project.id == section.project_id)
end
local function is_child_project(project, potential_child)
  return (project.id == potential_child.parent_id)
end
local function add_list_to_project(project, list_name, list, checker)
  if util.list_is_populated(list) then
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
    project[list_name] = _1_
  else
  end
  if (util.list_is_populated(list) and (#list > 1)) then
    table.sort(project[list_name], util.is_higher_child_order)
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
return get_expanded_projects
