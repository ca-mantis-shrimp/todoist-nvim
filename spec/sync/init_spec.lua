-- [nfnl] Compiled from spec/sync/init_spec.fnl by https://github.com/Olical/nfnl, do not edit.
local describe = require("plenary.busted").describe
local it = require("plenary.busted").it
local mock_curl = require("Todoist.sync.mock_curl")
local sync_fun = require("Todoist.sync")
local curl = require("plenary.curl")
local function _1_()
  local function _2_()
    do
      local test_response = sync_fun.get_project_sync_response("god-key", mock_curl)
      local expected_response = {projects = {{name = "Inbox", id = 1, child_order = 1}}}
      assert.are.equal(test_response, expected_response)
    end
    return nil
  end
  return it("can be used to make a full sync request", _2_)
end
return describe("we can test just general sync requests", _1_)
