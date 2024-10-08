local window = require("Todoist.nvim.window")

describe("Neovim Lua API", function()
	it("Can Test that a window was successfully created and shown on the current screen", function()
		local buffer_id = vim.api.nvim_create_buf(false, true)

		local buf_window = window.create_split_window(buffer_id)

		assert.is_true(vim.api.nvim_win_is_valid(buf_window))
	end)
end)
