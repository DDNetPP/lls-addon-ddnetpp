local tw_console = require("luluworlds.params")

---@param params_text string # teeworlds params like "i[client_id]"
---@return nil|string comment # LuaCATS annotations for the params table
local function params_to_class(params_text)
	local type_map = {
		s = "string",
		r = "string",
		i = "integer",
	}
	local err, params = tw_console.parse_params(params_text)
	if err ~= nil then
		-- would be nice to show it as diagnostic but it doesnt seem possible
		-- error(err)
		return nil
	end
	local res = "---@class Args"
	for _, param in ipairs(params) do
		res =
			res .. "\n---@field " ..
			param.name .. " " ..
			type_map[param.type]
	end
	return res
end

---@param params_text string # teeworlds params like "i[client_id]"
---@return nil|string comment # LuaCATS annotations for the params table
local function params_to_cast(params_text)
	local type_map = {
		s = "string",
		r = "string",
		i = "integer",
	}
	local err, params = tw_console.parse_params(params_text)
	if err ~= nil then
		-- would be nice to show it as diagnostic but it doesnt seem possible
		-- error(err)
		return nil
	end
	local res = "---@cast args {"
	for i, param in ipairs(params) do
		if param.name == false then
			-- TODO: handle unnamed parameters better
			--       and cast it to an array with integer indices
		else
			if i ~= 1 then
				res = res .. ","
			end
			res =
				res .. " " ..
				param.name .. ": " ..
				type_map[param.type]
		end
	end
	res = res .. " }"
	return res
end

return {
	params_to_class = params_to_class,
	params_to_cast = params_to_cast
}
