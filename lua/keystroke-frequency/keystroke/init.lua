local Frequency = require("keystroke-frequency.keystroke.frequency")

---@class Keystroke
---@field frequency table<string, integer>
local Keystroke = {}

Keystroke.frequency = Frequency

---@param key string
function Keystroke:incfreq(key)
	if Keystroke.frequency[key] == nil then
		Keystroke.frequency[key] = 1
	else
		Keystroke.frequency[key] = Keystroke.frequency[key] + 1
	end
end

-- Load keystroke frequency from file
function Keystroke:load()
	local state_path = vim.fn.stdpath("state")
	local file = io.open(state_path .. "/keystroke-frequency.log", "r+")
	if file == nil then
		return
	end
	for line in file:lines("*l") do
		if type(line) ~= "string" then
			goto continue
		end
		local k, v = string.match(line, "(%w+)=(%d+)")
		if k and v then
			Keystroke.frequency[k] = tonumber(v)
		end
		::continue::
	end
end

-- Save keystroke frequency to file
function Keystroke:save()
	local state_path = vim.fn.stdpath("state")
	local file = io.open(state_path .. "/keystroke-frequency.log", "w+")
	if file == nil then
		return
	end
	local str = ""
	for k, v in pairs(Keystroke.frequency) do
		str = str .. string.format("%s=%d\n", k, v)
	end
	file:write(str)
	file:close()
end

-- Export keystroke frequency with additional statistics
-- TODO: Implement this
function Keystroke:export() end

return Keystroke
