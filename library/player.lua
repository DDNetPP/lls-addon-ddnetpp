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

---Mark player as afk.
---Will add the sleepy zZZ emote above their head
---tilt their feet and close their eyes
---also some logic might be skipped for afk players
---such as being removed from the required votes counter
---the ddnet server also sets the afk state when a player
---did not send inputs for some time
---@param afk boolean
function Player:set_afk(afk) end

---See Player:set_afk() for more context what afk means.
---@return boolean afk
function Player:is_afk() end

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
