-- [nfnl] Compiled from lua/Todoist/sync/request_utils.fnl by https://github.com/Olical/nfnl, do not edit.
local M = {todoist_commands = {}, url = "https://api.todoist.com/sync/v9/sync", todoist_resources_types = {"projects", "items", "notes", "labels", "sections", "reminders", "reminders_location", "locations", "users", "live_notification", "collaborators", "user_settings", "notifications_settings", "user_plan_limits", "completed_info", "stats"}, response_status_codes = {[200] = "OK", [400] = "Bad Request: The Request was incorrect", [401] = "Unauthorized: Authentication is required, and has failed, or has not yet been provided", [403] = "Forbidden: the request was valid, but for something that is forbidden", [404] = "Not Foun: the requested resource could not be found", [429] = "Too many requests: the user sent too many requests in a given amount of time", [500] = "Internal Server Error: the request failed due to a server error", [503] = "Service Unavailable : The server is currently unable to handle the request"}}
M.todoist_commands.project_add = function(name, temp_id, uuid, parent, child_order, is_favorite)
  assert(name, "Must have a name for our new project!")
  local command = {type = "project_add", temp_id = temp_id, uuid = uuid, args = {name = name, parent = parent, child_order = child_order, is_favorite = is_favorite}}
  return _G.vim.json.encode(command)
end
M.create_project_sync_request = function(api_key, _3fsync_token)
  return {url = M.url, headers = {Authorization = ("Bearer " .. api_key)}, data = {sync_token = (_3fsync_token or "*"), resource_types = _G.vim.json.encode({"projects", "notes", "sections"}), timeout = 100000}}
end
M.process_response = function(response)
  assert((response.status == 200), M.response_status_codes[response.status])
  return _G.vim.json.decode(response.body)
end
return M
