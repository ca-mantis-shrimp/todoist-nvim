local M = {}

local add_root_depth = function(project)
	project.depth = 0

	return project
end

local is_root_project = function(project)
	return not project.parent_id or project.parent_id == vim.NIL
end

local is_higher_child_order = function(type_1, type_2)
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

local add_project_lines
add_project_lines = function(project)
	local lines = { get_project_str(project) }

	if project.comments and #project.comments > 0 then
		lines = vim.list_extend(lines, vim.iter(project.comments):map(get_comment_str):totable())
	end
	if project.sections and #project.sections > 0 then
		lines = vim.list_extend(lines, vim.iter(project.sections):map(get_section_str):totable())
	end

	if #project.children > 0 then
		lines = vim.list_extend(lines, vim.iter(project.children):map(add_project_lines):totable())
	end

	return lines
end

M.add_comments_to_projects = function(response)
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

M.add_sections_to_projects = function(response)
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

M.add_children_to_projects = function(response)
	local add_children = function(project)
		local is_child_project = function(potential_child)
			return potential_child.parent_id == project.id
		end
		project.children = vim.iter(response.projects):filter(is_child_project):totable()

		return project
	end

	response.projects = vim.iter(response.projects):map(add_children):totable()

	return response
end

M.add_root_project_list = function(response)
	local root_projects = vim.iter(response.projects):filter(is_root_project):map(add_root_depth):totable()

	table.sort(root_projects, is_higher_child_order)

	response.root_projects = root_projects

	return response
end

M.add_project_depth = function(response)
	local set_project_depth
	set_project_depth = function(project)
		local is_parent_project = function(potential_parent)
			return potential_parent.id == project.parent_id
		end
		if project.parent_id and project.parent_id ~= vim.NIL then
			local parent_project = vim.iter(response.projects):find(is_parent_project)

			assert(
				parent_project,
				"Was unable to find the parent project for"
					.. project.id
					.. project.name
					.. project.parent_id
					.. "unable to set depth"
			)

			project.depth = parent_project.depth + 1
		else
			project.depth = 0
		end

		if #project.children > 0 then
			project.children = vim.iter(project.children):map(set_project_depth):totable()
		end

		return project
	end

	response.root_projects = vim.iter(response.root_projects):map(set_project_depth):totable()

	return response
end

M.add_project_list_lines = function(response)
	response.lines = vim.iter(response.root_projects):map(add_project_lines):flatten(6):totable()

	table.insert(response.lines, "@" .. response.sync_token)

	return response
end

return M
