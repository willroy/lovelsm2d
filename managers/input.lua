-- handles input and stores nodes being interacted with (click, hover, etc)

Input = Object:extend()

function Input:init()
	self.nodes_clicked = {}
	self.nodes_hovered = {}
	self.interactable_nodes_clicked = {}
	self.interactable_nodes_hovered = {}
	self.dialougeMode = false
	self.mouseDown = { status = false, button = 1 }
end

function Input:update(dt)
	if globals.trackers.lastMousePos.x == globals.trackers.mousePos.x and globals.trackers.lastMousePos.y == globals.trackers.mousePos.y then return false end
	
	self.nodes_hovered = {}
	self.interactable_nodes_hovered = {}

	for n = 1, #nodes.loadedNodes do
		local node = nodes.loadedNodes[n]
		if globals.trackers.mousePos.x > node.transform.x and globals.trackers.mousePos.x < (node.transform.x+node.transform.w) then
			if globals.trackers.mousePos.y > node.transform.y and globals.trackers.mousePos.y < (node.transform.y+node.transform.h) then
				self.nodes_hovered[#self.nodes_hovered+1] = node
				if node.interactable then
					self.interactable_nodes_hovered[#self.interactable_nodes_hovered+1] = node
					love.mouse.setCursor(helper:getCursor(globals.config.cursorPoint))
				end
			end
		end
	end

	if #self.interactable_nodes_hovered == 0 then love.mouse.setCursor(helper:getCursor(globals.config.cursorArrow)) end
end

function Input:mousepressed(x, y, button, istouch)
	self.mouseDown = { status = true, button = button }
	for n = 1, #nodes.loadedNodes do
		local node = nodes.loadedNodes[n]
		local interactable = node ~= nil and ( node.interactable and ( ( not self.dialougeMode ) or ( self.dialougeMode and node.type == "dialouge" ) ) )
		if interactable and x > node.transform.x and x < (node.transform.x+node.transform.w) then
			if y > node.transform.y and y < (node.transform.y+node.transform.h) then
				self.nodes_clicked[#self.nodes_clicked+1] = node
				node:mousepressed(x, y, button, istouch)
				events:trigger_nodeClick(node)
				events.triggered = true
				love.mouse.setCursor(helper:getCursor(globals.config.cursorPointInteract))
			end
		end
	end
end

function Input:mousereleased(x, y, button, istouch)
	self.mouseDown = { status = false, button = button }
	if #self.interactable_nodes_hovered > 0 then love.mouse.setCursor(helper:getCursor(globals.config.cursorPoint)) end
	self.nodes_clicked = {}
	events.triggered = false
end

function Input:keypressed(key, code)
	if globals:checkKeyBinds("quit", key) then love.event.quit() end
	if globals:checkKeyBinds("debug", key) then debugInfo.debugEnabled = not debugInfo.debugEnabled end
	events:trigger_keyPressed(key)
end

function Input:keyreleased(key)

end