local api = require("Todoist.api")
local filesystem = require("Todoist.nvim.filesystem")

local M = {}

M.create_all_project_commands = function(opts)
	vim.api.nvim_create_user_command("TodoistFullSync", function()
		local response = api.send_full_sync_request(opts)

		filesystem.write_file(opts.storage.response_path, vim.split(vim.json.encode(response), "\n"))

		local project_lines = api.get_project_lines(response)

		filesystem.write_file(opts.storage.project_file_path, project_lines)
	end, {})

	vim.api.nvim_create_user_command("TodoistOpenProjectFile", function()
		local project_file_path = opts.storage.project_file_path
		vim.cmd("e " .. project_file_path)
	end, {})
end

return M
