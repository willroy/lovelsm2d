Events = Object:extend()

function Events:init()
	self.events = {}
	if string.find(globals.config.eventsPath, "%.") then
		for k, v in pairs(helper:readFile(globals.config.eventsPath)) do
			self.events[#self.events+1] = v
		end
	else
		for k, item in pairs(helper:findFileRecursivelyByExt(globals.config.eventsPath, ".json")) do
			for k, v in pairs(helper:readFile(item)) do
				self.events[#self.events+1] = v
			end
		end
	end

	self.triggered = false
	self.running = false

	self.tasks = {}
	self.taski = 1
end

function Events:trigger_nodeClick(node)
	if self.triggered or self.running then return end
	for k, event in pairs(self.events) do
		local triggerPassed = helper:mysplit(event.trigger, " ")[1] == "click" and helper:mysplit(event.trigger, " ")[2] == node.handle
		if triggerPassed then self:runEvent(event) end
	end
end

function Events:trigger_nodeHover(node)
	if self.triggered or self.running then return end
	for k, event in pairs(self.events) do
		local triggerPassed = helper:mysplit(event.trigger, " ")[1] == "hover" and helper:mysplit(event.trigger, " ")[2] == node.handle
		if triggerPassed then self:runEvent(event) end
	end
end

function Events:trigger_keyPressed(key)
	if self.triggered or self.running then return end
	for k, event in pairs(self.events) do
		local triggerPassed = helper:mysplit(event.trigger, " ")[1] == "press" and globals:checkKeyBinds(helper:mysplit(event.trigger, " ")[2], key)
		if triggerPassed then self:runEvent(event) end
	end
end

function Events:runEvent(event)
	local conditionsPassed = self:checkConditions(event)
	if conditionsPassed then
		self.running = true
		local tasks = event.tasks
		for t = 1, #tasks do
			self.tasks[t] = {task = tasks[t], initialized = false, continue = false}
		end
	end
end

-- Condition Handling

function Events:checkConditions(event)
	local passed = false

	if event.conditions == nil or #event.conditions == 0 then return true end

	for k, condition in pairs(event.conditions) do
		local conditionTokens = helper:mysplit(condition, " ")
		local condition = conditionTokens[1]
		local target = conditionTokens[2]

		if condition == "loaded" then passed = nodes:isNodeGroupLoaded(target) end

		if conditionTokens[#conditionTokens] == "not" then passed = not passed end
	end

	return passed
end

-- Task Handling

function Events:taskHandler()
	if not self.tasks[self.taski].initialized then self:runTask() end
	if self.tasks[self.taski].continue and self.tasks[self.taski].initialized and self.taski < #self.tasks then self.taski = self.taski + 1 end
	if self.tasks[self.taski].continue and self.tasks[self.taski].initialized and self.taski == #self.tasks then
		self.running = false
		self.tasks = {}
		self.taski = 1
	end
end

function Events:runTask()
	local task = self.tasks[self.taski].task
	local taskType = helper:mysplit(task, " ")[1]

	if taskType == "globals" then self:task_runGlobals() end
	if taskType == "print" then self:task_runPrint() end
	if taskType == "loadNode" then self:task_loadNode() end
	if taskType == "loadNodeGroup" then self:task_loadNodeGroup() end
	if taskType == "unloadNode" then self:task_unloadNode() end
	if taskType == "unloadNodeGroup" then self:task_unloadNodeGroup() end
end

function Events:task_runGlobals()
	local task = self.tasks[self.taski].task
	local variable = helper:mysplit(task, " ")[2]
	local newValue = helper:mysplit(task, " ")[3]
	globals.engineGlobals[variable] = newValue
	self.tasks[self.taski].initialized = true
	self.tasks[self.taski].continue = true
end

function Events:task_runPrint()
	local task = self.tasks[self.taski].task
	print(string.sub(task, 7, #task))
	self.tasks[self.taski].initialized = true
	self.tasks[self.taski].continue = true
end

function Events:task_loadNode()
	local task = self.tasks[self.taski].task
	local handle = helper:mysplit(task, " ")[2]

	nodes:loadNode(handle)

	self.tasks[self.taski].initialized = true
	self.tasks[self.taski].continue = true
end

function Events:task_loadNodeGroup()
	local task = self.tasks[self.taski].task
	local handle = helper:mysplit(task, " ")[2]

	nodes:loadNodeGroup(handle)

	self.tasks[self.taski].initialized = true
	self.tasks[self.taski].continue = true
end

function Events:task_unloadNode()
	local task = self.tasks[self.taski].task
	local handle = helper:mysplit(task, " ")[2]

	nodes:unloadNode(handle)

	self.tasks[self.taski].initialized = true
	self.tasks[self.taski].continue = true
end

function Events:task_unloadNodeGroup()
	local task = self.tasks[self.taski].task
	local handle = helper:mysplit(task, " ")[2]

	nodes:unloadNodeGroup(handle)

	self.tasks[self.taski].initialized = true
	self.tasks[self.taski].continue = true
end