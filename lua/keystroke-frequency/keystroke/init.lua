local Keystroke = {}

---@type table<string, integer>
local currcnt = {}

-- increse count of given key
---@param key string
function Keystroke:inccnt(key)
	if currcnt[key] == nil then
		currcnt[key] = 1
	else
		currcnt[key] = currcnt[key] + 1
	end
end

---@class KeyStorkeStatistics
---@field key string
---@field count integer
---@field percentage_of_total number
---@field percentage_of_none_input number

-- calculate statistics
---@return KeyStorkeStatistics[]
function Keystroke:calcstat()
	local statistics = {}
	local sum = 0
	local mergecnt = Keystroke:load()

	-- merge frequency table with current count
	for k, v in pairs(currcnt) do
		mergecnt[k] = (mergecnt[k] or 0) + v
	end

	for k, v in pairs(mergecnt) do
		sum = sum + mergecnt[k]
		table.insert(statistics, { key = k, count = v })
	end

	table.sort(statistics, function(a, b)
		return a.count > b.count
	end)

	for _, stat in ipairs(statistics) do
		stat.percentage_of_total = stat.count / sum
		if stat.key ~= "char" then
			stat.percentage_of_none_input = stat.count / (sum - mergecnt["char"])
		end
	end
	return statistics
end

-- Load keystroke count from file
---@return table<string, integer>
function Keystroke:load()
	local tbl = {}
	local state_path = vim.fn.stdpath("state")
	local file = io.open(state_path .. "/keystroke-frequency.log", "r+")

	if file == nil then
		return tbl
	end

	for line in file:lines("*l") do
		if type(line) ~= "string" then
			goto continue
		end
		local k, v = string.match(line, "(%w+)=(%d+)")
		if k and v then
			tbl[tostring(k)] = tonumber(v)
		end
		::continue::
	end

	file:close()
	return tbl
end

-- Save keystroke count to file
function Keystroke:save()
	local tbl = Keystroke:load()
	local state_path = vim.fn.stdpath("state")
	local file = io.open(state_path .. "/keystroke-frequency.log", "w+")

	if file == nil then
		return
	end

	-- merge frequency table with current count
	for k, v in pairs(currcnt) do
		tbl[k] = (tbl[k] or 0) + v
	end
	currcnt = {}

	local strtbl = {}
	for k, v in pairs(tbl) do
		table.insert(strtbl, string.format("%s=%d", k, v))
	end

	file:write(table.concat(strtbl, "\n"))
	file:close()
end

-- Export keystroke frequency statistics
---@return string filepath
function Keystroke:export()
	local statistics = Keystroke:calcstat()

	local output = {
		"| Rank | Command | Count | % of Total | % of None Data Entry |",
		"| ---: | ------: | ----: | ---------: | -------------------: |",
	}
	for rank, stat in ipairs(statistics) do
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
	vim.cmd("e " .. filepath)
	local buf = vim.api.nvim_get_current_buf()
	vim.api.nvim_set_option_value("readonly", true, { buf = buf })
	vim.api.nvim_set_option_value("modified", false, { buf = buf })
end

return Keystroke
