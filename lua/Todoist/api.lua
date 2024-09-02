local sync_api = require("Todoist.sync")
local model = require("Todoist.model")
local M = {}

M.send_full_sync_request = function(opts)
	local todoist_types = sync_api.get_full_project_sync_response(opts)

	return todoist_types
end
M.get_project_lines = function(opts)
	local updated_response = model.add_project_list_lines(opts)

	return updated_response.lines
end

return M
