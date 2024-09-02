local todoist = require("Todoist")
local commands = require("Todoist.nvim.command")

local test_dir = vim.fn.stdpath("cache") .. "/Todoist/tests/"
vim.fn.mkdir(test_dir, "p")
local test_response_path = test_dir .. "full_sync.json"
local test_project_path = test_dir .. "todoist.project"

describe("testing the Ex commands defined for the Plugin", function()
	it("should return the window id for our main project command", function()
		local opts = todoist.config({
			api_key = vim.env.TODOIST_TEST_API_KEY,
			storage = {
				project_file_path = test_project_path,
				response_path = test_response_path,
			},
		})

		commands.create_all_project_commands(opts)
		vim.cmd.TodoistFullSync()

		local success, _ = pcall(io.open, opts.storage.response_path, "r")

		assert(success)
	end)
end)
