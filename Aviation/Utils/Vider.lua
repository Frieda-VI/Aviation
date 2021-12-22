

--// Vider Library By Frieda_VI \\--
--// Consists Of Cleaning Up \\--

--// RBX CONNECTION CLASS \\--
local RbxScriptConnection = {}
RbxScriptConnection.__index = RbxScriptConnection

function RbxScriptConnection:__tostring()
	--// Converts To A String Format \\--
	return "RBXConnection`" .. self.IsConnected .. "`"
end

function RbxScriptConnection.IsRbxScriptConnection(Object)
	--// Returns A Boolean Value Indicating Wether Object Is A RbxScriptConnection Object Or Not \\--
	return (type(Object) == "table" and Object.ClassName == "RbxScriptConnection" and Object.IsConnected == true) and true or false
end

function RbxScriptConnection.new(Connection)
	--// Constructs A Bran New RBXScriptConnection Object \\--
	assert(typeof(Connection) == "RBXScriptConnection", "Arguement[1] Is NOT Of Type ::RBXScriptConnection::")

	return setmetatable({
		ClassName = "RbxScriptConnection",
		IsConnected = true,
		Connection = Connection
	}, RbxScriptConnection)
end

function RbxScriptConnection:Destroy()
	assert(RbxScriptConnection.IsRbxScriptConnection(self), "Object Provided Is NOT Of RbxScriptConnection Class")

	if self.IsConnected then
		self.IsConnected = false
		self.Connection:Disconnect()
	end
end


local Vider = {}
Vider.__index = Vider

function Vider.IsVider(Object)
	--// Checks Wether An Object Is A Vider Object \\--
	return (type(Object) == "table" and Object.ClassName == "Vider") and true or false
end

function Vider:Debute(MainInstance, ...)
	--// Checking Wether MainInstance Is An Instance \\--
	assert(typeof(MainInstance) == "Instance", "Argument[1] Is NOT Of Type ::Instance::")

	--// Creates A New Vider Is Self Is Not A Vider Object \\--
	self = (self:IsVider()) and self or Vider.new()
	assert(Vider.IsVider(self), "Object Provided Is Not A Vider Class!")

	--// Parent Variable \\--
	local IsParentNil = (MainInstance.Parent == nil)

	local function OnChange(_MainInstance, Parent)
		IsParentNil = (Parent == nil)

		if IsParentNil then
			--// The Object Has Been Destroyed \\--
			for _Index, Function in pairs(self.MainInstanceFunctions) do
				if Function:IsRbxScriptConnection() then
					Function:Destroy()
				end
			end

			self:Nettoyer()
		end
	end

	--// Organises The Instances Attached To The Vider Object \\--	
	self:AjouteAutre(...)

	--// Setting Up The MainInstance 
	table.insert(self.MainInstances, MainInstance)

	if IsParentNil then
		--// If The Parent Is Nil Then Perform Self Clean Up \\--
		self:Nettoyer()
	else
		--// Main Part Is Still There, Can Connect This Function Without Erroring \\--
		table.insert(self.MainInstanceFunctions, RbxScriptConnection.new(MainInstance.AncestryChanged:Connect(OnChange)))
	end
	return self
end

function Vider:AvantNet(FUNCTION)
	--// Code Fires Before Cleaning \\--
	assert(typeof(FUNCTION) == "function", "Argument[1] Is NOT Of Type ::FUNCTION::")
	assert(self:IsVider(), "Object Provided Is NOT Of Class Vider")

	--// Attaching To The Before Cleaning \\--
	self.Nettoyage.Before = FUNCTION
end

function Vider:ApresNet(FUNCTION)
	--// Code Fires After Cleaning \\--
	assert(typeof(FUNCTION) == "function", "Argument[1] Is NOT Of Type ::FUNCTION::")
	assert(self:IsVider(), "Object Provided Is NOT Of Class Vider")

	--// Attaching To The After Cleaning \\--
	self.Nettoyage.After = FUNCTION
end

function Vider:Nettoyer(All)
	--// NOTE Cleaning Priority Is The Same For All Object \\--	
	--// Cleaning Up Function \\--
	assert(Vider.IsVider(self), "Object Provided Is NOT Of Vider Class")

	--// Running ANettoyage Function \\--
	if typeof(self.Nettoyage.Before) == "function" then
		self.Nettoyage.Before()
	end

	--// If NotAll == True \\--
	--// Main Instances Will NOT Be Cleaned \\--
	if All then
		for _Index, Object in pairs(self.MainInstances) do
			if Object ~= nil then

				Object:Destroy()
			end
		end	
	end

	--// Cleaning Of NON-Core Elements \\--
	--// Cleaning Order Applied \\--

	--// FUNCTIONS > INSTANCES \\--
	for _Index, Object in pairs(self.Instances.Functions) do
		if Object ~= nil then
			--// Destroy The Object If The Object Is Not Nil \\--
			Object:Destroy()
		end
	end

	for _Index, Object in pairs(self.Instances.Instances) do
		if Object ~= nil then
			--// Destroy The Object If The Object Is Not Nil \\--
			Object:Destroy()
		end
	end

	--// Running ANettoyage Function \\--
	if typeof(self.Nettoyage.After) == "function" then
		task.spawn(self.Nettoyage.After)
	end
end

function Vider:AjouteMain(...)	
	--// Adds Other Main Instances \\--
	for _Index, Value in pairs({...}) do
		if typeof(Value) == "Instance" then
			--// Debutes For Each Object \\--
			self = self:Debute(Value)
		end
	end

	return self
end

function Vider:AjouteAutre(...)
	--// Adds Other NON-Core Elements \\--
	--// Checks If Is Of Type Vider \\--
	assert(Vider.IsVider(self), "Object Provided Is Not A Vider Class!")

	--// Adds All Elements To The Instances List \\--
	for _Index, Value in ipairs({...}) do
		if typeof(Value) == "Instance" then
			--// Is An Instance \\--
			table.insert(self.Instances.Instances, Value)
		elseif typeof(Value) == "RBXScriptConnection" then
			--// Is A Connection Figure \\--
			table.insert(self.Instances.Functions, RbxScriptConnection.new(Value))
		end
	end
end

function Vider.new()
	--// Basic Constructor \\--
	return setmetatable({
		--// Setting Up Of Core Values \\--
		ClassName = "Vider",
		MainInstances = {},
		MainInstanceFunctions = {},
		Instances = {
			Functions = {},
			Instances = {}
		},
		Nettoyage = {}
	}, Vider)
end

return Vider

