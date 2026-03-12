local assert_eq = require("simple.assert").assert_eq
local params_parser = require("../src/params_type")
local params_to_class = params_parser.params_to_class
local params_to_cast = params_parser.params_to_cast
local escape_key_type = params_parser.escape_key_type


local function trim(s)
	return s:match( "^%s*(.-)%s*$" )
end

assert_eq("x", escape_key_type("x"))
assert_eq("xx", escape_key_type("xx"))
assert_eq("x1", escape_key_type("x1"))
assert_eq(trim([[
["x x"]
]]), escape_key_type("x x"))
assert_eq(trim([[
["2"]
]]), escape_key_type("2"))
assert_eq(trim([[
["2a"]
]]), escape_key_type("2a"))
assert_eq(trim([[
["²²²"]
]]), escape_key_type("²²²"))
assert_eq(trim([[
["'on'|'off'"]
]]), escape_key_type("'on'|'off'"))
assert_eq(trim([[
["\""]
]]), escape_key_type([["]]))

assert_eq(trim([[
---@class Args
---@field name string
---@field seconds integer
]]), params_to_class("s[name]i[seconds]"))

assert_eq(
	"---@cast args { name: string, seconds: integer }",
	params_to_cast("s[name]i[seconds]")
)

assert_eq(
	"---@cast args { }",
	params_to_cast("")
)

assert_eq(
	"---@cast args { name: string }",
	params_to_cast("s[name]")
)

assert_eq(
	"---@cast args { }",
	params_to_cast("s")
)

assert_eq(
	nil,
	params_to_cast("s[[")
)

-- https://github.com/LuaLS/lua-language-server/discussions/3378
assert_eq(
	[[---@cast args { ["player name"]: string }]],
	params_to_cast("s[player name]")
)
