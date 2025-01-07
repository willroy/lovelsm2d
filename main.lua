require("engine/engine")

engine = Engine

function love.load()
	local dataPath = "config"
	engine:init(dataPath)

	engine:loadNode("test-node")
	engine:loadNode("test-node-2")
end

function love.update(dt)
	engine:update(dt)
end

function love.draw()
	engine:draw()
	engine:postDraw()
end

function love.mousepressed(x, y, button, istouch)
	engine:mousepressed(x, y, button, istouch)
end

function love.mousereleased(x, y, button, istouch)
	engine:mousereleased(x, y, button, istouch)
end

function love.keypressed(key, code)
	engine:keypressed(key, code)
end

function love.keyreleased(key)
	engine:keyreleased(key)
end

function love.wheelmoved(x, y)
	engine:wheelmoved(x, y)
end

function love.quit()
	engine:quit()
	return false
end