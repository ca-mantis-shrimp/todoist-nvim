local util = require("Todoist.util")
local autocmd = require("Todoist.nvim.autocommands")
local commands = require("Todoist.nvim.command")

local M = {}

M.config = function(opts)
	local default_cache_dir = vim.fn.stdpath("cache")

	-- merge whatever we are given with defaults and make persistent
	local persistent_opts = util.create_persistent_table(util.tableMerge({
		request = { api_key = os.getenv("TODOIST_API_KEY"), provider = "plenary.curl" },
		storage = {
			project_file_path = default_cache_dir .. "/Todoist/todoist.projects",
			response_path = default_cache_dir .. "/Todoist/full_todoist_projects.json",
		},
		ui = { default_window_type = "active_window", indent_on_buf_enter = true },
		logging = true,
	}, opts))

	-- Add projects filetype
	vim.filetype.add({
		extension = {
			projects = "projects",
		},
	})

	-- ensure we have a Todoist cache dir for future files
	vim.fn.mkdir(vim.fn.stdpath("cache") .. "/Todoist", "p")

	-- create the relevant commands for users to run
	commands.create_all_project_commands(persistent_opts)

	-- if they want, enable the autocommand to automatically indent
	if opts.indent_on_buf_enter then
		autocmd.create_indent_autocmd(persistent_opts)
	end

	return persistent_opts
end

function M.setup(opts)
	return M.config(opts)
end

return M
