---@meta

---@class Server
local server = {}

---@return integer tick # The current server tick
function server.tick() end

---@return integer tick_speed # The server tick speed, how many ticks happen per second
function server.tick_speed() end

---Same as player:name() gets the display name of a player.
---If the player is not connected you might get "(connecting)" or "(invalid)"
---@param client_id ClientId
---@return string
function server.client_name(client_id) end

---@param client_id integer
---@return boolean success
function server.occupy_client_id(client_id) end

---@param client_id integer
---@return boolean success
function server.free_occupied_client_id(client_id) end
