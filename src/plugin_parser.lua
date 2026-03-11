local params_to_cast = require("src/params_type").params_to_cast

local function extract_params(text)
	local pattern = "ddnetpp.register_rcon%s*%(.-%s*,%s*\"(.-)\"%s*,.-,%s*function%s*%((.-)%)()"

	local diffs = {}

	for rcon_params, callback_args, func_body_start in text:gmatch(pattern) do
		local cast_line = params_to_cast(rcon_params)
                table.insert(diffs, {
                    start  = func_body_start,
                    finish = func_body_start - 1,
                    text   = cast_line,
                })
	end
	return #diffs > 0 and diffs or nil
end

return {
	extract_params = extract_params
}
