return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	build = ":TSUpdate", -- This replaces the `run` field
	config = function()
		local parser_install_dir = vim.fn.stdpath("data") .. "/site"
		vim.opt.runtimepath:prepend(parser_install_dir)

		require("nvim-treesitter.configs").setup({
			parser_install_dir = parser_install_dir,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "gnn",
					node_incremental = "grn",
					scope_incremental = "grc",
					node_decremental = "grm",
				},
			},
			indent = {
				enable = true,
			},
			ensure_installed = {
				"bash",
				"c",
				"lua",
				"python",
			},
			sync_install = false,
			auto_install = true,
		})
	end,
}
