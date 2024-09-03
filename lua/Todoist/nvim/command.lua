local api = require("Todoist.api")
local filesystem = require("Todoist.nvim.filesystem")

local M = {}

M.create_all_project_commands = function(opts)
	vim.api.nvim_create_user_command("TodoistSync", function()
		local file_handle = io.open(opts.storage.response_path, "r")

		if file_handle and file_handle:lines("*l") then
			opts.response = filesystem.extract_table_from_json(opts.storage.response_path)
		end

		local opts_with_response = api.send_sync_request(opts)

		io.write(opts.storage.response_path, vim.json.encode(opts_with_response.response))

		print(vim.inspect(opts_with_response))
		local opts_with_lines = api.get_project_lines(opts_with_response)

		filesystem.write_file(opts.storage.project_file_path, opts_with_lines.lines)
	end, {})

	vim.api.nvim_create_user_command("TodoistOpenProjectFile", function()
		local project_file_path = opts.storage.project_file_path
		vim.cmd("e " .. project_file_path)
	end, {})
end

return M
