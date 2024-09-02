local autocmd = require("Todoist.nvim.autocommands")
local commands = require("Todoist.nvim.command")

local M = {}

M.config = function(opts)
	local default_cache_dir = vim.fn.stdpath("cache")
	setmetatable(opts or {}, {
		__index = {
			request = { api_key = os.getenv("TODOIST_API_KEY"), provider = "plenary.curl" },
			storage = {
				project_file_path = default_cache_dir .. "/Todoist/todoist.projects",
				response_path = default_cache_dir .. "/Todoist/todoist.json",
			},
			ui = { default_window_type = "active_window", indent_on_buf_enter = true },
			logging = true,
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
