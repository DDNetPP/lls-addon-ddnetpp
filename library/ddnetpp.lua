---@meta

---@class ClientMask
---The keys are client id integers from 0 to 127
---all set keys are included in the mask
---all unset keys are ignored by the mask

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
---@field protocol Protocol # Network protocol constants
---
---@field collision Collision # Currently loaded map related methods
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
---Set inputs in this callback
---@field on_character_pre_tick fun(character: Character)
---
---Implement your own tiles here.
---Gets called for every alive character.
---If you want to know the position you can just do `character:pos()`
---The game_index is a tile index like ddnetpp.tile.SOLID from the main game layer
---and the front_index is the same from the ddrace front layer.
---@field on_character_tile fun(character: Character, game_index: integer, front_index: integer)
---
---Similar to ddnetpp.on_character_tile() but only gets called once when the character
---touched a new tile.
---@field on_character_game_tile_change fun(character: Character, game_index: integer)
---
---Return true from this method if the ddnet++ default behavior for this tile should
---be skipped. You can use this to disable or override existing tiles.
---Similar to on_character_tile() this gets called every tick.
---@field on_skip_game_tile fun(character: Character, game_index: integer): boolean
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
---@field on_snap_gameinfo_flags fun(snapping_client_id: integer, flags: integer): integer
---@field on_snap_gameinfo_flags2 fun(snapping_client_id: integer, flags: integer): integer
---
---The snap receiver client id is "snapping_client_id" which can be -1 for demos
---the character that is being snapped is "character" and the item that would be sent by ddnet++ by default
---gets passed as "snap_item". Whatever item you return will be included in the snapshot.
---@field on_snap_character fun(snapping_client_id: integer, character: Character, snap_item: SnapItemCharacter): SnapItemCharacter
---
---@field on_player_connect fun(client_id: integer)
---@field on_player_disconnect fun(client_id: integer)
---
---Gets called when a tee is about to spawn.
---There is no character instance yet because the tee is still dead.
---If you return a position {x=0,y=0} table it will use that as spawn position
---ignoring where it would otherwise spawn. If you return nil it will
---use the default spawn position.
---@field on_pick_spawn_pos fun(player: Player): Position|nil
---
---You can return false to drop the damage event. Which skips for example the weapon knockback.
---@field on_character_take_damage fun(character: Character, weapon: integer, from_id: integer, dmg: integer): boolean|nil
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
	},
	-- TODO: move this to mapitems.lua? and use @field tile Tiles or something like that
	tile = {
		AIR = 0,
		SOLID = 1,
		DEATH = 2,
		NOHOOK = 3,
		-- NOLASER = 4,
		-- THROUGH_CUT = 5,
		-- THROUGH = 6,
		-- JUMP = 7,
		FREEZE = 9,
		-- TELEINEVIL = 10,
		-- UNFREEZE = 11,
		-- DFREEZE = 12,
		-- DUNFREEZE = 13,
		-- TELEINWEAPON = 14,
		-- TELEINHOOK = 15,
		-- WALLJUMP = 16,
		-- EHOOK_ENABLE = 17,
		-- EHOOK_DISABLE = 18,
		-- HIT_ENABLE = 19,
		-- HIT_DISABLE = 20,
		-- SOLO_ENABLE = 21,
		-- SOLO_DISABLE = 22,
		-- SWITCHTIMEDOPEN = 22,
		-- SWITCHTIMEDCLOSE = 23,
		-- SWITCHOPEN = 24,
		-- SWITCHCLOSE = 25,
		-- TELEIN = 26,
		-- TELEOUT = 27,
		-- SPEED_BOOST_OLD = 28,
		-- SPEED_BOOST = 29,
		-- TELECHECK = 29,
		-- TELECHECKOUT = 30,
		-- TELECHECKIN = 31,
		-- REFILL_JUMPS = 32,
		-- START = 33,
		-- FINISH = 34,
		-- TIME_CHECKPOINT_FIRST = 35,
		-- TIME_CHECKPOINT_LAST = 59,
		-- STOP = 60,
		-- STOPS = 61,
		-- STOPA = 62,
		-- TELECHECKINEVIL = 63,
		-- CP = 64,
		-- CP_F = 65,
		-- THROUGH_ALL = 66,
		-- THROUGH_DIR = 67,
		-- TUNE = 68,
		-- OLDLASER = 71,
		-- NPC = 72,
		-- EHOOK = 73,
		-- NOHIT = 74,
		-- NPH = 75,
		-- UNLOCK_TEAM = 76,
		-- ADD_TIME = 79,
		-- NPC_DISABLE = 88,
		-- UNLIMITED_JUMPS_DISABLE = 89,
		-- JETPACK_DISABLE = 90,
		-- NPH_DISABLE = 91,
		-- SUBTRACT_TIME = 95,
		-- TELE_GUN_ENABLE = 96,
		-- TELE_GUN_DISABLE = 97,
		-- ALLOW_TELE_GUN = 98,
		-- ALLOW_BLUE_TELE_GUN = 99,
		-- NPC_ENABLE = 104,
		-- UNLIMITED_JUMPS_ENABLE = 105,
		-- JETPACK_ENABLE = 106,
		-- NPH_ENABLE = 107,
		-- TELE_GRENADE_ENABLE = 112,
		-- TELE_GRENADE_DISABLE = 113,
		-- TELE_LASER_ENABLE = 128,
		-- TELE_LASER_DISABLE = 129,
		-- CREDITS_1 = 140,
		-- CREDITS_2 = 141,
		-- CREDITS_3 = 142,
		-- CREDITS_4 = 143,
		-- LFREEZE = 144,
		-- LUNFREEZE = 145,
		-- CREDITS_5 = 156,
		-- CREDITS_6 = 157,
		-- CREDITS_7 = 158,
		-- CREDITS_8 = 159,
		-- ENTITIES_OFF_1 = 190,
		-- ENTITIES_OFF_2 = 191,
	},
	weapon = {
		GAME = -3,
		SELF = -2,
		WORLD = -1,
		NONE = -1,
		HAMMER = 0,
		GUN = 1,
		SHOTGUN = 2,
		GRENADE = 3,
		LASER = 4,
		NINJA = 5,
	},
	hook = {
		RETRACTED = -1,
		IDLE = 0,
		RETRACT_START = 1,
		RETRACT_END = 3,
		FLYING = 4,
		GRABBED = 5,
	},
	eye_emote = {
		NORMAL = 0,
		PAIN = 1,
	},
	team = {
		ALL = -2,
		SPECTATORS = -1,
		RED = 0,
		BLUE = 1,
		GAME = 0,
	},
	sound = {
		GUN_FIRE = 0,
		SHOTGUN_FIRE = 1,
		GRENADE_FIRE = 2,
		HAMMER_FIRE = 3,
		HAMMER_HIT = 4,
		NINJA_FIRE = 5,
		GRENADE_EXPLODE = 6,
		NINJA_HIT = 7,
		LASER_FIRE = 8,
		LASER_BOUNCE = 9,
		WEAPON_SWITCH = 10,
		PLAYER_PAIN_SHORT = 11,
		PLAYER_PAIN_LONG = 12,
		BODY_LAND = 13,
		PLAYER_AIRJUMP = 14,
		PLAYER_JUMP = 15,
		PLAYER_DIE = 16,
		PLAYER_SPAWN = 17,
		PLAYER_SKID = 18,
		TEE_CRY = 19,
		HOOK_LOOP = 20,
		HOOK_ATTACH_GROUND = 21,
		HOOK_ATTACH_PLAYER = 22,
		HOOK_NOATTACH = 23,
		PICKUP_HEALTH = 24,
		PICKUP_ARMOR = 25,
		PICKUP_GRENADE = 26,
		PICKUP_SHOTGUN = 27,
		PICKUP_NINJA = 28,
		WEAPON_SPAWN = 29,
		WEAPON_NOAMMO = 30,
		HIT = 31,
		CHAT_SERVER = 32,
		CHAT_CLIENT = 33,
		CHAT_HIGHLIGHT = 34,
		CTF_DROP = 35,
		CTF_RETURN = 36,
		CTF_GRAB_PL = 37,
		CTF_GRAB_EN = 38,
		CTF_CAPTURE = 39,
		MENU = 40,
	},
	flags = {
		gameinfo = {
			TIMESCORE = 1,
			GAMETYPE_RACE = 2,
			GAMETYPE_FASTCAP = 4,
			GAMETYPE_FNG = 8,
			GAMETYPE_DDRACE = 16,
		}
	},
}

