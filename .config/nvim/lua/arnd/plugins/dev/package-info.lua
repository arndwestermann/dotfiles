return {
	"vuki656/package-info.nvim",
	dependencies = { "MunifTanjim/nui.nvim" },
	ft = "json", -- only load for json buffers (package.json)
	config = function()
		require("package-info").setup({
			package_manager = "pnpm",
			hide_up_to_date = false,
			autostart = true,
		})

		local pi = require("package-info")
		local map = function(lhs, fn, desc)
			vim.keymap.set("n", lhs, fn, { silent = true, noremap = true, desc = desc })
		end
		map("<leader>ns", pi.show, "Package: show latest versions")
		map("<leader>nt", pi.toggle, "Package: toggle version annotations")
		map("<leader>nu", pi.update, "Package: update dep on line")
		map("<leader>nd", pi.delete, "Package: delete dep on line")
		map("<leader>ni", pi.install, "Package: install new dep")
		map("<leader>nc", pi.change_version, "Package: pick a version")
	end,
}
