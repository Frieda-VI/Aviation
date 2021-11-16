

--// Aviation \\--
--// This Is A Custom Framework By ImportLua#9522 \\--

--// Top Services \\--
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")


--// Aviation Self \\--
local AviationFramework = ReplicatedStorage:WaitForChild("Aviation")

--// Components \\--
local Components = AviationFramework:WaitForChild("Components")

--// Vider - Custom Janitor | RemoteFunctions - Inherrited By All Remote Objects \\--
--// RequestObject - Based Formatting \\--
local RemoteFunctions = require(Components:WaitForChild("Functions"))
local RequestObject = require(Components:WaitForChild("Request"))
local Vider = require(Components:WaitForChild("Vider"))

local IsClient = RunService:IsClient()
local IsServer = RunService:IsServer()

local function Location(Server)
    --// Function Which Checks The Run Location \\--
    if Server then
        --// Highest Fedality Is To The Server \\--
        assert(IsServer == true, "This Action Can Only Be Performed Via The Server!")
    else
        --// Secondary Is The Client \\--
        assert(IsClient == true, "This Action Can Only Be Performed Via The Client")
    end
end

--// Aviation Components \\--
local Aviation = {}
Aviation.__index = Aviation

local function _Build()
    --// Builds The Remote Communication Utils \\--
    local CommunicationUnit = Instance.new("Folder")
    CommunicationUnit.Name = "CommunicationUnit"

    --// Creation Of Core Communication Objects \\--

    local function Construct(Name, Type)
        --// Inner Construction \\--
        --// Makes Creating Instance Simple And Faster \\--

        local Parent = CommunicationUnit

        local INSTANCE = Instance.new(Type)
        INSTANCE.Name = Name
        INSTANCE.Parent = Parent

        return INSTANCE
    end

    Construct("ProcessData", "BindableEvent")
    Construct("RequestData", "RemoteFunction")
    Construct("RequestServer", "BindableFunction")

    --// Parenting It To The Framework \\--
    CommunicationUnit.Parent = AviationFramework
end

function Aviation.Start()
    --// Starts The Framework, Can Only Be Done Via The Server \\--
    Location(true)

    if not AviationFramework:FindFirstChild("Started") then
        --// Start The Framework \\--
        local Started = Instance.new("BoolValue")
        Started.Name = "Started"
        Started.Parent = AviationFramework

        Started.Value = false

        --// Server Script Service \\--
        _Build()

        local ServerScriptService = game:GetService("ServerScriptService")
        local Archive = Components:WaitForChild("Archive")

        --// Concludes And Start \\--
        Archive.Parent = ServerScriptService
        Started.Value = true
    else
        warn("Aviation Framework Has Already Begin Opperating!")
    end
end

local function ForStart()
    local Started = AviationFramework:FindFirstChild("Started")
    assert(Started and Started.Value == true, "Aviation Hasn't Been Started Yet!")
end


function Aviation.Await()
    --// Waits Util The Framework Is Started \\--
    --// Helps To Prevent Errors By Waiting For Setting Up \\--

    repeat
        task.wait()
    until
        AviationFramework:FindFirstChild("Started") and AviationFramework.Started.Value == true
end


function Aviation.new(Player)
    --// Function Used To Create An Aviation Object For The Player \\--
    --// Action Can Only Be Performed Via The Server \\--

    ForStart()

	Location(true)
	assert(Player, "Argument[1], Player Is Invalid!")
    
    local function Folder()
        --// Build Folder For Player \\--
        --// Remote Communication Folder \\--

        local RemoteConnections = Instance.new("Folder")

        RemoteConnections.Name = "Remote-Connections"
        RemoteConnections.Parent = Player

        return RemoteConnections
    end

    local PlayerFolder = Folder()

	return setmetatable({
        Player = Player;
        Instance = PlayerFolder;
        Remotes = {};
        ViderObject = Vider:Debute(Player, PlayerFolder); --// Garbage Collector
    }, Aviation)
end


function Aviation:NewRemote(Name, RemoteName)
    --// Creates A Brand New Remote Communication Object \\--
    --// This Action Can Only Be Perfomed On The Client \\--

    --// Optional Paramete Remote Name; \\--
    --// This Function Should NOT Be Called Manually; Might Cause Some Loopholes \\---

	Location(true)
	assert(type(Name) == "string", "Argument[1] Name; Is NOT Of Type ::string::!")

    --// Creates A Remote Communication Object ::RemoteFunction:: \\--
	local RemoteFunction = Instance.new("RemoteFunction")
	RemoteFunction.Name = RemoteName or "PROTECTED REMOTE CONNECTION"

    self.ViderObject:AjouteAutre(RemoteFunction) --// Garbage Collection

    --// Creation Of Class Object \\--
    --// IMPORTANT! - Player && Instance
    local RemoteObject = setmetatable(
        {
            Name = Name;
            Player = self.Player;
            Instance = RemoteFunction;
            ServerFunction = nil;
        }, RemoteFunctions)

    self.Remotes[Name] = RemoteObject
    RemoteFunction.Parent = self.Instance

	return RemoteObject
