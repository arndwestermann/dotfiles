return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
	},
	config = function()
		local dap, dapui = require("dap"), require("dapui")

		dapui.setup()

		dap.adapters["pwa-chrome"] = {
			type = "server",
			host = "localhost",
			port = "${port}",
			executable = {
				command = "node",
				args = {
					vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
					"${port}",
				},
			},
		}

		-- for _, lang in ipairs({
		-- 	"typescript",
		-- 	"javascript",
		-- }) do
		-- 	dap.configurations[lang] = dap.configurations[lang] or {}
		-- 	table.insert(dap.configurations[lang], {
		-- 		type = "chrome",
		-- 		request = "launch",
		-- 		name = "Launch chrome",
		-- 		url = "http://localhost:4200",
		-- 		sourcehMaps = true,
		-- 	})
		-- end

		-- dap.listeners.before.attach.dapui_config = function()
		-- 	dapui.open()
		-- end
		-- dap.listeners.before.launch.dapui_config = function()
		-- 	dapui.open()
		-- end
		-- dap.listeners.before.event_terminated.dapui_config = function()
		-- 	dapui.close()
		-- end
		-- dap.listeners.before.event_exited.dapui_config = function()
		-- 	dapui.close()
		-- end

		vim.keymap.set("n", "<Leader>dt", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
		vim.keymap.set("n", "<Leader>dl", dap.continue, { desc = "Continue debugging" })
		vim.keymap.set("n", "<Leader>do", function()
			dapui.open({ height = 10 })
		end, { desc = "Open UI" })
		vim.keymap.set("n", "<Leader>dc", dapui.close, { desc = "Close UI" })
		vim.keymap.set("n", "<Leader>dro", function()
			dap.repl.toggle({ height = 10 })
		end, { desc = "Open/Close REPL" })
	end,
}
