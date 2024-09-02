local todoist = require("Todoist")

describe("initial plugin config", function()
	it("a minimal config will have all defaults", function()
		local config = todoist.config({})

		assert.are.same(config.request.api_key, os.getenv("TODOIST_API_KEY"))
		assert.are.same(config.storage.project_file_path, vim.fn.stdpath("cache") .. "/Todoist/todoist.projects")
		assert.are.same(config.storage.response_path, vim.fn.stdpath("cache") .. "/Todoist/todoist.json")
		assert(config.logging)
		assert(config.ui.indent_on_buf_enter)
	end)
end)
