local assert_eq = require("simple.assert").assert_eq
local params_parser = require("../src/params_type")
local params_to_class = params_parser.params_to_class
local params_to_cast = params_parser.params_to_cast


local function trim(s)
	return s:match( "^%s*(.-)%s*$" )
end

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
