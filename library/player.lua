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
