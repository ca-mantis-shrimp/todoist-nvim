local util = require("Todoist.util")
local schema = require("jsonschema")

local M = {}

local path_separator = util.get_path_separator()
local script_dir = util.get_script_dir()

local path_chunks = vim.fn.split(script_dir, path_separator)
table.remove(path_chunks, table.maxn(path_chunks))
table.remove(path_chunks, table.maxn(path_chunks))

M.root_dir = vim.fn.join(path_chunks, path_separator)
M.schema_dir = string.format("%s%sschemas%s", M.root_dir, path_separator, path_separator)

M.sync_response_schema = schema.generate_validator(
	vim.json.decode(io.open(string.format("%stodoist_sync_schema.json", M.schema_dir, path_separator)))
)

return M
