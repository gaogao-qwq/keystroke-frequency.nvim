local Keystroke = require("keystroke-frequency.keystroke")

local M = {}

function M.setup()
	local augroup = vim.api.nvim_create_augroup("KeystrokeFrequency", { clear = true })

	vim.api.nvim_create_autocmd("VimEnter", {
		group = augroup,
		once = true,
		callback = function()
			Keystroke:load()
			local ns = vim.api.nvim_create_namespace("showcmd_msg")
			---@diagnostic disable-next-line: redundant-parameter
			vim.ui_attach(ns, { ext_messages = true }, function(event, ...)
				if event == "msg_showcmd" then
					local content = ...
					local mode = vim.api.nvim_get_mode().mode
					local visual_modes = { "v", "vs", "V", "Vs", "\22", "\22s" }
					local showcmd_msg = #content > 0 and content[1][2] or ""

					for _, visual_mode in ipairs(visual_modes) do
						if mode == visual_mode then
							return
						end
					end

					if showcmd_msg:len() == 0 then
						return
					end

					Keystroke:incfreq(showcmd_msg)
				end
			end)
		end,
	})

	vim.api.nvim_create_autocmd("UILeave", {
		group = augroup,
		once = true,
		callback = function()
			Keystroke:save()
		end,
	})
end

return M
