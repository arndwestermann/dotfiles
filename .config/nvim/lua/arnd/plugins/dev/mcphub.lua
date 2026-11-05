return {
	"ravitemer/mcphub.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	lazy = false, -- important for LazyVim!
	build = "npm install -g mcp-hub@latest",
	config = function()
		require("mcphub").setup()
	end,
}
