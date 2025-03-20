Menu = Object:extend()

function Menu:init(node, data)
	if node == nil or data == nil then return end
	self.node = node

	local text = Text(self.node, data.menu.label)
	local button = Button(self.node, data.menu)

	self.menu = { label = text, button = button } 

	self.submenus = {}

	for k, submenu in pairs(data.submenus) do
		submenu.label.transform.y = self.node.transform.y + submenu.drawable.data.transform.h * k
		submenu.drawable.data.transform.y = self.node.transform.y + submenu.drawable.data.transform.h * k
		submenu.hoverdrawable.data.transform.y = self.node.transform.y + submenu.drawable.data.transform.h * k
		submenu.overrideHoverCheck = true

		local text = Text(self.node, submenu.label)
		local button = Button(self.node, submenu)
		local event = submenu.event

		self.submenus[#self.submenus+1] = { label = text, button = button, event = event }
	end

	if data.submenubackground.drawable.type == "image" then self.submenubackground = Image(self.node, data.submenubackground.drawable.data) end
	if data.submenubackground.drawable.type == "animation" then self.submenubackground = Animation(self.node, data.submenubackground.drawable.data) end
	if data.submenubackground.drawable.type == "spritesheet" then self.submenubackground = Spritesheet(self.node, data.submenubackground.drawable.data) end
	if data.submenubackground.drawable.type == "shape" then self.submenubackground = Shape(self.node, data.submenubackground.drawable.data) end

	self.color = data.color or { r = 0, g = 0, b = 0, a = 1 }
end

function Menu:update(dt)
	if helper:contains(input.nodes_hovered, self.node) then
		local mousePos = globals.trackers.mousePos
		local relativeYInMenu = mousePos.y - self.node.transform.y

		for k, submenu in pairs(self.submenus) do
			local subMenuTransform = submenu.button.drawable.transform
			submenu.button.hovered = false
			if relativeYInMenu > subMenuTransform.y and relativeYInMenu < ( subMenuTransform.y + subMenuTransform.h ) then
				submenu.button.hovered = true
				if helper:contains(input.nodes_clicked, self.node) and submenu.event ~= nil then
					events:runEvent(events:findEvent(submenu.event))
				end
			end
		end
	end
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

function Menu:mousereleased(x, y, button, istouch)
end

function Menu:wheelmoved(x, y)
end