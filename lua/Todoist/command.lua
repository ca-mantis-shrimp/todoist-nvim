local api = require("Todoist.api")
local filesystem = require("Todoist.filesystem")

local M = {}

M.create_all_project_commands = function()
	vim.api.nvim_create_user_command("TodoistFullSync", function()
		local project_file_path = vim.fn.stdpath("cache") .. "/Todoist/todoist.projects"

		local tree_lines = api.get_full_project_tree()

		filesystem.write_file(project_file_path, tree_lines)
	end, {})

	vim.api.nvim_create_user_command("TodoistOpenProjectFile", function()
		local project_file_path = vim.fn.stdpath("cache") .. "/Todoist/client_todoist.projects"
		vim.cmd("e " .. project_file_path)
	end, {})
end

return M
