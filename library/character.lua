---@meta

---@class Character
local Character = {}

---@return Position pos # The floating point position of a tee in the world
function Character:pos() end

---@return integer client_id # Same as id() on the player instance
function Character:id() end

---@return Player player # The player instance
function Character:player() end

---Be careful to not use the character instance after calling this.
---It does invalidate it.
---@param killer? ClientId # Client id of the killer, by default this is the id of the character that will die
---@param weapon? integer # Can be any of the ddnetpp.weapon.* constants, by default ddnetpp.weapon.GAME
function Character:die(killer, weapon) end
