-- [nfnl] Compiled from lua/todoist-test/init.fnl by https://github.com/Olical/nfnl, do not edit.
local M = {mock_curl = {}}
M.mock_curl.post = function(opts)
  if (opts == {url = "https://api.todoist.com/sync/v9/sync", headers = {Authorization = "Bearer good-key"}, data = {["sync_token:"] = nil, resource_types = _G.vim.json.encode({"projects", "notes", "sections"}), timeout = 100000}}) then
    return {status = 200, body = {true_sync = true, sync_token = "sync-token", projects = {{name = "Inbox", id = 2, child_order = 1}}}}
  else
    return {status_code = 401}
  end
end
return M.mock_curl.post
