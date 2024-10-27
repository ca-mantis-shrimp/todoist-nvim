-- [nfnl] Compiled from lua/Todoist/model/tree.fnl by https://github.com/Olical/nfnl, do not edit.
local util = require("Todoist.fnl_util")
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
local function add_depth_to_project(project, depth)
  project["depth"] = depth
  if util.list_is_populated(project.children) then
    for _, child in ipairs(project.children) do
      add_depth_to_project(child, (depth + 1))
    end
  else
  end
  return project
end
local function get_project_tree(projects)
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
    table.sort(root_projects, util.is_higher_child_order)
  else
  end
  return root_projects
end
return get_project_tree
