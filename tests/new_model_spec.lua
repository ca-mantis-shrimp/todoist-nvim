local model = require("Todoist.new_model")

local test_project = {
	{
		id = "23410392",
		child_order = 1,
		name = "another project",
		parent_id = nil,
	},
	{
		id = "23410213",
		child_order = 0,
		name = "child_project",
		parent_id = "23410392",
	},
	{
		id = "220474322",
		child_order = 0,
		name = "Inbox",
		parent_id = nil,
	},
}
describe("converting Todoist Data into the lines", function()
	it("can convert a dictionary of projects and comments as nodes", function()
		local types = {
			projects = test_project,
			project_notes = {
				{
					content = "test comment",
					id = "2992679862",
					project_id = "220474322",
					is_deleted = false,
				},
			},
			sections = {
				{
					id = "2182392",
					name = "A section",
					project_id = "220474322",
					section_order = 0,
				},
			},
			sync_token = "test",
		}
		local expected_output = {
			"# Inbox|>220474322",
			"+ test comment|>2992679862",
			"& A section|>23410392",
			"# another project|>23410392",
			"# child_project|>23410392",
			"@test",
		}

		local converted_nodes = model.add_project_list_lines(types)

		assert.are.same(vim.inspect(expected_output), vim.inspect(converted_nodes))
	end)
end)
