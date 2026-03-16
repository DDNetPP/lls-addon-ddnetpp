---@meta

---@class Tile
---@field x integer # The x coordinate of the tile. Where 0 is the most left possible position.
---@field y integer # The y coordinate of the tile. Where 0 is the highest possible position.
---@field index integer # The type of tile. For example ddnetpp.tile.AIR
---@field flags integer # Bitwise flags like rotation

---@class Collision
local collision = {}

---@return integer width # The width of the current maps game layer in tiles
function collision.width() end

---@return integer height # The height of the current maps game layer in tiles
function collision.height() end

---Given the coordinates it will find the type of tile at that position in the map.
---The coordinate origin of 0,0 is the top left corner of the map.
---The maximum value for x and y are ddnetpp.collision.width() and ddnetpp.collision.height()
---See also `ddnetpp.collision.get_tile(pos)`
---@param x integer # The x coordinate to lookup. Where 0 is the most left tile and 1 is one to its right.
---@param y integer # The y coordinate to lookup. Where 0 is the highest tile and 1 is one below it.
---@return integer tile # The index of the found tile. See ddnetpp.tile.* for the possible values
function collision.get_tile_index(x, y) end

---See also `ddnetpp.collision.get_tile_index(x, y)`
---@param pos Position # Floating point or decimal position with x and y
---@return Tile tile # The full tile information at that position
function collision.get_tile(pos) end
