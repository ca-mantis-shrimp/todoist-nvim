local util = require("Todoist.util")
local transformations = require("Todoist.model.transformations")

local M = {}

local print_root_projects = function(response)
	print(vim.inspect(response.root_projects))

	return response
end

M.add_project_list_lines = function(opts)
	return util.run_pipeline({
		data = vim.deepcopy(opts),
		pipeline = {
			transformations.add_comments_to_projects,
			transformations.add_sections_to_projects,
			transformations.add_children_to_projects,
			transformations.add_root_project_list,
			transformations.add_project_depth,
			transformations.add_project_list_lines,
		},
	})
end

return M
