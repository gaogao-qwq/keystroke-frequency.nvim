local Keystroke = require("keystroke-frequency.keystroke")

local M = {}

---@type table<string, fun()>
M.commands = {}

M.setup = function()
	M.commands = {
		stats = function()
			local filepath = Keystroke:export()
			if filepath:len() == 0 then
				return
			end
			Keystroke:preview_export_file(filepath)
		end,
	}

	for name, cb in pairs(M.commands) do
		local cmd = "KeyFreq" .. name:sub(1, 1):upper() .. name:sub(2)
		vim.api.nvim_create_user_command(cmd, function()
			cb()
		end, { desc = "KeyFreq" .. cmd })
	end
end

return M
