-- [nfnl] Compiled from spec/sync/init_spec.fnl by https://github.com/Olical/nfnl, do not edit.
local describe = require("plenary.busted").describe
local it = require("plenary.busted").it
local sync = require("Todoist.sync")
local mock_curl
local function _1_(opts)
  if (opts == {url = "https://api.todoist.com/sync/v9/sync", headers = {Authorization = "Bearer good-key"}, data = {["sync_token:"] = nil, resource_types = _G.vim.json.encode({"projects", "notes", "sections"}), timeout = 100000}}) then
    return {status = 200, body = {true_sync = true, sync_token = "sync-token", projects = {{name = "Inbox", id = 2, child_order = 1}}}}
  else
    return {status_code = 401}
  end
end
mock_curl = {post = _1_}
local function _3_()
  local function _4_()
    do
      local test_response = sync("good-key", nil, mock_curl)
      local expected_response = {projects = {{name = "Inbox", id = 1, child_order = 1}}}
      assert.are.same(test_response, expected_response)
    end
    return nil
  end
  return it("can be used to make a full sync request", _4_)
end
return describe("we can test just general sync requests", _3_)
