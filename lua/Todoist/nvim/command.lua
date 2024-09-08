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

		-- we have to do it this way otherwise we can run into column limits with very large user profiles
		-- if it gets really bad, i might need to break each project into its own line to ensure we dont hit limits
		io.output(opts.storage.response_path):write(
			"{\n",
			'"full_sync": ' .. vim.json.encode(opts_with_response.response.full_sync) .. ",\n",
			'"sync_token": ' .. vim.json.encode(opts_with_response.response.sync_token) .. ",\n",
			'"temp_id_mapping": ' .. vim.json.encode(opts_with_response.response.temp_id_mapping) .. ",\n",
			'"projects": ' .. vim.json.encode(opts_with_response.response.projects) .. ",\n",
			'"project_notes": ' .. vim.json.encode(opts_with_response.response.project_notes) .. ",\n",
			'"sections": ' .. vim.json.encode(opts_with_response.response.sections) .. "\n",
			"}"
		)

		local opts_with_lines = api.get_project_lines(opts_with_response)

		filesystem.write_file(opts.storage.project_file_path, opts_with_lines.lines)
	end, {})

	vim.api.nvim_create_user_command("TodoistOpenProjectFile", function()
		local project_file_path = opts.storage.project_file_path
		vim.cmd("e " .. project_file_path)
	end, {})
end

return M
