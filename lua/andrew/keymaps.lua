-- set the leader key
vim.g.mapleader = " "
-- remap for saving a file
vim.keymap.set("n", "<leader>s", vim.cmd.w)
-- remap quitinqf
vim.keymap.set("n", "<leader>q", vim.cmd.wq)
-- go into the file finder
vim.keymap.set("n", "<leader>ee", vim.cmd.Ex)
-- chage entering insert mode to use ff
vim.keymap.set("i", "jj", "<Esc>")


-- kepmanps for lsp
-------------------------------------------------------------------------
-- 🔧 Keymaps when an LSP attaches
-------------------------------------------------------------------------
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
    callback = function(ev)
        local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, silent = true, desc = desc })
        end
        map("n", "<leader>gr", "<cmd>Telescope lsp_references<CR>", "References")
        map("n", "<leader>gd", vim.lsp.buf.definition, "Definition (jump)")
        map("n", "<leader>gi", "<cmd>Telescope lsp_implementations<CR>", "Implementations")
        map("n", "<leader>gt", "<cmd>Telescope lsp_type_definitions<CR>", "Type definitions")
        map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
        map("n", "K", vim.lsp.buf.hover, "Hover docs")
        map("n", "<leader>d", vim.diagnostic.open_float, "Show diagnostics popup (on demand)")
        map("n", "<leader>rs", "<cmd>LspRestart<CR>", "Restart LSP")
    end,
})



-- set keymaps for Telescope
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
vim.keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
vim.keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })






vim.keymap.set("n", "<leader>f", "<cmd>Format<cr>", { desc = "Formats code" })
