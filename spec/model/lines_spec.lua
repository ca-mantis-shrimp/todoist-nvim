-- [nfnl] Compiled from spec/model/lines_spec.fnl by https://github.com/Olical/nfnl, do not edit.
local get_project_lines = require("Todoist.model.lines")
local describe = require("plenary.busted").describe
local it = require("plenary.busted").it
local function _1_()
  local function _2_()
    local test_lines = get_project_lines({{child_order = 2, children = {{child_order = 3, children = {{name = "child", id = 5, parent_id = 3, depth = 2}}, comments = {{content = "test", id = 3, project_id = 3}}, depth = 1, id = 3, name = "work", parent_id = 2}}, comments = {{content = "test", id = 2, project_id = 2}, {content = "another", id = 7, project_id = 3}}, depth = 0, id = 2, name = "work"}, {name = "another-project", id = 8, ["child_order:"] = 2, depth = 0, children = {}, sections = {}, comments = {}}})
    local expected_lines = {"# work|>2", "+ test|>2", "+ another|>7", "## work|>3", "+ test|>3", "### child|>5", "# another-project|>8"}
    assert.are.same(test_lines, expected_lines)
    return nil
  end
  return it("should be able to convert a root project properly", _2_)
end
return describe("creating projects from lines", _1_)
