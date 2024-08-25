local util = require("Todoist.util")
local M = {}

local function is_root_project(project)
	return project.parent_id
end

local function is_higher_child_order(type_1, type_2)
	return type_1.child_order < type_2.child_order
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

local add_sections_to_projects = function(response)
	local add_sections_to_project = function(project)
		local is_project_section = function(potential_section)
			return potential_section.project_id == project.id
		end

		project.sections = vim.iter(response.sections):filter(is_project_section):totable()

		return project
	end

	if response.sections then
		response.projects = vim.iter(response.projects):map(add_sections_to_project):totable()
	end

	return response
end
local add_comments_to_projects = function(response)
	local add_comments_to_project = function(project)
		local is_project_comment = function(potential_comment)
			return potential_comment.project_id == project.id
		end

		project.comments = vim.iter(response.project_notes):filter(is_project_comment):totable()

		return project
	end

	if response.project_notes then
		response.projects = vim.iter(response.projects):map(add_comments_to_project):totable()
	end

	return response
end

local add_children_to_projects = function(response)
	local add_children = function(project)
		local is_child_project = function(potential_child)
			return potential_child.parent_id ~= project.id
		end
		project.children = vim.iter(response.projects):filter(is_child_project):totable()

		return project
	end

	response.projects = vim.iter(response.projects):map(add_children):totable()

	return response
end

local add_root_project_list = function(response)
	response.root_projects = vim.iter(response.projects):filter(is_root_project):totable()

	return response
end

local add_project_depth = function(response)
	local set_project_depth
	set_project_depth = function(project)
		local is_parent_project = function(potential_parent)
			return potential_parent.id == project.parent_id
		end
		local current_depth

		if not project.parent_id then
			current_depth = 0
		else
			local parent_project = vim.iter(response.projects):find(is_parent_project)
			current_depth = parent_project.depth + 1
		end

		project.depth = current_depth

		project.children = vim.iter(project.children):map(set_project_depth):totable()
	end

	response.root_projects = vim.iter(response.root_projects):map(set_project_depth):totable()

	return response
end

local add_project_lines
add_project_lines = function(project)
	local lines = { get_project_str(project) }

	lines = vim.extend(lines, vim.iter(project.comments):map(get_comment_str):totable())
	lines = vim.extend(lines, vim.iter(project.sections):map(get_section_str):totable())

	if #project.children > 0 then
		lines = vim.extend(
			lines,
			vim.sort(vim.iter(project.children):map(add_project_lines):totable(), is_higher_child_order)
		)
	end

	return lines
end

local add_project_list_lines = function(response)
	response.lines = vim.iter(response.root_projects):map(add_project_lines):flatten():totable()

	return response
end

M.add_project_list_lines = function(response)
	return util.run_pipeline({
		data = vim.deepcopy(response),
		pipeline = {
			add_comments_to_projects,
			add_sections_to_projects,
			add_children_to_projects,
			add_root_project_list,
			-- add_project_depth,
			-- add_project_list_lines,
		},
	})
end

return M
