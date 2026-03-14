---@meta

---@class SnapItemLaser
---@field id integer # Snap item id that should be unique per snap item, use `ddnetpp.snap.new_id()` for that
---@field x number # The end position x of the laser ray
---@field y number # The end position y of the laser ray
---@field from_x number # The starting position x of the laser ray
---@field from_y number # The starting position y of the laser ray
---@field start_tick integer # The servers tick of when this laser was created

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
