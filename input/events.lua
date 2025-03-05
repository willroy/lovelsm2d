Events = Object:extend()

function Events:init()
	if string.find(globals.config.eventsPath, "%.") then
		self.events = helper:readFile(globals.config.eventsPath)
	else
		for k, item in pairs(helper:findFileRecursivelyByExt(globals.config.eventsPath, ".json")) do
			self.events = helper:readFile(item)
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
		if helper:mysplit(event.trigger, " ")[1] == "click" then
			if helper:mysplit(event.trigger, " ")[2] == node.handle then
				self.running = true
				local tasks = event.tasks
				for t = 1, #tasks do
					if helper:mysplit(tasks[t]," ")[1] == "dialog" then 
						self.tasks[t] = {task = tasks[t], initialized = false, continue = false}
					else
						self.tasks[t] = {task = tasks[t], initialized = false, continue = false}
					end
				end
			end
		end
	end
end

function Events:trigger_nodeHover(node)
	if self.triggered or self.running then return end
end

function Events:trigger_locationChange()
	if self.triggered or self.running then return end
end

function Events:trigger_timeElapsed(t)
	if self.triggered or self.running then return end
end

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

	nodeManager:loadNode(handle)

	self.tasks[self.taski].initialized = true
	self.tasks[self.taski].continue = true
end

function Events:task_loadNodeGroup()
	local task = self.tasks[self.taski].task
	local handle = helper:mysplit(task, " ")[2]

	nodeManager:loadNodeGroup(handle)

	self.tasks[self.taski].initialized = true
	self.tasks[self.taski].continue = true
end

function Events:task_unloadNode()
	local task = self.tasks[self.taski].task
	local handle = helper:mysplit(task, " ")[2]

	nodeManager:unloadNode(handle)

	self.tasks[self.taski].initialized = true
	self.tasks[self.taski].continue = true
end

function Events:task_unloadNodeGroup()
	local task = self.tasks[self.taski].task
	local handle = helper:mysplit(task, " ")[2]

	nodeManager:unloadNodeGroup(handle)

	self.tasks[self.taski].initialized = true
	self.tasks[self.taski].continue = true
end