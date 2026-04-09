return {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local nvimtree = require("nvim-tree")

        -- recommended settings from nvim-tree documentation
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        nvimtree.setup({
            view = {
                width = 35,
                relativenumber = true,
            },
            -- change folder arrow icons
            renderer = {
                indent_markers = {
                    enable = true,
                },
                icons = {
                    glyphs = {
                        folder = {
                            arrow_closed = "", -- arrow when folder is closed
                            arrow_open = "", -- arrow when folder is open
                        },
                    },
                },
            },
            -- disable window_picker for
            -- explorer to work well with
            -- window splits
            actions = {
                open_file = {
                    window_picker = {
                        enable = false,
                    },
                },
            },
            filters = {
                custom = { ".DS_Store" },
            },
            git = {
                ignore = false,
            },
            on_attach = function(bufnr)
                local api = require("nvim-tree.api")

                -- set keymaps in the on_attach function
                local opts = { noremap = true, silent = true, buffer = bufnr }
                vim.keymap.set("n", "n", api.fs.create, opts)      -- Create a new file
                vim.keymap.set("n", "D", api.fs.remove, opts)      -- Delete a file/folder
                vim.keymap.set("n", "r", api.fs.rename, opts)      -- Rename a file/folder
                vim.keymap.set("n", "d", api.fs.create, opts)      -- Create a new folder (with `/` at the end)
                vim.keymap.set("n", "x", api.fs.cut, opts)         -- Cut a file/folder
                vim.keymap.set("n", "c", api.fs.copy.node, opts)   -- Copy a file/folder
                vim.keymap.set("n", "p", api.fs.paste, opts)       -- Paste a file/folder
                vim.keymap.set("n", "q", api.tree.close, opts)     -- Close the nvim-tree
                vim.keymap.set("n", "<CR>", api.node.open.edit, opts) -- Open a file/folder
                vim.keymap.set("n", "R", api.tree.reload, opts)    -- Refresh the tree
                vim.keymap.set("n", "u", api.tree.change_root_to_parent, opts) -- Go up a directory
            end,
        })

        -- set global keymaps
        local keymap = vim.keymap                                                                            -- for conciseness

        keymap.set("n", "<leader>vd", "<cmd>NvimTreeToggle<CR>", { silent = true, desc = "Toggle file explorer" }) -- toggle file explorer
        keymap.set(
            "n",
            "<leader>ee",
            "<cmd>NvimTreeFindFileToggle<CR>",
            { silent = true, nowait = true, desc = "Toggle file explorer on current file" }
        )                                                                                                        -- toggle file explorer on current file
        keymap.set("n", "<leader>vc", "<cmd>NvimTreeCollapse<CR>", { silent = true, desc = "Collapse file explorer" }) -- collapse file explorer
        keymap.set("n", "<leader>vr", "<cmd>NvimTreeRefresh<CR>", { silent = true, desc = "Refresh file explorer" }) -- refresh file explorer
    end,
}
