return {
	"kdheepak/lazygit.nvim",
	cmd = {
		"LazyGit",
		"LazyGitConfig",
		"LazyGitCurrentFile",
		"LazyGitFilter",
		"LazyGitFilterCurrentFile",
	},
	-- optional for floating window border decoration
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	init = function()
		-- Called by lazygit's os.edit (see ~/.config/lazygit/config.yml).
		-- Quit lazygit, then open the file once its float is gone. The timing
		-- matters: lazygit.nvim's on_exit closes the float and deletes the
		-- terminal buffer, so opening any earlier (on TermClose, or by chaining
		-- onto the shell command) lands the file in the float, which is then
		-- thrown away. lazygit_on_exit_callback runs last, after the float is
		-- closed and the previous window restored.
		function _G.lazygit_edit(file, line)
			local buf = vim.api.nvim_get_current_buf()
			local job = vim.b[buf].terminal_job_id
			local function open()
				vim.cmd("edit " .. vim.fn.fnameescape(file))
				local l = tonumber(line)
				if l and l > 0 then
					pcall(vim.api.nvim_win_set_cursor, 0, { l, 0 })
				end
			end
			if not job then
				open()
				return ""
			end
			vim.g.lazygit_on_exit_callback = function()
				vim.g.lazygit_on_exit_callback = nil
				vim.schedule(open)
			end
			vim.fn.chansend(job, "q")
			return ""
		end

		-- Called by a lazygit custom command (see ~/.config/lazygit/config.yml,
		-- <ctrl+v> in the files context). Same quit-then-open dance as
		-- lazygit_edit, but hands the selected file to diffview.nvim instead of
		-- a plain buffer, giving the big side-by-side review + gitsigns
		-- line-level revert. Path is repo-root-relative from lazygit; it opens
		-- correctly as long as nvim's cwd is the repo root. Pass no file to
		-- review the whole working tree.
		function _G.lazygit_diffview(file)
			local buf = vim.api.nvim_get_current_buf()
			local job = vim.b[buf].terminal_job_id
			local function open()
				if file and file ~= "" then
					vim.cmd("DiffviewOpen -- " .. vim.fn.fnameescape(file))
				else
					vim.cmd("DiffviewOpen")
				end
			end
			if not job then
				open()
				return ""
			end
			vim.g.lazygit_on_exit_callback = function()
				vim.g.lazygit_on_exit_callback = nil
				vim.schedule(open)
			end
			vim.fn.chansend(job, "q")
			return ""
		end
	end,
	keys = {
		{ "<leader>lg", "<cmd>LazyGit<cr>", desc = "Open lazy git" },
	},
}
