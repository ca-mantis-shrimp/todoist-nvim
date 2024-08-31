local M = {}

M.length = function(table)
	local count = 0

	for _ in pairs(table) do
		count = count + 1
	end

	return count
end

M.merge_tables = function(t1, t2)
	local mergedTable = {}
	for k, v in pairs(t1) do
		mergedTable[k] = v
	end
	for k, v in pairs(t2) do
		mergedTable[k] = v
	end
	return mergedTable
end

M.is_win = function()
	return package.config:sub(1, 1) == "\\"
end

M.get_path_separator = function()
	if M.is_win() then
		return "\\"
	end

	return "/"
end

M.get_script_dir = function()
	local str = debug.getinfo(2, "S").source:sub(2)

	if M.is_win() then
		str = str:gsub("/", "\\")
	end

	return str:match("(.*" .. M.get_path_separator() .. ")")
end

M.run_pipeline = function(opts)
	local data = opts.data

	for _, fn in ipairs(opts.pipeline) do
		data = fn(data)
	end

	return data
end

M.print_and_pass = function(opts)
	print(vim.inspect(opts))

	return opts
end

return M
