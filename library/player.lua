---@meta

---@class Player
local Player = {}

---@return integer client_id
function Player:id() end

---Returns the in game name of that player
---@return string name
function Player:name() end

---Update a players looks by changing the skin of the tee.
---When setting color_body or color_feet make sure to also set use_custom_color to true
---@param skin_info SkinInfo # Skin details, all fields are optional. Only updates the provided fields.
---@param priority? integer # Lower priorities will not override higher priorities, default value is ddnetpp.skin_priority.HIGH
function Player:set_skin(skin_info, priority) end

---Remove a previously set skin info.
---When a skin info is set with set_skin() it will stay set until it is unset using this method.
---By default it sets and unsets with priority HIGH. If you unset a previously set skin at HIGH
---it will fallback to priority USER and show again the skin that was originally requested by the client.
---@param skin_info SkinInfo # Skin details, all fields are optional. Only updates the provided fields.
---@param priority? integer # Only clears the skin at this priority, default value is ddnetpp.skin_priority.HIGH
function Player:unset_skin(skin_info, priority) end
