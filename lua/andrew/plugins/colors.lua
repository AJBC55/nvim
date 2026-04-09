return {
	"Mofiqul/vscode.nvim",
	priority = 1000, -- Set high priority to ensure it loads before others
	config = function()
		vim.cmd("colorscheme vscode")

		-- Optional customizations
		vim.g.vscode_style = "dark" -- Set to "dark" or "light"
		vim.g.vscode_transparent = 1 -- Set to 1 for transparent background
		vim.g.vscode_italic_comment = 1 -- Enable italic comments
		vim.g.vscode_disable_nvimtree_bg = true -- Disable NvimTree background color
	end,
}
