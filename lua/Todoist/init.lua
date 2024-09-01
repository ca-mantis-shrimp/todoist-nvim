local api = require("Todoist.api")
local autocmd = require("Todoist.autocommands")
local config_mod = require("Todoist.config")
local commands = require("Todoist.command")

local M = {}

M.config = function(opts)
	local default_cache_dir = vim.fn.stdpath("cache")
	setmetatable(opts or {}, {
		__index = {
			api_key = os.getenv("TODOIST_API_KEY"),
			cache_dir = default_cache_dir,
			project_file_path = (opts.cache_dir or default_cache_dir) .. "/Todoist/todoist.projects",
			response_path = (opts.cache_dir or default_cache_dir) .. "/Todoist/todoist.json",
			default_window_type = "active_window",
			logging = true,
			indent_on_buf_enter = true,
		},
	})

	return opts
end

function M.setup(opts)
	opts = M.config(opts)

	vim.filetype.add({
		extension = {
			projects = "projects",
		},
	})

	vim.fn.mkdir(opts.cache_dir, "p")

	commands.create_all_project_commands(opts)

	if config_mod.indent_on_buf_enter then
		autocmd.create_indent_autocmd(opts)
	end
end

return M
