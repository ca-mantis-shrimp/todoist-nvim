-- [nfnl] Compiled from lua/Todoist/model/init.fnl by https://github.com/Olical/nfnl, do not edit.
local get_projects = require("Todoist.model.project")
local get_tree = require("Todoist.model.tree")
local get_lines = require("Todoist.model.lines")
local function get_todoist_lines(projects, _3fcomments, _3fsections)
  return get_lines(get_tree(get_projects(projects, _3fcomments, _3fsections)))
end
return get_todoist_lines
