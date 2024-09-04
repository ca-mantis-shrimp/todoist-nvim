local M = {}

M.extract_tree_from_file_path = function(opts)
	local project_lines = vim.iter(io.lines(opts.storage.project_file_path)):totable()

	local hidden_buffer = vim.api.nvim_create_buf(false, true)

	vim.api.nvim_buf_set_lines(hidden_buffer, 0, -1, true, project_lines)

	local project_tree = vim.treesitter.get_parser(hidden_buffer, "projects")

	return project_tree
end

return M
