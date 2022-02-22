--// Vider Util, a janitor like util \\--
local Vider = {}
Vider.__index = Vider

--// RBXScriptConnection, A Custom Vider Object \\--

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

function RBXScriptConnection:Destroy()
	if not self:IsConnection() then
		warn("Attempting to disable an invalid object!")
		return
	end

	self.Disabled = true
	self.ClassName = nil
	self.Function = nil
end

--// Vider Itself \\--

function Vider.IsVider(OBJECT)
	return type(OBJECT) == "table" and OBJECT.ClassName == "Vider" and getmetatable(OBJECT) == Vider
end

function Vider:Debute(PrimaryInstance, ...)
	assert(typeof(PrimaryInstance) == "Instance", "Argument[1] is not of type ::Instance::")

	self = (self:IsVider()) and self or Vider.Nouveau()
	assert(self:IsVider(), "Object provided is not a of the Vider class!")

	local IsParentNil = (PrimaryInstance.Parent == nil)
	local function OnChange(_MainInstance, Parent)
		IsParentNil = (Parent == nil)

		if IsParentNil then
			for _Index, Function in pairs(self.MainInstanceFunctions) do
				if Function:IsConnection() then
					Function:Destroy()
				end
			end

			self:Nettoyer()
		end
	end
	self:AjouterSecondaire(...)

	table.insert(self.MainInstances, PrimaryInstance)
	if IsParentNil then
		self:Nettoyer()
	else
		table.insert(
			self.MainInstanceFunctions,
			RBXScriptConnection.Wrap(PrimaryInstance.AncestryChanged:Connect(OnChange))
		)
	end
	return self
end

--// Before and After cleaning up functions \\--

function Vider:AvantNettoyage(FUNCTION)
	assert(typeof(FUNCTION) == "function", "Argument[1] is not of the type ::FUNCTION::!")
	assert(self:IsVider(), "Object provided is not of the Vider Class!")

	table.insert(self.Nettoyage.Before, FUNCTION)
end

function Vider:ApresNettoyage(FUNCTION)
	assert(typeof(FUNCTION) == "function", "Argument[1] is not of the type ::FUNCTION::!")
	assert(self:IsVider(), "Object provided isn ot of the Vider Class!")

	table.insert(self.Nettoyage.After, FUNCTION)
end

--// Cleaning up process \\--

function Vider:Nettoyer(AllInstances)
	assert(self:IsVider(), "Object provide is not of the Vider Class!")

	for _Index, FUNCTION in pairs(self.Nettoyage.Before) do
		if typeof(FUNCTION) == "function" then
			FUNCTION()
		end
	end

	if AllInstances then
		for _Index, INSTANCE in pairs(self.MainInstances) do
			if INSTANCE ~= nil then
				INSTANCE:Destroy()
			end
		end
	end

	for _Index, ConnectionObject in pairs(self.Instances.Functions) do
		if ConnectionObject ~= nil then
			ConnectionObject:Destroy()
		end
	end

	for _Index, INSTANCE in pairs(self.Instances.Instances) do
		if INSTANCE ~= nil then
			INSTANCE:Destroy()
		end
	end

	for _Index, FUNCTION in pairs(self.Nettoyage.After) do
		if typeof(FUNCTION) == "function" then
			task.spawn(FUNCTION)
		end
	end
end

--// Adding Material to the Vider Objects \\--
function Vider:AjouterPrimaire(...)
	assert(self:IsVider(), "Object provided is not of the Vider Class!")

	for _Index, INSTANCE in pairs({ ... }) do
		if typeof(INSTANCE) == "Instance" then
			self = self:Debute(INSTANCE)
		end
	end

	return self
end

function Vider:AjouterSecondaire(...)
	assert(self:IsVider(), "Object provided is not of the Vider Class!")

	for _Index, Value in ipairs({ ... }) do
		if typeof(Value) == "Instance" then
			table.insert(self.Instances.Instances, Value)
		elseif typeof(Value) == "RBXScriptConnection" then
			table.insert(self.Instances.Functions, RBXScriptConnection.Wrap(Value))
		end
	end
end

function Vider.Nouveau()
	return setmetatable({
		ClassName = "Vider",

		MainInstances = {},
		MainInstanceFunctions = {},

		Instances = {
			Functions = {},
			Instances = {},
		},
		Nettoyage = {
			Before = {},
			After = {},
		},
	}, Vider)
end

return Vider
