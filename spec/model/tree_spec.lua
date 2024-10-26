-- [nfnl] Compiled from spec/model/tree_spec.fnl by https://github.com/Olical/nfnl, do not edit.
local get_root_project_list = require("Todoist.model.tree")
local describe = require("plenary.busted").describe
local it = require("plenary.busted").it
local function _1_()
	local function _2_()
		local test_tree = get_root_project_list({
			{
				child_order = 1,
				children = {},
				comments = { { content = "test", id = 1, project_id = 1 } },
				id = 1,
				name = "inbox",
			},
			{
				child_order = 2,
				children = {
					{
						child_order = 3,
						children = {},
						comments = { { content = "test", id = 3, project_id = 3 } },
						id = 3,
						name = "work",
						parent_id = 2,
					},
				},
				comments = { { content = "test", id = 2, project_id = 2 } },
				id = 2,
				name = "work",
			},
		}, {
			{ name = "inbox", id = 1, child_order = 1, parent_id = nil },
			{ name = "work", id = 2, child_order = 2, parent_id = nil },
			{ name = "work", id = 3, child_order = 3, parent_id = 2 },
		})
		local expected_tree = {
			{
				child_order = 1,
				children = {},
				comments = { { content = "test", id = 1, project_id = 1 } },
				depth = 0,
				id = 1,
				name = "inbox",
			},
			{
				child_order = 2,
				children = {
					{
						child_order = 3,
						children = {},
						comments = { { content = "test", id = 3, project_id = 3 } },
						depth = 1,
						id = 3,
						name = "work",
						parent_id = 2,
					},
				},
				comments = { { content = "test", id = 2, project_id = 2 } },
				depth = 0,
				id = 2,
				name = "work",
			},
		}
		do
			local _ = assert.are.same
		end
		return expected_tree
	end
	return it("should be able to create tree if given proper project tree", _2_)
end
return describe("create tree from extended projects", _1_)
