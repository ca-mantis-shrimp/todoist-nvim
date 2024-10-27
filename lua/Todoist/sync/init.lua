-- [nfnl] Compiled from lua/Todoist/sync/init.fnl by https://github.com/Olical/nfnl, do not edit.
local requests = require("Todoist.sync.request_utils")
local curl = require("plenary.curl")
local function get_project_sync_response(api_key, _3fsync_token, _3fprovider)
  local _2_
  do
    local t_1_ = _3fprovider.post
    _2_ = t_1_
  end
  return requests.process_response((_2_ or curl.post)(requests.create_project_sync_request(api_key, _3fsync_token)))
end
return get_project_sync_response
