---@meta

---@class ChatMessage
---@field message string the chat message payload
---@field team integer TEAM_ALL=-2, TEAM_SPECTATORS=-1, or a ddrace team

---@class ddnetpp
---
---A snapshot is the current state of the world
---here you can display all sorts of flexible entities
---such as weapons, picksups, projectiles and players
---@field snap Snapshot # Snapshot related methods
---
---@field server Server # The name server only makes sense if you know the C++ codebase :D
---
---@field protocol Protocol # Networl protocol constants
---
---Called once when the server starts or when plugins are being reloaded
---@field on_init fun()
---
---Gets called every tick
---@field on_tick fun()
---
---Gets called every tick for every connected player
---@field on_player_tick fun(player: Player)
---
---Gets called every time the server builds a new snapshot
---a snapshot is being built for every connected client idenpendently
---so the id of the client receiving the snapshot is passed as argument.
---This value can be -1 too when the server is recording demos.
---You can register your snap items in this method by using
---the `ddnetpp.snap.*` methods. For example:
---```lua
---function ddnetpp.on_snap()
---	chr = ddnetpp.get_character(0)
---	if chr then
---		pos = chr:pos()
---		ddnetpp.snap.new_laser({
---			id = -- allocate the id once with ddnetpp.snap.new_id() and then reuse it
---			x = pos.x,
---			y = pos.y - 2,
---			from_x = pos.x,
---			from_y = pos.y - 2,
---			start_tick = 0,
---		})
---	end
---end
---```
---@field on_snap fun(snapping_client_id: integer)
---
---@field on_player_connect fun(client_id: integer)
---@field on_player_disconnect fun(client_id: integer)
---
---The parameter msg contains msg.message and msg.team
---which are already filled with the information that would be displayed
---in the chat or used for a chat command.
---You can also override these fields to alter the chat message.
---You have to return the `msg` from the function!
---@field on_chat fun(client_id: integer, msg: ChatMessage): ChatMessage
---
---You can return false from this method to block the shot.
---@field on_fire_weapon fun(client_id: integer, weapon: integer, direction: Vec2, mouse_target: Vec2, projectile_start_pos: Position): false|nil
---
---The client_id is the client that will receive the message
---and data is the raw data that is being sent
---return true to drop the message and abort sending it.
---@field on_server_message fun(client_id: integer, data: string, flags: integer): boolean # Called for every network message the server sends. Return true to drop the message.
ddnetpp = {
	skin_priority = {
		-- the skin the client requested
		USER = 0,

		-- priority "low" should be used by the main color
		-- enforced by a gamemode that supports rainbow.
		-- it overwrites the user choice but gets overwritten by
		-- rainbow.
		-- Modes that use this are for example: zCatch
		LOW = 1,

		-- you should never write to this priority or you break rainbow
		RAINBOW = 2,

		-- priority "high" should be used by the main color
		-- enforced by a gamemode that does not support rainbow.
		-- It overwrites the user choice and rainbow.
		--
		-- Modes that use this are for example: bomb
		HIGH = 3,
	}
}

---Sends a server chat message to everyone.
---@param message string # The message to be displayed in chat
function ddnetpp.send_chat(message) end

---Sends a server chat message to one specific client.
---@param client_id integer # The recipient of the message
---@param message string # The message to be displayed in chat
function ddnetpp.send_chat_target(client_id, message) end

---Execute rcon command with admin level privileges.
---Semicolons are interpreted! So it is NOT SAFE to pass user input to this method.
---@param command string # Full rcon command line with multiple semicolon separated statements
function ddnetpp.rcon(command) end

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

---@param name string chat command name without the leading slash
---@param parameters string teeworlds console parameter types and names
---                         there are 3 supported types:
---                         - "i" integer
---                         - "s" string
---                         - "r" rest (as string)
---
---                         So for example the params "sss" means that the chat command
---                         takes 3 strings as parameters.
---                         And the params "ii" means it takes two integers.
---                         You can also name the params for example "s[name]i[seconds]"
---                         it will then pass a table to the callback in the args parameter
---                         with the keys "name" and "seconds" and the values will be a string and a integer.
---                         There are also optional parameters which are prefixed with a "?"
---                         So for example "s[name] ?i[seconds]"
---                         in that case the command will be executed if one or two arguments are provided
---                         by the user in the chat command.
---                         If non optional parameters were not provided as arguments by the user
---                         or more arguments were provided than parameters the callback will not be run
---                         and an error is shown to the user.
---@param helptext string a short description of the chat command will be shown in the console next to the completion
---@param callback fun(client_id: integer, args: table<string, string|integer|nil>) the callback that will be run if a user typed the command name into the remote console
function ddnetpp.register_chat(name, parameters, helptext, callback) end

---@return string name name of the currently running plugin
function ddnetpp.plugin_name() end
