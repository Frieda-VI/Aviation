--//       Server Remote Function Module        \\--
--// All Server Object Inherrits From This Class \\--
--//                 By Frieda_VI                 \\--

--// Core Roblox Services \\--
local RunService = game:GetService("RunService")


--// Self \\--
local ServerFunctions = {}
ServerFunctions.__index = ServerFunctions


--// Statics \\--
local IsServer = RunService:IsServer()


--// Basic Util Function \\--
local function Server()
	--// Checks Wether Script Is Running On The Server
	assert(IsServer, "This Action Can Only Be Performed On The Server")
end

local function ASSERT(Variable, Name)
	--// Quick Assertion Function \\--
	assert(Variable, "Argument[" .. Name .. "]" .. "Is Invalid!")
end

function ServerFunctions:_Test()
	--// Testing Station[Server] \\--
	Server()
	print("Success")
end


--// Core Functions Inherrited By Remotes \\--
function ServerFunctions:BindToServer(FUNCTION)
	--// Connects A Function That Will Be Fired When The Remote Object Is Invoked \\--
	--// This Action Can Only Be Done Via The Server \\--

	--// This Function Should Be Called As Soon As The Remote Object Is Regisered \\--
	Server()
	ASSERT(type(FUNCTION) == "function", "FUNCTION")
	assert(type(self.ServerFunction) ~= "function", "There Is Already A Function Attached To `" .. self.Name .. "`!")

	--// Getting The Instance And Attaching A Function To It's Invoked Method \\--
	local RemoteInstance = self.Instance
	if not RemoteInstance then
		--// Remote Communication's Instance Is Invalid \\--
		warn("Remote Connection System Provided Is INVALID!")
	end

	--// Reversing The Server Functions \\--
	self.ServerFunction = FUNCTION
	RemoteInstance.OnServerInvoke = FUNCTION
end

function ServerFunctions:FireClient(...)
	--// Fires The Client \\--
	--// Action Can Only Be Done Via The Server \\--
	Server()
	--// Doesn't Require The Player Argument Anymore Because It Can Now Save The Player As Part On The Remote When Asked For The Client Structure \\--
	local Player = self.Player
	local Remote = self.Instance

	ASSERT(Player, "Player")
	ASSERT(Remote, "Remote")

	return Remote:InvokeClient(Player, ...)
end




function ServerFunctions:Destroy()
	--// Destroy The Remote Object \\--
	Server()

	self.Instance:Destroy()
	self.ServerFunctions = {}

	self = {}
end


return ServerFunctions