end

function Aviation:DestroyRemote(Name)
    --// Destroys A Remote Object \\--
    --// Not Recommended As RemoteObject Should Have A Presized Goal For Being Created \\--
    --// Searches For Remote Object Based On The Name \\--

    --// Action Can Only Be Performed By The Server \\--
    Location(true)
    assert(type(Name) == "string", "Argument[1] Name; Is NOT Of Type ::string::!")

    --// Success Is Used To Confirm That The Object Has Been Destroyed \\--

    local Success = false
    if self.Remotes[Name] then
        --// Calls The Inner Destruction Method \\--
        self.Remotes[Name]:Destroy()
        Success = true
    else
        warn("Attempting To Destroy A Non Existing RemoteObject: `" .. tostring(Name) .. "`!")
    end

    return Success
end


--// Get Remote Object Methods \\--
function Aviation:HasRemote(Name)
    --// Verifies Wether The Aviation Object Has The Remote Object \\--
    --// Returns True If Yes And False If Couldn't Find \\--

    --// Action Can Be Performed Via The Server And The Client \\--
    assert(type(Name) == "string", "Argument[1] Is Not Of Type ::string::!")

    return (type(self.Remotes[Name]) == "table")
end

function Aviation:GetRemote(Name)
    --// Returns The Remote Object \\--
    --// This Should Be The Only Way To Get A Specific Remote Object \\--

	Location(true)
	assert(Name, "Argument[1], Name Is Invalid!")
    assert(self:HasRemote(Name), "Attempt To Request For An Invalid Remote Object! NAME `" .. Name .. "`")

	local RequestedRemote = self.Remotes[Name]

	if not RequestedRemote then
        --// Safety Measure, Will Likely Not Occur \\--
        warn("Remote " .. Name .. " Couldn't Be Found!")
        return
    end

	return RequestedRemote, RequestedRemote.Instance
end

function Aviation:RequestAllRemotes()
	--// This Function Returns All The Remotes \\--
	--// Action Can Only Be Performed Via The Server \\--

    --// Should Generally Not Be Fired \\--

	Location(true)
	return self.Remotes
end


--// Correct Creation Method \\--

function Aviation:FromList(List)
    --// This Is The Correct Way To Create A Remote Object \\--
    --// This Function Is Preferred To Be Fired Only ONCE \\--

    --// Can Only Be Done Via The Server \\--

	Location(true)
	assert(typeof(List) == "table", "List Provided Is Not Of Type ::table::!")

    --// Loops Through All Elements And Create Remote Object Accordingly \\--
    --// Also Attaches Functions To Remote Object If Specified \\--
    --// Good Pratice: Specify The Function To Be Attached \\--

	for Index, Value in pairs(List) do
		if type(Index) == "string" then
			--// Is A String And Has A Function To Bind With \\--
            --// Creation Of Remote Object \\--
			local RemoteObject = self:NewRemote(Index)

            if type(Value) == "function" then
                --// Attaches A Function \\--
                RemoteObject:BindToServer(Value)
			end	
		elseif type(Value) == "string" then
			--// No Functions To Bind \\--
            --// Just Creates \\--
			self:NewRemote(Value)
		end
	end
end

--// Serialisation \\--
function Aviation:Process()
    --// Action Can Only Be Perfomed Via The Server \\--
    --// Process The Object To The Archiver \\--

    --// Can Only Be Done When The Framework Has Started \\--
    ForStart()
	Location(true)

	--// Saves A New Style Of Structure \\--
	AviationFramework:WaitForChild("CommunicationUnit"):WaitForChild("ProcessData"):Fire(RequestObject.Format(self))
end

--// Requesting Unit \\--
function Aviation.RequestModule()
    --// Rarely Used \\--
	return RequestObject
end

function Aviation.Structure(Player)
    --// Formats The Structure \\--
    --// Returns A Stable Structure Similar To The Original \\--
    ForStart()
	local RequestingUnit = Aviation.RequestModule()
	local CommunicationUnit = AviationFramework:WaitForChild("CommunicationUnit")

    local RequestData = CommunicationUnit:WaitForChild("RequestData")
    local RequestServer = CommunicationUnit:WaitForChild("RequestServer")

	if IsClient then
		Location(false)
        
		local SelfStructure = RequestData:InvokeServer()
		return RequestingUnit.StructureFormat(SelfStructure)
	elseif IsServer then
		Location(true)
		assert(Player, "Argument[1], Player Is Invalid!")
		
		local SelfStructure = RequestServer:Invoke(Player)
		return RequestingUnit.StructureFormat(SelfStructure)
	end
end

return Aviation