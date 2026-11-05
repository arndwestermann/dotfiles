return {
	"olimorris/codecompanion.nvim",
	version = "^18.0.0",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"ravitemer/mcphub.nvim", -- mcphub must be a dependency here
	},
	opts = {
		adapters = {
			mistral = function()
				return require("codecompanion.adapters").extend("mistral", {
					schema = {
						model = {
							default = "mistral-large-latest", -- bump from tiny default
						},
					},
				})
			end,
		},
		strategies = {
			chat = { adapter = "mistral" },
			inline = { adapter = "mistral" },
		},
		extensions = {
			mcphub = {
				callback = "mcphub.extensions.codecompanion",
				opts = {
					make_tools = true,
					make_vars = true,
					make_slash_commands = true,
					show_result_in_chat = true,
				},
			},
		},
	},
	keys = {
		{ "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", desc = "AI Chat", mode = { "n", "v" } },
		{ "<leader>ai", "<cmd>CodeCompanion<cr>", desc = "AI Inline", mode = { "n", "v" } },
		{ "<leader>am", "<cmd>MCPHub<cr>", desc = "MCP Hub" },
	},
}
