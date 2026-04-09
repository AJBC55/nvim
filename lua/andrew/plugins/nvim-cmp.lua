return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-buffer", -- source for text in buffer
		"hrsh7th/cmp-path", -- source for file system paths
		{
			"L3MON4D3/LuaSnip",
			version = "v2.*", -- Use the latest major version
			build = "make install_jsregexp", -- Install jsregexp (optional)
		},
		"saadparwaiz1/cmp_luasnip", -- for autocompletion with snippets
		"rafamadriz/friendly-snippets", -- collection of snippets
		"onsails/lspkind.nvim", -- vs-code like pictograms for autocompletion
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local lspkind = require("lspkind")

		-- Load VSCode-style snippets from plugins like friendly-snippets
		require("luasnip.loaders.from_vscode").lazy_load()

		cmp.setup({
			completion = {
				completeopt = "menu,menuone,noselect", -- standard completion options
			},
			snippet = { -- configure how nvim-cmp interacts with the snippet engine
				expand = function(args)
					luasnip.lsp_expand(args.body) -- For `luasnip` users.
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
				["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
				["<C-b>"] = cmp.mapping.scroll_docs(-4), -- scroll up in documentation
				["<C-f>"] = cmp.mapping.scroll_docs(4), -- scroll down in documentation
				["<C-Space>"] = cmp.mapping.complete(), -- trigger completion
				["<C-e>"] = cmp.mapping.abort(), -- abort completion
				["<CR>"] = cmp.mapping.confirm({ select = false }), -- confirm selection
			}),
			-- sources for autocompletion
			sources = cmp.config.sources({
				{ name = "nvim_lsp" }, -- LSP completion
				{ name = "luasnip" }, -- snippet completion
				{ name = "buffer" }, -- text within current buffer
				{ name = "path" }, -- file system paths
			}),
			-- configure lspkind for vs-code like pictograms in completion menu
			formatting = {
				format = lspkind.cmp_format({
					maxwidth = 50, -- limit the width of the completion menu
					ellipsis_char = "...", -- display ellipsis for truncated items
				}),
			},

		})
	end,
}
