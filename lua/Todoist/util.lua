local M = {}

M.length = function(table)
	local count = 0

	for _ in pairs(table) do
		count = count + 1
	end

	return count
end

-- Need to do it this way for recursive functions
local tableMerge
tableMerge = function(t1, t2)
	for k, v in pairs(t2) do
		if type(v) == "table" then
			if type(t1[k] or false) == "table" then
				tableMerge(t1[k] or {}, t2[k] or {})
			else
				t1[k] = v
			end
		else
			t1[k] = v
		end
	end
	return t1
end
M.tableMerge = tableMerge

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
