require("lovelsm2d/engine")

Lovelsm2d = Object:extend()

engine = Engine

function Lovelsm2d:init()
	io.stdout:setvbuf("no")

	engine:init()
end

function Lovelsm2d:loadNodes()
	engine:loadNodes()
end

function Lovelsm2d:update(dt)
	engine:update(dt)
end

function Lovelsm2d:draw()
	engine:draw()
	engine:postDraw()
end

function Lovelsm2d:mousepressed(x, y, button, istouch)
	engine:mousepressed(x, y, button, istouch)
end

function Lovelsm2d:mousereleased(x, y, button, istouch)
	engine:mousereleased(x, y, button, istouch)
end

function Lovelsm2d:keypressed(key, code)
	engine:keypressed(key, code)
end

function Lovelsm2d:keyreleased(key)
	engine:keyreleased(key)
end

function Lovelsm2d:wheelmoved(x, y)
	engine:wheelmoved(x, y)
end

function Lovelsm2d:resize(w, h)
  engine:resize(w, h)
end

function Lovelsm2d:quit()
	engine:quit()
	return false
end