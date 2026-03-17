---@meta

---@class SnapItemLaser
---@field id integer # Snap item id that should be unique per snap item, use `ddnetpp.snap.new_id()` for that
---@field x number # The end position x of the laser ray
---@field y number # The end position y of the laser ray
---@field from_x? number # The starting position x of the laser ray
---@field from_y? number # The starting position y of the laser ray
---@field start_tick? integer # The servers tick of when this laser was created

---@class SnapItemPickup
---@field id integer # Snap item id that should be unique per snap item, use `ddnetpp.snap.new_id()` for that
---@field pos Position # The position of the pickup
---@field type? integer # For example ddnetpp.protocol.POWERUP_WEAPON
---@field sub_type? integer # For example ddnetpp.protocol.WEAPON_HAMMER
---@field switch_number? integer # Which switch index turns on or off the pickup
---@field flags? integer # TODO: document and defined types

---@class SnapItemCharacter
---@field id integer # Snap item id that should be unique per snap item, use `ddnetpp.snap.new_id()` for that
---@field tick? integer # The reckoning tick for dead reckoning. The client will use the world and character position and velocity to predict a new position based on the tick diff
---@field x integer # The x coordinate in the world
---@field y integer # The y coordinate in the world
---@field vel_x integer # The horizontal velocity, positive number is speed to the right and negative to the left
---@field vel_y integer # The vertical velocity, positive number is speed downwards and negative is speed upwards
---@field angle integer # The rotation of the weapon
---@field direction integer # -1 is left 0 is not walking and 1 is right
---@field jumped integer # Checkout this for more details https://chillerdragon.github.io/teeworlds-protocol/07/snap_items.html#obj_character_core
---@field hooked_player integer # Client id of the player this character is currently hooking or -1 if the hook is not attached to another tee
---@field hook_state integer # See the ddnetpp.hook.* constants for possible values
---@field hook_tick integer
---@field hook_x integer
---@field hook_y integer
---@field hook_dx integer
---@field hook_dy integer
---@field player_flags integer # Bitwise flags like chatting
---@field health integer # Should be in range of 0-10 but can also be -1 if it should be hidden
---@field armor integer # Should be in range of 0-10 but can also be -1 if it should be hidden
---@field ammo_count integer
---@field weapon integer # See ddnetpp.weapon.* constants for possible values
---@field eye_emote integer # See ddnetpp.eye_emote.* constants for possible values
---@field attack_tick integer

---@class SnapItemPlayerInfo
---@field id integer # Snap item id that should be unique per snap item, use `ddnetpp.snap.new_id()` for that
---@field is_local? boolean # If set to true the snap receiver will use this as its own info
---@field client_id integer
---@field team? integer # See ddnetpp.team.* constants for possible values (but without team.ALL xd)
---@field score? integer
---@field latency? integer

---@class SnapItemClientInfo
---@field id integer # Snap item id that should be unique per snap item, use `ddnetpp.snap.new_id()` for that
---@field name? string # Will be displayed in chat and scoreboard and a few other places
---@field clan? string # Will be displayed in scoreboard and clan nameplates if turned on
---@field country? integer
---@field skin? string # Name of the skin which maps directly to a png file in the skins directory
---@field use_custom_color? boolean # If set to false it will ignore color body and feet and use the skins default color
---@field color_body? integer
---@field color_feet? integer

---@class Snapshot
local snap = {}

---Allocates a new id for a snapshot item.
---Make sure to free it if you no longer send the snap item.
---Using `ddnetpp.snap.free_id(id)`
---@return integer snap_item_id # the next free id that can be used for snapshot items
function snap.new_id() end

---Frees an snapshot item id that was allocated
---by `ddnetpp.snap.new_id()`
---call this once you are done snapping the item you used this for.
---@param snap_item_id integer # an id for snap items that was allocated by `ddnetpp.snap.new_id()`
function snap.free_id(snap_item_id) end

---Only call this method from within the `ddnetpp.snap.on_snap()` callback!
---Adds one laser to the current snapshot. You have to call this every snapshot
---to keep it there. To remove it stop calling it.
---For one laser call `ddnetpp.snap.new_id()` once then snap it as many
---times as you want using this method and then free the id using `ddnetpp.snap.free_id()`
---@param laser SnapItemLaser # The laser that will be included in the current snapshot
function snap.new_laser(laser) end

---Only call this method from within the `ddnetpp.snap.on_snap()` callback!
---Adds one pickup to the current snapshot. You have to call this every snapshot
---to keep it there. To remove it stop calling it.
---For one pickup call `ddnetpp.snap.new_id()` once then snap it as many
---times as you want using this method and then free the id using `ddnetpp.snap.free_id()`
---Example:
---```lua
---local pickup_id = nil
---
---function ddnetpp.on_init()
---	pickup_id = ddnetpp.snap.new_id()
---end
---
---function ddnetpp.on_snap(snapping_client)
---	local chr = ddnetpp.get_character(0)
---	if chr == nil then
---		return
---	end
---
---	local pos = chr:pos()
---	pos.x = pos.x + 2
---	ddnetpp.snap.new_pickup({
---		id = pickup_id,
---		pos = pos,
---		type = ddnetpp.protocol.POWERUP_WEAPON,
---		sub_type = ddnetpp.protocol.WEAPON_HAMMER,
---	})
---end
---```
---@param pickup SnapItemPickup # The pickup that will be included in the current snapshot
function snap.new_pickup(pickup) end

---Only call this method from within the `ddnetpp.snap.on_snap()` callback!
---This only sends one specific tee information over the network.
---It does not create a full character instance with physics.
---If you want this character to be "alive" or move you have to implement all of that.
---Also for it to properly display you also need client and player info.
---So call ddnetp.snap.new_client_info() and ddnetpp.snap.new_player_info() and pass the
---same item and client id for it to match.
---Example:
---```lua
---function ddnetpp.on_snap()
---	ddnetpp.snap.new_client_info({
---		id = 10,
---		name = "foo",
---		clan = "",
---		skin = "greensward",
---		use_custom_color = false,
---	})
---	ddnetpp.snap.new_player_info({
---		id = 10,
---		client_id = 10,
---		is_local = false,
---		team = ddnetpp.team.GAME,
---		score = 0,
---		latency = 0,
---	})
---	ddnetpp.snap.new_character({
---		id = 10,
---		tick = 10,
---		x = 10,
---		y = 10,
---		vel_x = 10,
---		vel_y = 10,
---		angle = 0,
---		direction = 1,
---		jumped = 1,
---		hooked_player = 0,
---		hook_state = ddnetpp.hook.GRABBED,
---		hook_tick = 2,
---		hook_x = 2,
---		hook_y = 2,
---		hook_dx = 2,
---		hook_dy = 2,
---		player_flags = 2,
---		health = 2,
---		armor = 2,
---		ammo_count = -1,
---		weapon = ddnetpp.weapon.LASER,
---		eye_emote = ddnetpp.eye_emote.PAIN,
---		attack_tick = 3,
---	})
---end
---```
---@param character SnapItemCharacter # The tee to be included in the current snapshot
function snap.new_character(character) end

---Only call this method from within the `ddnetpp.snap.on_snap()` callback!
---See ddnetpp.snap.new_character() for a full example
---@param player_info SnapItemPlayerInfo # The info to be included in the current snapshot
function snap.new_player_info(player_info) end

---Only call this method from within the `ddnetpp.snap.on_snap()` callback!
---See ddnetpp.snap.new_character() for a full example
---@param client_info SnapItemClientInfo # The info to be included in the current snapshot
function snap.new_client_info(client_info) end
