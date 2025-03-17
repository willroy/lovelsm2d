luaunit = require('luaunit')

require("lovelsm2d/nodes/object")
require("lovelsm2d/util/tag")
require("lovelsm2d/util/helper")
require("lovelsm2d/globals")

helper = Helper("/home/will-roy/dev/games/pokemaker4/")
globals = Globals("")

function testTagWithNoTag()
	local tag = Tag()
	local testStr = "No Tag"
	
	luaunit.assertEquals(tag:check(testStr),testStr)
end

function testTagWithTag()
	local tag = Tag()
	local testStr = "££globals.config.debugEnabled$$"
	
	luaunit.assertEquals(tag:check(testStr),false)
end

os.exit( luaunit.LuaUnit.run() )