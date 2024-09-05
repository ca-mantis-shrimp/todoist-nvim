local treesitter = require("Todoist.nvim.treesitter")
local util = require("Todoist.util")

describe("Treesitter integration", function()
	it("can pull a treesitter tree from a file path", function()
		local tree = treesitter.extract_tree_from_file_path({
			storage = { project_file_path = util.get_script_dir() .. "/data/easy_path_project.projects" },
		})

		assert(tree)
	end)
end)
