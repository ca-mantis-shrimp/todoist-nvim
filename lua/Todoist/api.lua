local sync_api = require("Todoist.sync")
local model = require("Todoist.model")
local M = {}

M.send_sync_request = function(opts)
	local opts_copy = vim.deepcopy(opts)
	if opts_copy.response then
		opts_copy.response =
			vim.tbl_deep_extend("force", opts_copy.response, sync_api.get_project_sync_response(opts_copy))
	else
		opts_copy.response = sync_api.get_project_sync_response(opts_copy)
	end

	return opts_copy
end
M.get_project_lines = function(opts)
	local opts_copy = vim.deepcopy(opts)

	assert(opts_copy.response, "need a response to analyze for project lines")

	return model.add_project_list_lines(opts_copy)
end

return M
