local util = require("Todoist.util")
local schema = require("jsonschema")

local M = {}

local path_separator = util.get_path_separator()
local script_dir = util.get_script_dir()

local get_root_dir = function(script_dir, path_separator)
	local path_chunks = vim.fn.split(vim.copy(script_dir), path_separator)
	table.remove(path_chunks, table.maxn(path_chunks))
	table.remove(path_chunks, table.maxn(path_chunks))

	return path_chunks
end

M.root_dir = vim.fn.join(get_root_dir(script_dir, path_separator), path_separator)
M.schema_dir = string.format("%s%sschemas%s", M.root_dir, path_separator, path_separator)

M.sync_response_schema = schema.generate_validator(
	vim.json.decode(io.open(string.format("%stodoist_sync_schema.json", M.schema_dir, path_separator)))
)

return M
