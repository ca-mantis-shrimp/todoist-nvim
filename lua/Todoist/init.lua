local autocmd = require("Todoist.autocommands")
local commands = require("Todoist.command")

local M = {}

M.config = function(opts)
	local default_cache_dir = vim.fn.stdpath("cache")
	setmetatable(opts or {}, {
		__index = {
			api_key = os.getenv("TODOIST_API_KEY"),
			project_file_path = default_cache_dir .. "/Todoist/todoist.projects",
			response_path = default_cache_dir .. "/Todoist/todoist.json",
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

	vim.fn.mkdir(vim.fn.stdpath("cache") .. "/Todoist", "p")

	commands.create_all_project_commands(opts)

	if opts.indent_on_buf_enter then
		autocmd.create_indent_autocmd(opts)
	end
end

return M
