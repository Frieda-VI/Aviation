
--// Remote Function Module \\--
--// All Remote Object Inherrits From This Class \\--
--// By Frieda_VI \\--


--// Core Services \\--
local RunService = game:GetService("RunService")

--// Self \\--
local Functions = {}
Functions.__index = Functions

--// Statics \\--
local IsServer = RunService:IsServer()
local IsClient = RunService:IsClient()

--// Basic Util \\--
local function Client()
    --// Checks Wether Script Is Running On The Client \\--
	assert(IsClient, "This Action Can Only Be Performed On The Client")
end

local function Server()
    --// Checks Wether Script Is Running On The Server
	assert(IsServer, "This Action Can Only Be Performed On The Server")
end

local function ASSERT(Variable, Name)
    --// Quick Assertion Function \\--
	assert(Variable, "Argument[" .. Name .. "]" .. "Is Invalid!")
end

function Functions:_TestClient()
    --// Testing Station[Client] \\--
	Client()
	print("Success")
end

function Functions:_TestServer()
    --// Testing Station[Server] \\--
	Server()
    print("Success")
end


--// Core Functions Inherrited By Remotes \\--
function Functions:BindToServer(FUNCTION)
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

function Functions:BindToClient(FUNCTION)
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
function Functions:FireServer(...)
    --// Fires The Server \\--
    --// Action Can Only Be Done Via The Client \\--
	Client()

	local Remote = self.Instance 
	return Remote:InvokeServer(...)
end

function Functions:FireClient(...)
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

function Functions:Destroy()
    --// Destroy The Remote Object \\--
    Server()

    self.Instance:Destroy()
    self.ServerFunctions = {}

    self = {}
end

return Functions