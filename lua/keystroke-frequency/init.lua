local Keystroke = require("keystroke-frequency.keystroke")
local Commands = require("keystroke-frequency.commands")

local M = {}

M.load = function()
	Commands.setup()
end

function M.setup()
	M.load()

	local ns_showcmd = vim.api.nvim_create_namespace("showcmd")
	local ns_onkey = vim.api.nvim_create_namespace("on_key")
	local augroup = vim.api.nvim_create_augroup("KeystrokeFrequency", { clear = true })
	local input_modes = { "i", "ic", "ix", "R", "Rc", "Rx", "Rv", "Rvc", "Rvx", "t" }
	local visual_modes = { "v", "vs", "V", "Vs", "\22", "\22s" }

	vim.api.nvim_create_autocmd("VimEnter", {
		group = augroup,
		once = true,
		callback = function()
			-- get showcmd message
			---@diagnostic disable-next-line: redundant-parameter
			vim.ui_attach(ns_showcmd, { ext_messages = true }, function(event, ...)
				if event == "msg_showcmd" then
					local content = ...
					local showcmd_msg = #content > 0 and content[1][2] or ""

					for _, vmode in ipairs(visual_modes) do
						if vim.api.nvim_get_mode().mode == vmode then
							return
						end
					end

					if showcmd_msg:len() == 0 then
						return
					end

					Keystroke:incfreq(showcmd_msg)
				end
			end)

			-- get keycode
			vim.on_key(function(key, _)
				for _, imode in ipairs(input_modes) do
					if vim.api.nvim_get_mode().mode == imode then
						if key:len() == 1 or #vim.str_utf_pos(key) == 1 then
							Keystroke:incfreq("char")
						end
						break
					end
				end
			end, ns_onkey)
		end,
	})

	vim.api.nvim_create_autocmd("UILeave", {
		group = augroup,
		once = true,
		callback = function()
			vim.ui_detach(ns_showcmd)
			Keystroke:save()
		end,
	})
end

return M
