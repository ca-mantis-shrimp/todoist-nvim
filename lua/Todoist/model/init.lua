local util = require("Todoist.util")
local transformations = require("Todoist.model.transformations")

local M = {}

M.add_project_list_lines = function(response)
	return util.run_pipeline({
		data = vim.deepcopy(response),
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
