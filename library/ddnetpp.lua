---@meta

---@class ddnetpp
---
---Gets called every tick
---@field on_tick fun()
---
---Called once when the server starts or when plugins are being reloaded
---@field on_init fun()
---
---The client_id is the client that will receive the message
---and data is the raw data that is being sent
---return true to drop the message and abort sending it.
---@field on_server_message fun(client_id: integer, data: string, flags: integer): boolean # Called for every network message the server sends. Return true to drop the message.
ddnetpp = {}

---Sends a server chat message to everyone.
---@param message string
function ddnetpp.send_chat(message) end

---Returns the player instance or nil if no player with that id is connected.
---The client id is the same client id that is shown in the ddnet and teeworlds clients.
---
---Be careful! If you hold onto this instance across ticks it might become invalid.
---If you store the player instance in some global variable and use it after the
---player disconnected your plugin will crash!
---
---@param client_id integer the client id of the player to find
---@return Player|nil player
function ddnetpp.get_player(client_id) end

---Returns the character instance or nil if no player with that id is connected or the player is currently dead.
---The client id is the same client id that is shown in the ddnet and teeworlds clients.
---
---Be careful! If you hold onto this instance across ticks it might become invalid.
---If you store the character instance in some global variable and use it after the
---player disconnected or died your plugin will crash!
---
---@param client_id integer the client id of the character to find
---@return Character|nil character
function ddnetpp.get_character(client_id) end

---@param name string rcon command name
---@param parameters string teeworlds console parameter types and names
---                         there are 3 supported types:
---                         - "i" integer
---                         - "s" string
---                         - "r" rest (as string)
---
---                         So for example the params "sss" means that the rcon command
---                         takes 3 strings as parameters.
---                         And the params "ii" means it takes two integers.
---                         You can also name the params for example "s[name]i[seconds]"
---                         it will then pass a table to the callback in the args parameter
---                         with the keys "name" and "seconds" and the values will be a string and a integer.
---                         There are also optional parameters which are prefixed with a "?"
---                         So for example "s[name] ?i[seconds]"
---                         in that case the command will be executed if one or two arguments are provided
---                         by the user in the rcon command.
---                         If non optional parameters were not provided as arguments by the user
---                         or more arguments were provided than parameters the callback will not be run
---                         and an error is shown to the user.
---@param helptext string a short description of the rcon command will be shown in the console next to the completion
---@param callback fun(client_id: integer, args: table<string, string|integer|nil>) the callback that will be run if a user typed the command name into the remote console
function ddnetpp.register_rcon(name, parameters, helptext, callback) end

---@return string name name of the currently running plugin
function ddnetpp.plugin_name() end