---@alias ClientId integer|Character|Player

---@param system string # Short logger namespace like "lua" or "server"
---@param message string # Line to log to the server console
function ddnetpp.log_info(system, message) end

---@param message string # Line to log to the server console
function ddnetpp.log_info(message) end

---@param system string # Short logger namespace like "lua" or "server"
---@param message string # Line to log to the server console
function ddnetpp.log_warn(system, message) end

---@param message string # Line to log to the server console
function ddnetpp.log_warn(message) end

---@param system string # Short logger namespace like "lua" or "server"
---@param message string # Line to log to the server console
function ddnetpp.log_error(system, message) end

---@param message string # Line to log to the server console
function ddnetpp.log_error(message) end

---Sends a server chat message to everyone.
---@param message string # The message to be displayed in chat
function ddnetpp.send_chat(message) end

---Sends a server chat message to one specific client.
---@param client_id ClientId # The recipient of the message
---@param message string # The message to be displayed in chat
function ddnetpp.send_chat_target(client_id, message) end

---Sends a server broadcast message to everyone
---That is the white text in the middle of the screen.
---You can use \n for newlines.
---@param text string # The text to be displayed
function ddnetpp.send_broadcast(text) end

---Sends a server broadcast message to one player
---That is the white text in the middle of the screen.
---You can use \n for newlines.
---@param text string # The text to be displayed
---@param client_id ClientId # The player that will receive the broadcast
function ddnetpp.send_broadcast_target(client_id, text) end

