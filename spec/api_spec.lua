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
	it("Can turn a response into tree lines", function()
		local response = {
			projects = {
				{ id = "1", name = "Inbox", child_order = 0 },
				{ id = "2", name = "Test Projet", child_order = 1 },
				{ id = "3", name = "Child Project", parent_id = "2", child_order = 2 },
			},
			project_notes = {
				{ id = "4", content = "Item 1", project_id = "1", child_order = 0 },
				{ id = "5", content = "Item 2", project_id = "2", child_order = 1 },
			},
			sections = {
				{ id = "6", name = "Section 1", project_id = "2", child_order = 0 },
			},
			sync_token = "100",
		}

		local expected_lines = {
			"# Inbox|>1",
			"+ Item 1|>4",
			"# Test Projet|>2",
			"+ Item 2|>5",
			"& Section 1|>6",
			"## Child Project|>3",
			"@100",
		}

		local lines = todoist_api.get_project_lines(response)

		assert.are.same(lines, expected_lines)
	end)
end)
