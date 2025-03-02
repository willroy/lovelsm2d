Events = Object:extend()

function Events:init()
	local eventTriggersPath = globals.config.dataPath.."/eventTriggers.json"
	local eventsPath = globals.config.dataPath.."/events.json"

	self.eventTriggers = data:readFile(eventTriggersPath)
	self.events = data:readFile(eventsPath)
	self.events = data:readFile(globals.config.dataPath.."/events.json")
	self.triggered = false
	self.running = false

	self.tasks = {}
	self.taski = 1
end

function Events:trigger_nodeClick(node)
	if self.triggered or self.running then return end
	for e = 1, #self.eventTriggers do
		if helper:mysplit(self.eventTriggers[e].trigger, " ")[1] == "click" then
			if helper:mysplit(self.eventTriggers[e].trigger, " ")[2] == node.handle then
				self.running = true
				local tasks = data:readKeyInFile(globals.config.dataPath.."/events.json", self.eventTriggers[e].event)
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

	if taskType == "globals" then self:runGlobalsTask() end
	if taskType == "print" then self:runPrintTask() end
end

function Events:runGlobalsTask()
	local task = self.tasks[self.taski].task
	local variable = helper:mysplit(task, " ")[2]
	local newValue = helper:mysplit(task, " ")[3]
	globals.engineGlobals[variable] = newValue
	self.tasks[self.taski].initialized = true
	self.tasks[self.taski].continue = true
end

function Events:runPrintTask()
	local task = self.tasks[self.taski].task
	print(string.sub(task, 7, #task))
	self.tasks[self.taski].initialized = true
	self.tasks[self.taski].continue = true
end