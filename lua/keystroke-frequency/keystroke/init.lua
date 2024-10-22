local Frequency = require("keystroke-frequency.keystroke.frequency")

---@class Keystroke
---@field frequency table<string, integer>
---@field statistics KeyStorkeStatistics[]
local Keystroke = {}

Keystroke.frequency = Frequency

---@class KeyStorkeStatistics
---@field key string
---@field count integer
---@field percentage_of_total number
---@field percentage_of_none_input number

Keystroke.statistics = {}

---@param key string
function Keystroke:incfreq(key)
	if Keystroke.frequency[key] == nil then
		Keystroke.frequency[key] = 1
	else
		Keystroke.frequency[key] = Keystroke.frequency[key] + 1
	end
end

function Keystroke:calcstat()
	Keystroke.statistics = {}
	local keystroke_sum = 0

	for k, v in pairs(Keystroke.frequency) do
		keystroke_sum = keystroke_sum + v
		table.insert(Keystroke.statistics, { key = k, count = v })
	end

	table.sort(Keystroke.statistics, function(a, b)
		return a.count > b.count
	end)

	for _, stat in pairs(Keystroke.statistics) do
		stat.percentage_of_total = stat.count / keystroke_sum
		if stat.key ~= "char" then
			stat.percentage_of_none_input = stat.count / (keystroke_sum - Keystroke.frequency["char"])
		end
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
			Keystroke.frequency[tostring(k)] = tonumber(v)
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
---@return string
function Keystroke:export()
	Keystroke:calcstat()

	local output = {
		"| Rank | Command | Count | % of Total | % of None Data Entry |",
		"| ---: | ------: | ----: | ---------: | -------------------: |",
	}
	for rank, stat in pairs(Keystroke.statistics) do
		local currrow = {
			"| ",
			tostring(rank),
			" | ",
			stat.key == "char" and "insert char" or stat.key,
			" | ",
			tostring(stat.count),
			" | ",
			string.format("%.2f", stat.percentage_of_total * 100),
			" | ",
			stat.percentage_of_none_input == nil and "N/A"
				or string.format("%.2f", stat.percentage_of_none_input * 100),
			" |",
		}
		table.insert(output, table.concat(currrow))
	end

	vim.fn.mkdir(vim.fn.stdpath("cache") .. "/keystroke-frequency", "p")
	local output_path = vim.fn.stdpath("cache")
		.. "/keystroke-frequency/output_"
		.. os.date("%Y-%m-%d_%H:%M:%S")
		.. ".md"
	local output_file = io.open(output_path, "w")
	if output_file == nil then
		return ""
	end
	output_file:write(table.concat(output, "\n"))
	output_file:close()
	return output_path
end

---@param filepath string
function Keystroke:preview_export_file(filepath)
	vim.cmd("e" .. filepath)
	local buf = vim.api.nvim_get_current_buf()
	vim.api.nvim_set_option_value("readonly", true, { buf = buf })
	vim.api.nvim_set_option_value("modified", false, { buf = buf })
end

return Keystroke