---Sends a server message of the day to everyone
---The is the big wall of text with the dark background.
---You can use \n for newlines.
---@param text string # The text to be displayed
function ddnetpp.send_motd(text) end

---Sends a server message of the day to one player
---The is the big wall of text with the dark background.
---You can use \n for newlines.
---@param text string # The text to be displayed
---@param client_id ClientId # The player that will receive the broadcast
function ddnetpp.send_motd_target(client_id, text) end

---Render a text our of laser projectiles in the world
---@param pos Position # Where in the world the laser text should appear
---@param text string # What kind of text should be displayed
---@param ticks? integer # For how many server ticks the text should be displayed (see ddnetpp.server.tick_speed())
function ddnetpp.laser_text(pos, text, ticks) end

---Creates a visual particle in the world. It has no gameplay effect.
---It is a yellow rotating star. And in vanilla teeworlds it indicates the amount of damage.
---@param pos Position
---@param angle? number
---@param amount? integer
---@param mask? ClientMask
function ddnetpp.create_damage_indicator(pos, angle, amount, mask) end

---Creates a visual particle in the world. It has no gameplay effect.
---The white splash that is usually created when a hammer hits a tee.
---@param pos Position
---@param mask ClientMask?
function ddnetpp.create_hammer_hit(pos, mask) end

---Create a full explosion at the given position
---it will apply "damage" to all hit tees which in ddnet++ usually just means knockback.
---@param pos Position
---@param owner ClientId?
---@param weapon integer?
---@param no_damage boolean?
---@param team integer?
---@param mask ClientMask?
function ddnetpp.create_explosion(pos, owner, weapon, no_damage, team, mask) end

---Creates a visual particle in the world. It has no gameplay effect.
---The is the purple steam spawn animation.
---@param pos Position
---@param mask ClientMask
function ddnetpp.create_player_spawn(pos, mask) end

---Creates a visual particle in the world. It has no gameplay effect.
---This is the bursting tee animation that happens when someone dies.
---@param pos Position
---@param client_id ClientId # The player that died, used to lookup the skin used for the death effect
---@param mask ClientMask
function ddnetpp.create_death(pos, client_id, mask) end

---@param pos Position
---@param sound_id? integer # See ddnetpp.sound.* constants for possible values
---@param mask? ClientMask
function ddnetpp.create_sound(pos, sound_id, mask) end

---@param sound_id? integer # See ddnetpp.sound.* constants for possible values
---@param target? ClientId # Who will receive and hear the sound, by defaults its -1 so everyone
function ddnetpp.create_sound_global(sound_id, target) end

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

---Returns a random number in the range of 0 to the given max
---@param below integer # The maximum random value
---@return integer random
function ddnetpp.secure_rand_below(below) end

---@return string name name of the currently running plugin
function ddnetpp.plugin_name() end
