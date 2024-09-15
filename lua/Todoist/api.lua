local sync_api = require("Todoist.sync")
local model = require("Todoist.model")
local util = require("Todoist.util")
local M = {}

M.send_sync_request = function(opts)
	local updated_opts

	-- Either we do an incremental sync if we have a response, otherwise we just do a full sync
	if opts.response then
		updated_opts = opts:set("response", util.tableMerge(opts.response, sync_api.get_project_sync_response(opts)))
	else
		updated_opts = opts:set("response", sync_api.get_project_sync_response(opts))
	end

	return updated_opts
end
M.get_project_lines = function(opts)
	assert(opts.response, "need a response to analyze for project lines")

	return model.add_project_list_lines(opts)
end

return M
