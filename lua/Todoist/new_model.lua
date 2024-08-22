local util = require("Todoist.util")
local M = {}

local function is_root_project(project)
	return project.parent_id == nil
end

local function is_higher_child_order(type_1, type_2)
	return type_1.child_order < type_2.child_order
end

local sort_types = function(types)
	for _, type in ipairs({ "projects", "project_notes", "sections", "items", "notes" }) do
		if types.type then
			table.sort(types[type], is_higher_child_order)
		end

		return types
	end
end

local add_root_projects = function(types)
	types.root_projects = vim.iter(types.projects):filter(is_root_project):totable()

	return types
end

local add_comments_to_projects = function(types)
	local add_comments = function(project)
		local is_project_comment = function(note)
			return note.project_id == project.id
		end

		project.comments = vim.iter(types.project_notes):filter(is_project_comment):totable()

		return project
	end

	if types.project_notes then
		types.projects = vim.iter(types.projects):map(add_comments):totable()
	end

	return types
end

local add_sections_to_projects = function(types)
	local add_sections = function(project)
		local is_project_section = function(note)
			return note.project_id == project.id
		end

		project.sections = vim.iter(types.project_notes):filter(is_project_section):totable()

		return project
	end

	if types.sections then
		types.projects = vim.iter(types.projects):map(add_sections):totable()
	end

	return types
end
local add_children_to_projects = function(types)
	local add_child_projects = function(project)
		local is_child_project = function(potential_child)
			return potential_child.parent_id == project.id
		end

		project.child_projects = vim.iter(types.projects):filter(is_child_project):totable()

		return project
	end

	types.projects = vim.iter(types.projects):map(add_child_projects):totable()

	return types
end

local set_project_depth
set_project_depth = function(project, depth)
	project.depth = depth

	if util.length(project.child_projects) > 0 and depth < 8 then
		for _, child_project in ipairs(project.child_projects) do
			set_project_depth(child_project, depth + 1)
		end
	end

	return project
end

local set_project_depths_from_root = function(types)
	for _, project in ipairs(types.projects) do
		set_project_depth(project, 0)
	end

	return types
end

local get_project_str = function(project)
	return string.rep("#", project.depth + 1) .. " " .. project.name .. "|>" .. project.id
end

local get_comment_str = function(comment)
	return "+ " .. comment.content .. "|>" .. comment.id
end

local get_section_str = function(section)
	return "& " .. section.name .. "|>" .. section.id
end

local get_project_lines

get_project_lines = function(project)
	local lines = {}

	table.insert(lines, get_project_str(project))
	table.insert(lines, vim.iter(project.comments):map(get_comment_str))
	table.insert(lines, vim.iter(project.sections):map(get_section_str))

	if project.child_projects and util.length(project.child_projects) > 0 then
		for _, child in ipairs(project.children) do
			table.insert(lines, get_project_lines(child))
		end
	end

	return lines
end
local add_project_list_lines = function(types)
	types.lines = vim.iter(types.root_projects):map(get_project_lines)

	return types
end
local add_sync_token_line = function(types)
	table.insert(types.lines, "@" .. types.sync_token)

	return types
end

M.add_project_list_string = function(response)
	assert(response.projects, "project list is required")
	local updated_response = util.run_pipeline({
		data = response,
		pipeline = {
			sort_types,
			add_comments_to_projects,
			add_sections_to_projects,
			add_children_to_projects,
			add_root_projects,
			set_project_depths_from_root,
			add_project_list_lines,
			add_sync_token_line,
		},
	})

	return updated_response.lines
end

return M
