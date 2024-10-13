-- [nfnl] Compiled from sync/requests.fnl by https://github.com/Olical/nfnl, do not edit.
local M = {}
M["url"] = "https://api.todoist.com/sync/v9/sync"
M["todoist_resources_types"] = {
	"projects",
	"items",
	"notes",
	"labels",
	"sections",
	"reminders",
	"reminders_location",
	"locations",
	"users",
	"live_notification",
	"collaborators",
	"user_settings",
	"notifications_settings",
	"user_plan_limits",
	"completed_info",
	"stats",
}
M["response_status_codes"] = {
	[200] = "OK",
	[400] = "Bad Request: The Request was incorrect",
	[401] = "Unauthorized: Authentication is required, and has failed, or has not yet been provided",
	[403] = "Forbidden: the request was valid, but for something that is forbidden",
	[404] = "Not Foun: the requested resource could not be found",
	[429] = "Too many requests: the user sent too many requests in a given amount of time",
	[500] = "Internal Server Error: the request failed due to a server error",
	[503] = "Service Unavailable : The server is currently unable to handle the request",
}
local function _1_(name, temp_id, uuid, parent, child_order, is_favorite)
	assert(name, "Must have a name for our new project!")
	local command = {
		type = "project_add",
		temp_id = temp_id,
		uuid = uuid,
		args = { name = name, parent = parent, child_order = child_order, is_favorite = is_favorite },
	}
	return _G.vim.json.encode(command)
end
M["todoist_commands"] = { project_add = _1_ }
local function _2_(opts)
	return {
		url = M.url,
		headers = { Authorization = ("Bearer " .. opts.request.api_key) },
		data = {
			sync_token = (opts.request.sync_token or "*"),
			resource_types = _G.vim.json.encode({ "projects", "notes", "sections" }),
		},
		timeout = 100000,
	}
end
M["create_project_sync_request"] = _2_
local function _3_(response)
	assert((response.status == 200), M.response_status_codes[response.status])
	return _G.vim.json.decode(response.body)
end
M["process_response"] = _3_
return M
