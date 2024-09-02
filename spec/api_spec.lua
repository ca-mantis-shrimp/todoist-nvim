local todoist_api = require("Todoist.api")

local api_key = vim.env.TODOIST_TEST_API_KEY

describe("Test Main Todoist API", function()
	it("Can get the full sync response", function()
		local config = {
			request = { api_key = api_key, provider = "plenary.curl" },
		}

		local response = todoist_api.send_full_sync_request(config)

		assert.are.same(#response.projects, 2)
	end)
end)
