-- [nfnl] Compiled from lua/Todoist/sync/init.fnl by https://github.com/Olical/nfnl, do not edit.
local requests = require("Todoist.sync.request_utils")
local M = {}
M.get_project_sync_response = function(api_key, provider, _3fsync_token)
  local sync_request = requests.create_project_sync_request(api_key, _3fsync_token)
  local sync_response = provider.post(sync_request)
  return requests.process_response(sync_response)
end
return M
