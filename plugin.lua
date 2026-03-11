-- https://github.com/LuaLS/lua-language-server/issues/3369
-- Thanks to @tomlau10
--
-- This generates argument type hints based on the teeworlds/ddnet rcon command parameter text

local extract_params = require("src/plugin_parser").extract_params

--- @param uri string The URI of the file
--- @param text string The content of the file
--- @return nil | table[] A list of differences to be applied
function OnSetText(uri, text)
    return extract_params(text)
end
