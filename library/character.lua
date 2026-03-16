---@meta

---@class Character
local Character = {}

---@return Position pos # The floating point position of a tee in the world
function Character:pos() end

---@return integer client_id # Same as id() on the player instance
function Character:id() end

---@return Player player # The player instance
function Character:player() end
