#!/usr/bin/env -S nvim -l

vim.env.LAZY_STDPATH = ".tests"
load(vim.fn.system("curl -s https://raw.githubusercontent.com/folke/lazy.nvim/main/bootstrap.lua"))()

require("lazy.minit").busted({
	spec = {
		{ "nvim-lua/plenary.nvim", lazy = true },
		{ "nvim-treesitter/nvim-treesitter", lazy = true },
		{
			"ca-mantis-shrimp/tree-sitter-projects",
			config = function()
				local ts_parsers = require("nvim-treesitter.parsers")
				vim.filetype.add({
					extension = {
						projects = "projects",
					},
				})

				ts_parsers.get_parser_configs().projects = {
					install_info = {
						url = vim.env.LAZY_STDPATH .. "/data/nvim/lazy/tree-sitter-projects",
						files = { "src/parser.c" },
					},
					filetype = "projects",
				}

				if not ts_parsers.has_parser("projects") then
					vim.cmd("TSInstallSync projects")
				end
			end,
		},
	},
})
