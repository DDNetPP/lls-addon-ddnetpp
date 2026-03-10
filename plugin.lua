-- https://github.com/LuaLS/lua-language-server/issues/3369
-- Thanks to @tomlau10
--
-- This generates argument type hints based on the teeworlds/ddnet rcon command parameter text

--- @param uri string The URI of the file
--- @param text string The content of the file
--- @return nil | table[] A list of differences to be applied
function OnSetText(uri, text)
    local diffs = {}

    -- Pattern explanation:
    -- 1. Game:register_rcon(
    -- 2. Capture the format string (Group 1)
    -- 3. Move to the function definition
    -- 4. Capture the parameters inside "function(...)" (Group 2)
    -- 5. Get the cursor position at the end of the parameters (Group 3)
    local pattern = "ddnetpp.register_rcon%s*%(.-%s*,%s*\"(.-)\"%s*,.-,%s*function%s*%((.-)%)()"

    for rcon_format, params_list, func_body_start in text:gmatch(pattern) do
        -- Extract the 2nd parameter name from the callback function
        -- Matches: first_param, second_param
        local second_param = params_list:match("%s*[^,%s]+%s*,%s*([^,%s]+)")

        -- Only proceed if the 2nd parameter exists
        if second_param then
            local fields = {}
            local type_map = {
                i = "integer",
                s = "string",
                f = "number",
                b = "boolean"
            }

            -- Parse the format string, e.g., "i[client_id]s[name]"
            for type_char, field_name in rcon_format:gmatch("([isfb])%[(.-)%]") do
                local lua_type = type_map[type_char] or "any"
                table.insert(fields, string.format("%s: %s", field_name, lua_type))
            end

            if #fields > 0 then
                -- Construct the @cast using the dynamic parameter name
                local cast_line = "\n        ---@cast " .. second_param .. " { " .. table.concat(fields, ", ") .. " }"

                table.insert(diffs, {
                    start  = func_body_start,
                    finish = func_body_start - 1,
                    text   = cast_line,
                })
            end
        end
    end

    return #diffs > 0 and diffs or nil
end
