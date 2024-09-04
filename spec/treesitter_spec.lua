local treesitter = require("Todoist.nvim.treesitter")
local util = require("Todoist.util")

describe("Treesitter integration", function()
	it("can pull a treesitter tree from a file path", function()
		vim.filetype.add({
			extension = {
				projects = "projects",
			},
		})
		require("nvim-treesitter.parsers").get_parser_configs().projects = {
			install_info = {
				url = "~/Products/tree-sitter-projects",
				files = { "src/parser.c" },
				generate_requires_npm = false,
				requires_generate_from_grammar = false,
			},
			filetype = "projects",
		}
		local tree = treesitter.extract_tree_from_file_path({
			storage = { project_file_path = util.get_script_dir() .. "/data/easy_path_project.projects" },
		})

		assert(tree)
	end)
end)
