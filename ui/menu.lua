Menu = Object:extend()

function Menu:init(node, data)
	self.node = node

	local text = Text(self.node, data.menu.label)
	local button = Button(self.node, data.menu)

	self.menu = { label = text, button = button } 

	self.submenus = {}

	for k, submenu in pairs(data.submenus) do
		submenu.label.transform.y = self.node.transform.y + submenu.drawable.data.transform.h * k
		submenu.drawable.data.transform.y = self.node.transform.y + submenu.drawable.data.transform.h * k
		submenu.hoverdrawable.data.transform.y = self.node.transform.y + submenu.hoverdrawable.data.transform.h * k

		local text = Text(self.node, submenu.label)
		local button = Button(self.node, submenu)

		self.submenus[#self.submenus+1] = { label = text, button = button }
	end

	if data.submenubackground.drawable.type == "image" then self.submenubackground = Image(self.node, data.submenubackground.drawable.data) end
	if data.submenubackground.drawable.type == "animation" then self.submenubackground = Animation(self.node, data.submenubackground.drawable.data) end
	if data.submenubackground.drawable.type == "spritesheet" then self.submenubackground = Spritesheet(self.node, data.submenubackground.drawable.data) end
	if data.submenubackground.drawable.type == "shape" then self.submenubackground = Shape(self.node, data.submenubackground.drawable.data) end

	self.color = data.color or { r = 0, g = 0, b = 0, a = 1 }
end

function Menu:update(dt)
end

function Menu:draw()
	love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)

	if helper:contains(input.nodes_hovered, self.node) then
		self.submenubackground:draw()

		self.menu.label:draw()
		self.menu.button:draw()

		for k, submenu in pairs(self.submenus) do
			submenu.label:draw()
			submenu.button:draw()
		end
	else
		self.menu.label:draw()
		self.menu.button:draw()
	end

	love.graphics.setColor(1,1,1,1)
end

function Menu:mousepressed(x, y, button, istouch)
end