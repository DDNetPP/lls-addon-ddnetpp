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
