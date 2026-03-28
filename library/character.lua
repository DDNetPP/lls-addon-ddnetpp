---@meta

---@class Character
local Character = {}

---Counter part to :set_position()
---@return Position pos # The floating point position of a tee in the world
function Character:pos() end

---Counter part to :pos()
---@param pos Position # Teleport the current tee to that new position instantly without killing them
function Character:set_position(pos) end

---Counter part to :pos()
---@param x integer|number # Teleport target x coordinate
---@param y integer|number # Teleport target x coordinate
function Character:set_position(x, y) end

---@return integer client_id # Same as id() on the player instance
function Character:id() end

---@return Player player # The player instance
function Character:player() end

---Be careful to not use the character instance after calling this.
---It does invalidate it.
---@param killer? ClientId # Client id of the killer, by default this is the id of the character that will die
---@param weapon? integer # Can be any of the ddnetpp.weapon.* constants, by default ddnetpp.weapon.GAME
function Character:die(killer, weapon) end

---@param weapon integer # See ddnetpp.weapon.* constants for possible values
---@param ammo? integer # The vanilla range is 0-10 and the negative value -1 means infinite ammo which is the default
function Character:give_weapon(weapon, ammo) end

---@param weapon integer # See ddnetpp.weapon.* constants for possible values
function Character:remove_weapon(weapon) end

---@class SetCharacterInput
---@field direction? integer
---@field target_x? integer
---@field target_y? integer
---@field jump? integer
---@field fire? integer
---@field hook? integer
---@field player_flags? integer
---@field wanted_weapon? integer
---@field next_weapon? integer
---@field prev_weapon? integer

---This will only work if set within the ddnetpp.on_character_pre_tick() hook
---@param input SetCharacterInput
function Character:set_input(input) end

---Check if the tee is currently frozen.
---Is true while in a freeze tile or deep frozen or regular frozen
---even when not currently in a freeze tile
---@return boolean frozen # True if this tee is currently frozen
function Character:is_frozen() end
