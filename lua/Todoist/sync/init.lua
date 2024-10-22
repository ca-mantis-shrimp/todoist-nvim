-- [nfnl] Compiled from lua/Todoist/sync/init.fnl by https://github.com/Olical/nfnl, do not edit.
local requests = require("Todoist.sync.requests")
local utils = require("Todoist.util")
local M
local function _1_(opts)
  local request_provider = require(opts.request.provider)
  assert(request_provider.post, "Provider must support the post function to properly interact with the sync API for todoist")
  return utils.run_pipeline({data = opts, pipeline = {requests.create_project_sync_request, request_provider.post, requests.process_response}})
end
M = {get_project_sync_response = _1_}
return M
