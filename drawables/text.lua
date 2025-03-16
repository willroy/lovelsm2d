-- An object that exists in the game

Text = Object:extend()

function Text:init(node, data)
	self.text = data.text
	self.font = data.font or love.graphics.getFont()
	self.containerTransform = data.containerTransform or { x = 0, y = 0, w = 0, h = 0 }
	self.positioning = data.positioning or "top-left"
	self.color = data.color or {r=0,g=0,b=0,a=1}
end

function Text:update(dt) end

function Text:draw()
	love.graphics.setColor(self.color.r,self.color.g,self.color.b,self.color.a)
	if self.positioning == "top-left" then love.graphics.print(self.text, self.containerTransform.x, self.containerTransform.y) end
	if self.positioning == "center" then
		local containerCenter = { x = self.containerTransform.w / 2 + self.containerTransform.x, y = self.containerTransform.h / 2 + self.containerTransform.y }
		local x = ( containerCenter.x - ( self.font:getWidth(self.text) / 2 ) )
		local y = ( containerCenter.y - ( self.font:getHeight(self.text) / 2 ) )
		love.graphics.print(self.text, x, y)
	end
	love.graphics.setColor(1,1,1,1)
end