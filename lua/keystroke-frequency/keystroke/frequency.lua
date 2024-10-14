---@type table<string, integer>
local keyfreq = {}

return setmetatable(keyfreq, {
	__index = function(_, _)
		return 0
	end,
})
