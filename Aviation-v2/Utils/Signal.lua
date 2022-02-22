--// This is the Signal Util \\--

local Signal = {}
Signal.__index = Signal

function Signal.IsSignal(OBJECT)
	return typeof(OBJECT) == "table" and OBJECT.ClassName == "Signal" and getmetatable(OBJECT) == Signal
end

local RBXScriptConnection = {}
RBXScriptConnection.__index = RBXScriptConnection

local ConnectionName = "FR_SignalConnection-"

function RBXScriptConnection:__tostring()
	return ConnectionName .. self.Disabled
end

function RBXScriptConnection.IsConnection(OBJECT)
	return type(OBJECT) == "table"
		and OBJECT.ClassName == ConnectionName
		and not OBJECT.Disabled
		and typeof(OBJECT.Function) == "function"
		and getmetatable(OBJECT) == RBXScriptConnection
end

function RBXScriptConnection.Wrap(FUNCTION)
	return setmetatable({
		ClassName = ConnectionName,
		Disabled = false,
		Function = FUNCTION,
	}, RBXScriptConnection)
end

--// Fire and Disabling \\--

function RBXScriptConnection:Fire(...)
	if self:IsConnection() then
		self.Function(...)
	end
end

function RBXScriptConnection:Disconnect()
	if not self:IsConnection() then
		warn("Attempting to disable an invalid object!")
		return
	end

	self.Disabled = true
	self.ClassName = nil
	self.Function = nil
end

--// Creation Of Signal \\--

function Signal.LegacyNew()
	return setmetatable({
		ClassName = "Signal",
		Connections = {},
	}, Signal)
end

function Signal.new(...)
	--// `Signal.Wrap` and `Signal.new` were combined \\--

	local Callbacks = typeof(...) == "table" and ... or { ... }
	local self = Signal.LegacyNew()

	for _Index, Callback in pairs(Callbacks) do
		if typeof(Callback) == "function" then
			self:Connect(Callback)
		end
	end

	return self
end

function Signal.Wrap(FUNCTION)
	assert(type(FUNCTION) == "function", "Argument[1] must be of type ::function::!")

	local WrappedSignal = Signal.LegacyNew()
	WrappedSignal:Connect(FUNCTION)

	return WrappedSignal
end

function Signal:Connect(FUNCTION)
	assert(type(FUNCTION) == "function", "Argument[1] must be of type ::function::!")

	local Connection = RBXScriptConnection.Wrap(FUNCTION)
	table.insert(self.Connections, Connection)

	return Connection
end

--// Fire Connection \\--
function Signal:Fire(...)
	if not self:IsSignal() then
		return warn("Attempting to fire a dead Signal!")
	end

	for _Index, Connection in pairs(self.Connections) do
		task.spawn(Connection.Fire, Connection, ...)
	end
end

function Signal:FireDefer(...)
	if not self:IsSignal() then
		return warn("Attempting to fire a dead Signal!")
	end

	for _Index, Connection in pairs(self.Connections) do
		task.defer(Connection.Fire, Connection, ...)
	end
end

function Signal:FireYield(...)
	if not self:IsSignal() then
		return warn("Attempting to fire a dead Signal!")
	end

	for _Index, Connection in pairs(self.Connections) do
		Connection:Fire(...)
	end
end

--// Destruction of Signals \\--
function Signal:Destroy()
	if Signal:IsSignal() then
		self.ClassName = nil

		for _Index, Connection in pairs(self.Connections) do
			if RBXScriptConnection.IsConnection(Connection) then
				Connection:Disconnect()
			end
		end

		table.clear(self.Connections)
	else
		warn("Attempting to destroy an invalid object!")
	end
end

return Signal
