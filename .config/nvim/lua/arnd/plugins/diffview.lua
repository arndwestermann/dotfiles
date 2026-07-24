return {
	"sindrets/diffview.nvim",
	cmd = {
		"DiffviewOpen",
		"DiffviewClose",
		"DiffviewFileHistory",
		"DiffviewToggleFiles",
		"DiffviewFocusFiles",
	},
	keys = {
		{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview: open (working tree)" },
		{ "<leader>gc", "<cmd>DiffviewOpen develop...HEAD<cr>", desc = "Diffview: review branch vs develop" },
		{ "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Diffview: close" },
		{ "<leader>gb", "<cmd>DiffviewToggleFiles<cr>", desc = "Diffview: toggle file panel" },
		{ "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview: history of current file" },
		{ "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview: history of branch" },
	},
	opts = {
		enhanced_diff_hl = true,
	},
}
