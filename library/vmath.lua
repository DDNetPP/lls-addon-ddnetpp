---@meta

---@class Position
---@field x number
---@field y number

---@class Velocity
---@field x number
---@field y number

---@class OptionalVelocity
---@field x? number
---@field y? number

---@class Vec2
---@field x number
---@field y number

---@class ddnetpp.Math
local math = {}

---@param vec Vec2|Velocity|Position
---@return Vec2 # normalized vector with x and y in range from 0 to 1
function math.normalize(vec) end

