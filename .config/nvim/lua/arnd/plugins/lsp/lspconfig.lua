return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		-- import lspconfig plugin
		local lspconfig = require("lspconfig")

		-- import cmp-nvim-lsp plugin
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local keymap = vim.keymap -- for conciseness

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf, silent = true }

				-- set keybinds
				opts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
			end,
		})

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		vim.diagnostic.config({
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.HINT] = "󰠠 ",
					[vim.diagnostic.severity.INFO] = " ",
				},
			},
		})

		--- Specialized root pattern that allows for an exclusion
		--- Kudos to https://www.npbee.me/posts/deno-and-typescript-in-a-monorepo-neovim-lsp
		--- @param opt {root: string[], exclude: string[]}
		--- @return  fun(file_name: string): string | nil
		local function root_pattern_exclude(opt)
			local lsputil = require("lspconfig.util")

			return function(fname)
				local excluded_root = lsputil.root_pattern(opt.exclude)(fname)
				local included_root = lsputil.root_pattern(opt.root)(fname)

				if excluded_root then
					return nil
				else
					return included_root
				end
			end
		end

		vim.lsp.config("*", {
			capabilities = capabilities,
		})

		-- vim.lsp.config("graphql", {
		-- 	filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
		-- })
		--
		-- vim.lsp.config("emmet_ls", {
		-- 	filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less" },
		-- })

		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					-- make the language server recognize "vim" global
					diagnostics = {
						globals = { "vim" },
					},
					completion = {
						callSnippet = "Replace",
					},
				},
			},
		})
		vim.lsp.enable("lua_ls")

		vim.lsp.config("ts_ls", {
			-- NOTE: To work with deno uncomment this
			-- root_dir = root_pattern_exclude({
			-- 	root = { "package.json", "angular.json", "nx.json" },
			-- 	exclude = { "deno.json", "deno.jsonc" },
			-- }),
			workspace_required = true,
			single_file_support = false,
		})
		vim.lsp.enable("ts_ls")

		vim.lsp.config("angularls", {
			-- NOTE: To work with deno uncomment this
			-- root_dir = lspconfig.util.root_pattern("angular.json", "nx.json"),
			-- root_dir = root_pattern_exclude({
			-- 	root = { "angular.json", "nx.json" },
			-- 	exclude = { "deno.json", "deno.jsonc" },
			-- }),
			filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx", "htmlangular" },
			root_markers = { "angular.json", "nx.json" },
		})
		vim.lsp.enable("angularls")

		vim.lsp.config("denols", {
			-- root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc", "deno.lock"),
			root_markers = { "deno.json" },
			workspace_required = true,
			settings = {
				deno = {
					enable = true,
					lint = true,
					suggest = {
						imports = {
							hosts = {
								["https://deno.land"] = true,
							},
						},
					},
				},
			},
		})
		vim.lsp.enable("denols")

		vim.lsp.enable("emmet_ls")

		-- mason_lspconfig.setup_handlers({
		-- 	-- default handler for installed servers
		-- 	function(server_name)
		-- 		lspconfig[server_name].setup({
		-- 			capabilities = capabilities,
		-- 		})
		-- 	end,
		-- 	["ts_ls"] = function()
		-- 		-- configure tsserver language server
		-- 		lspconfig["ts_ls"].setup({
		-- 			root_dir = root_pattern_exclude({
		-- 				root = { "package.json" },
		-- 				exclude = { "deno.json", "deno.jsonc" },
		-- 			}),
		-- 			single_file_support = false,
		-- 		})
		-- 	end,
		-- 	["angularls"] = function()
		-- 		-- configure denols language server
		-- 		lspconfig["angularls"].setup({
		-- 			root_dir = lspconfig.util.root_pattern("angular.json", "project.json"),
		-- 		})
		-- 	end,
		-- 	["denols"] = function()
		-- 		-- configure denols language server
		-- 		lspconfig["denols"].setup({
		-- 			root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc", "deno.lock"),
		-- 			init_options = {
		-- 				lint = true,
		-- 				suggest = {
		-- 					imports = {
		-- 						hosts = {
		-- 							["https://deno.land"] = true,
		-- 						},
		-- 					},
		-- 				},
		-- 			},
		-- 		})
		-- 	end,
		-- })
	end,
}
