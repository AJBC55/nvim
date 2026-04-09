return {
    { "hrsh7th/nvim-cmp",                    event = "InsertEnter" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "folke/neodev.nvim",                   opts = {} },
    { "antosha417/nvim-lsp-file-operations", config = true },

    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "folke/neodev.nvim",
        },

        config = function()
            local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

            pcall(function()
                require("neodev").setup({
                    library = { enabled = true, runtime = true, types = true, plugins = true },
                })
            end)

            -------------------------------------------------------------------------
            -- 🧠 Diagnostics
            -------------------------------------------------------------------------

            vim.diagnostic.config({
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = " ",
                        [vim.diagnostic.severity.WARN] = " ",
                        [vim.diagnostic.severity.HINT] = "󰠠 ",
                        [vim.diagnostic.severity.INFO] = " ",
                    },
                },
                virtual_text = { spacing = 1, prefix = "●" },
                underline = true,
                update_in_insert = false,
                severity_sort = true,
                float = { border = "rounded", source = "if_many" },
            })

            local publish_diagnostics = vim.lsp.handlers["textDocument/publishDiagnostics"]
            local pending_diagnostics = {}

            vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
                if err or not result or not result.uri then
                    return publish_diagnostics(err, result, ctx, config)
                end

                local bufnr = vim.uri_to_bufnr(result.uri)
                local mode = vim.api.nvim_get_mode().mode
                local current_buf = vim.api.nvim_get_current_buf()
                local key = string.format("%s:%s", ctx.client_id, bufnr)

                if mode:match("i") and bufnr == current_buf then
                    pending_diagnostics[key] = {
                        err = err,
                        result = result,
                        ctx = ctx,
                        config = config,
                    }
                    return
                end

                pending_diagnostics[key] = nil
                return publish_diagnostics(err, result, ctx, config)
            end

            vim.api.nvim_create_autocmd("InsertLeave", {
                group = vim.api.nvim_create_augroup("FlushInsertDiagnostics", { clear = true }),
                callback = function(args)
                    for key, pending in pairs(pending_diagnostics) do
                        local pending_bufnr = vim.uri_to_bufnr(pending.result.uri)
                        if pending_bufnr == args.buf then
                            pending_diagnostics[key] = nil
                            publish_diagnostics(pending.err, pending.result, pending.ctx, pending.config)
                        end
                    end
                end,
            })

            -------------------------------------------------------------------------
            -- ⚙️ Capabilities (for nvim-cmp)
            -------------------------------------------------------------------------
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            if ok_cmp and cmp_nvim_lsp and cmp_nvim_lsp.default_capabilities then
                capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
            end

            -------------------------------------------------------------------------
            -- 🧱 LSP servers
            -------------------------------------------------------------------------
            local servers = { "clangd" }

            -------------------------------------------------------------------------
            -- 🧩 New Neovim 0.11+ server configuration
            -- Instead of: require("lspconfig")[name].setup(opts)
            -- Use: vim.lsp.config(name, opts) + vim.lsp.enable(name)
            -------------------------------------------------------------------------
            local function default_setup(name, extra)
                local opts = { capabilities = capabilities }
                if extra then
                    for k, v in pairs(extra) do
                        opts[k] = v
                    end
                end

                vim.lsp.config(name, opts)
                vim.lsp.enable(name)
            end

            local handlers = {}

            handlers["lua_ls"] = function()
                default_setup("lua_ls", {
                    settings = {
                        Lua = {
                            diagnostics = { globals = { "vim" } },
                            completion = { callSnippet = "Replace" },
                            workspace = {
                                library = vim.api.nvim_get_runtime_file("", true),
                                checkThirdParty = false,
                            },
                            telemetry = { enable = false },
                        },
                    },
                })
            end



            handlers["clangd"] = function()
                default_setup("clangd", {
                    cmd = {
                        "clangd",
                        "--background-index",
                        "--clang-tidy",
                        "--completion-style=detailed",
                        "--fallback-style=Google",
                    },
                })
            end

            -- Configure the servers this config owns.
            for _, name in ipairs(servers) do
                if handlers[name] then
                    handlers[name]()
                else
                    default_setup(name)
                end
            end
        end,
    },
}
