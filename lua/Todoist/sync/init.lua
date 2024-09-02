local requests = require("Todoist.sync.requests")
local utils = require("Todoist.util")

local M = {}

M.get_full_project_sync_response = function(opts)
	assert(
		opts.request.api_key,
		"API key must not be nil for request to work, please either set the 'TODOIST_API_KEY' environment variable or the `api_key` key in the config options"
	)
	return utils.run_pipeline({
		data = opts,
		pipeline = {
			requests.create_project_full_sync_request,
			require(tostring(opts.request.provider)).post,
			requests.process_response,
		},
	})
end

return M
