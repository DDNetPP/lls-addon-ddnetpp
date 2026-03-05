---@meta

---@class Game
Game = {}

---Sends a server chat message to everyone.
---@param message string
function Game:send_chat(message) end

---Returns the player instance or nil if no player with that id is connected.
---The client id is the same client id that is shown in the ddnet and teeworlds clients.
---@param client_id integer the client id of the player to find
---@return Player|nil player
function Game:get_player(client_id) end
