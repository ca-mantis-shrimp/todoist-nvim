-- [nfnl] Compiled from spec/model/init_spec.fnl by https://github.com/Olical/nfnl, do not edit.
local get_todoist_lines = require("Todoist.model")
local describe = require("plenary.busted").describe
local it = require("plenary.busted").it
local function _1_()
	local function _2_()
		local projects = {
			{ name = "inbox", id = 1, child_order = 1, parent_id = nil },
			{ name = "work", id = 2, child_order = 2, parent_id = nil },
			{ name = "work", id = 3, child_order = 3, parent_id = 2 },
		}
		local comments = {
			{ content = "test", id = 1, project_id = 1 },
			{ content = "test", id = 2, project_id = 2 },
			{ content = "test", id = 3, project_id = 3 },
		}
		local expected = { "# inbox|>1", "+ test|>1", "# work|>2", "+ test|>2", "## work|>3", "+ test|>3" }
		local output = get_todoist_lines(projects, comments, nil)
		return assert.are.same(expected, output)
	end
	return it("should be able to work without a section view", _2_)
end
return describe("the main module function for extracting the project lines from the various lists", _1_)
