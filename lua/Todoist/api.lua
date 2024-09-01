local util = require("Todoist.util")
local curl = require("plenary.curl")
local request_utilities = require("Todoist.request_utilities")
local model = require("Todoist.model")
local filesystem = require("Todoist.filesystem")
local M = {}

M.get_full_project_tree = function(opts)
	assert(opts.api_key, "API key must not be nil for request to work, be sure config was run before this")
	local todoist_types = util.run_pipeline({
		data = opts,
		pipeline = { request_utilities.create_project_full_sync_request, curl.post, request_utilities.process_response },
	})

	filesystem.write_file(opts.response_path, vim.split(vim.json.encode(todoist_types), "\n"))

	local updated_response = model.add_project_list_lines(todoist_types)

	return updated_response.lines
end

return M
