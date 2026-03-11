local assert_eq = require("simple.assert").assert_eq
local extract_params = require("../src/plugin_parser").extract_params

local diffs = {}

diffs = extract_params("")
assert_eq(nil, diffs)

diffs = extract_params([[
ddnetpp.register_rcon("yellow", "s[foo]", "description of command", function (client_id, args)
	ddnetpp.send_chat("cid=" .. client_id  .. " ran command with arg: '" .. args.foo .. "'")
end)

ddnetpp.register_rcon("test", "i[client_id]s[name]", "description of command", function (client_id, args)
	ddnetpp.send_chat("cid=" .. args.client_id .. " name=" .. args.name)
end)
]])

assert_eq(95, diffs[1].start)
assert_eq(94, diffs[1].finish)
assert_eq("---@cast args { foo: string }", diffs[1].text)

assert_eq(297, diffs[2].start)
assert_eq(296, diffs[2].finish)
assert_eq("---@cast args { client_id: integer, name: string }", diffs[2].text)
