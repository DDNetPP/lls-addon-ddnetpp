---@meta

---@class Player
local Player = {}

---@return integer client_id
function Player:id() end

---Returns the in game name of that player
---@return string name
function Player:name() end

---Add amount of money to the current balance of this player.
---This is using the ddnet++ currency. The amount will be saved in the players
---account if the player is logged in.
---The transaction will show up in the /money chat command.
---@param amount integer # Positive or negative amount of money that will be added to the players balance
---@param description string # Context of what caused the transaction without the amount such as "bought item xyz"
function Player:money_transaction(amount, description) end

---Get the current money balance of this player
---@return integer money
function Player:money() end

---Update a players looks by changing the skin of the tee.
---When setting color_body or color_feet make sure to also set use_custom_color to true
---@param skin_info SkinInfo # Skin details, all fields are optional. Only updates the provided fields.
---@param priority? integer # Lower priorities will not override higher priorities, default value is ddnetpp.skin_priority.HIGH
function Player:set_skin(skin_info, priority) end

---Remove a previously set skin info.
---When a skin info is set with set_skin() it will stay set until it is unset using this method.
---By default it sets and unsets with priority HIGH. If you unset a previously set skin at HIGH
---it will fallback to priority USER and show again the skin that was originally requested by the client.
---@param priority? integer # Only clears the skin at this priority, default value is ddnetpp.skin_priority.HIGH
function Player:unset_skin(priority) end

---Remove a previously set skin info.
---When a skin info is set with set_skin() it will stay set until it is unset using this method.
---By default it sets and unsets with priority HIGH. If you unset a previously set skin at HIGH
---it will fallback to priority USER and show again the skin that was originally requested by the client.
---@param priority? integer # Only clears the skin at this priority, default value is ddnetpp.skin_priority.HIGH
function Player:unset_skin_color_body(priority) end
