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
	local result = {}
	for k, v in pairs(t1) do
		result[k] = v
	end
	for k, v in pairs(t2) do
		if type(v) == "table" then
			if type(result[k] or false) == "table" then
				result[k] = tableMerge(result[k] or {}, v)
			else
				result[k] = tableMerge({}, v)
			end
		else
			result[k] = v
		end
	end
	return result
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

M.create_persistent_table = function(initial_table)
	local function create_new_table(old_table, changes)
		local new_table = {}
		for k, v in pairs(old_table) do
			if type(v) == "table" then
				new_table[k] = create_new_table(v, changes[k] or {})
			else
				new_table[k] = changes[k] ~= nil and changes[k] or v
			end
		end
		for k, v in pairs(changes) do
			if old_table[k] == nil then
				new_table[k] = v
			end
		end
		return new_table
	end

	local persistent_table = {
		_data = initial_table or {},
		set = function(self, key, value)
			local changes = { [key] = value }
			return M.create_persistent_table(create_new_table(self._data, changes))
		end,
		get = function(self, key)
			return self._data[key]
		end,
		to_table = function(self)
			return self._data
		end,
		merge = function(self, other_table)
			return M.create_persistent_table(M.tableMerge(self._data, other_table))
		end,
	}

	return setmetatable(persistent_table, {
		__index = function(t, k)
			return t._data[k]
		end,
		__newindex = function(_, _, _)
			error("direct modification prohibited, please use proper set")
		end,
	})
end

return M
