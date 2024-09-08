local M = {}

M.extract_tree_from_file_path = function(opts)
	local hidden_buffer = vim.api.nvim_create_buf(false, true)

	vim.api.nvim_buf_set_lines(hidden_buffer, 0, -1, true, vim.iter(io.lines(opts.storage.project_file_path)):totable())

	local project_tree = vim.treesitter.get_parser(hidden_buffer, "projects"):parse()[1]:root()

	vim.api.nvim_buf_delete(hidden_buffer, {})

	opts.root_node = project_tree

	return opts
end

M.get_tree_table_from_root_node = function(opts) end
return M
