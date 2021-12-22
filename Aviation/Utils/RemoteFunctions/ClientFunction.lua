--//       Client Remote Function Module        \\--
--// All Client Object Inherrits From This Class \\--
--//                 By Frieda_VI                 \\--


--// Core Roblox Services \\--
local RunService = game:GetService("RunService")


--// Self \\--
local ClientFunctions = {}
ClientFunctions.__index = ClientFunctions


--// Statics \\--
local IsClient = RunService:IsClient()


--// Basic Util \\--
local function Client()
	--// Checks Wether Script Is Running On The Client \\--
	assert(IsClient, "This Action Can Only Be Performed On The Client")
end

local function ASSERT(Variable, Name)
	--// Quick Assertion Function \\--
	assert(Variable, "Argument[" .. Name .. "]" .. "Is Invalid!")
end

function ClientFunctions:_Test()
	--// Testing Station[Client] \\--
	Client()
	print("Success")
end


function ClientFunctions:BindToClient(FUNCTION)
	--// Parallel To THe Server Version \\--

	--// Connects A Function That Will Be Fired When The Remote Object Is Invoked \\--
	--// This Action Can Only Be Done Via The Server \\--

	--// This Function Should Be Called As Soon As The Remote Object Is Regisered \\--
	Client()
	ASSERT(type(FUNCTION) == "function", "FUNCTION")
	assert(type(self.ClientFunction) ~= "function", "There Is Already A Function Attached To `" .. self.Name .. "`!")

	local RemoteCommunication = self.Instance
	if not RemoteCommunication then
		warn("Remote Connection System Provided Is INVALID!")
	end

	--// Reserving The Client Function \\--
	self.ClientFunction = FUNCTION
	RemoteCommunication.OnClientInvoke = FUNCTION
end

--// Firing Methods
function ClientFunctions:FireServer(...)
	--// Fires The Server \\--
	--// Action Can Only Be Done Via The Client \\--
	Client()

	local Remote = self.Instance
	return Remote:InvokeServer(...)
end


return ClientFunctions
