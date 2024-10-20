-- [nfnl] Compiled from lua/Todoist/model/new_transformations.fnl by https://github.com/Olical/nfnl, do not edit.
local M = {}
M.add_root_depth = function(project)
  project["depth"] = 0
  return project
end
M.is_root_project = function(project)
  return (not project.parent_id or (project.parent_id == _G.vim.NIL))
end
M.is_project_comment = function(project, todoist_comment)
  return (project.id == todoist_comment.project_id)
end
M.is_project_section = function(project, section)
  return (project.id == section.project_id)
end
M.is_child_project = function(project, potential_child)
  return (project.id == potential_child.parent_id)
end
M.is_parent_project = function(project, potential_parent)
  return (project.parent_id == potential_parent.id)
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
M.add_list_to_project = function(project, list_name, list, checker)
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
    project[list_name] = _1_
    return nil
  else
    return nil
  end
end
M.add_lists_to_projects = function(opts)
  for _, project in ipairs(opts.response.projects) do
    M.add_list_to_project(project, "children", opts.response.projects, M.is_project_child)
    local _6_
    do
      local t_5_ = opts
      if (nil ~= t_5_) then
        t_5_ = t_5_.response
      else
      end
      if (nil ~= t_5_) then
        t_5_ = t_5_.comments
      else
      end
      _6_ = t_5_
    end
    M.add_list_to_project(project, "comments", _6_, M.is_project_comment)
    local _10_
    do
      local t_9_ = opts
      if (nil ~= t_9_) then
        t_9_ = t_9_.response
      else
      end
      if (nil ~= t_9_) then
        t_9_ = t_9_.sections
      else
      end
      _10_ = t_9_
    end
    M.add_list_to_project(project, "sections", _10_, M.is_project_section)
  end
  return opts
end
M.add_root_project_list = function(opts)
  local _13_
  do
    local tbl_21_auto = {}
    local i_22_auto = 0
    for _, project in ipairs(opts.response.projects) do
      local val_23_auto
      if M.is_root_project(project) then
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
    _13_ = tbl_21_auto
  end
  opts["root_projects"] = _13_
  return opts
end
M.add_depth_to_root_project = function(project, projects)
  local _16_
  do
    local tbl_21_auto = {}
    local i_22_auto = 0
    for _, potential_parent in ipairs(projects) do
      local val_23_auto
      if M.is_project_parent(project, potential_parent) then
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
    _16_ = tbl_21_auto
  end
  project["depth"][((_16_[1] + "depth") or 1)] = 0
  if M.list_is_populated(project.children) then
    for _, child in ipairs(project.children) do
      M.add_depth_to_project(child, projects)
    end
  else
  end
  return project
end
M.add_depth_to_root_projects = function(opts)
  for _, project in ipairs(opts.response.root_projects) do
    M.add_depth_to_root_project(project, opts.response.projects)
  end
  return nil
end
M.append_list_lines = function(lines, list, str_generator)
  if M.list_is_populated(list) then
    local function _20_()
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
    return table.insert(lines, _G.unpack(_20_()))
  else
    return nil
  end
end
M.get_project_lines = function(project)
  local lines = {M.get_project_str(project)}
  M.append_list_lines(lines, project.sections, M.get_section_str)
  M.append_list_lines(lines, project.comments, M.get_comment_str)
  M.append_list_lines(lines, project.children, M.add_project_lines)
  return lines
end
M.add_todoist_lines = function(opts)
  local _23_
  do
    local tbl_21_auto = {}
    local i_22_auto = 0
    for _, project in ipairs(opts.response.root_projects) do
      local val_23_auto = _G.unpack(M.get_project_lines(project))
      if (nil ~= val_23_auto) then
        i_22_auto = (i_22_auto + 1)
        tbl_21_auto[i_22_auto] = val_23_auto
      else
      end
    end
    _23_ = tbl_21_auto
  end
  opts["lines"] = _23_
  return opts
end
return M
