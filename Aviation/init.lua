
--//                 Aviation Version 4                 \\--
--// This Is A Custom Remote Framework By Frieda_VI#9522 \\--


--// Top Level Service By Roblox \\--
local RunService = game:GetService("RunService")


local Aviation = {}
Aviation.__index= Aviation


--// Aviation Self, Helps To Allocate Important Utils And Other Files \\--
local AviationFramework = script


local Utils = AviationFramework:WaitForChild("Utils")
local RemoteFunctions = Utils:WaitForChild("RemoteFunctions")

--// Requires Important Utils That Are Very Important For The Proper Function Of Aviaition \\--
--// Vider - Custom Janitor | RemoteFunctions - Inherrited By All Remote Objects \\--
local Request = require(Utils:WaitForChild("Request"))
local Signal = require(Utils:WaitForChild("Signal"))
local Vider = require(Utils:WaitForChild("Vider"))


--// Client Function and Sever Function Contains Core Functions For The Remote Object \\--
--local ClientFunction = require(RemoteFunctions:WaitForChild("ClientFunction")) [[Used By Request.lua]]
local ServerFunction = require(RemoteFunctions:WaitForChild("ServerFunction"))


--// References Used To Determine If Action Can Be Performed Or Not \\--
local IsClient = RunService:IsClient()
local IsServer = RunService:IsServer()


local function Location(Server)
    --// Function Which Checks The Run Location \\--

    --// Client Code Should NOT Be Execute By The Server And Vice-Versa \\--
    --// Server: Boolean -> true [Only Server], false|nil [Only Client]

    if Server then
        --// Highest Fedality Is To The Server \\--
        assert(IsServer == true, "This Action Can Only Be Performed Via The Server!")
    else
        --// Secondary Is The Client \\--
        assert(IsClient == true, "This Action Can Only Be Performed Via The Client!")
    end
end






local function _Build()
    Location(true)

    --//        Builds The Remote Communication Unit        \\--
    --// Contains Very Important RemoteCommunication Objects \\--


    local CommunicationUnit = Instance.new("Folder")
    CommunicationUnit.Name = "CommunicationUnit"

    --// Creation Of Core Communication Objects \\--

    local function Construct(Name, Type)
        --//            Inner Construction            \\--
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
    --// Builds An Contructs Core Components \\--
    Location(true)


    if not AviationFramework:FindFirstChild("Started") then
        --//                 Starts The Aviation                        \\--
        --// Started Is Used To Indicate If Aviation Is Activated Or Not \\--
        local Started = Instance.new("BoolValue")
        Started.Name = "Started"
        Started.Parent = AviationFramework

        Started.Value = false


        --// Specific Building \\--
        _Build()


        --// Archiver Building \\--
        local ServerScriptService = game:GetService("ServerScriptService")
        local Archive = Utils:WaitForChild("Archive")


        --// Concludes And Start \\--
        Archive.Parent = ServerScriptService
        Started.Value = true
    else
        --// Start Method Can Only Be Done Once \\--
        warn("Aviation Framework Has Already Begin Opperating!")
    end
end

function Aviation.Await()
    --// Waits Until The Framework Is Ready To Be Opperated On \\--
    --// Helps To Prevent Errors By Waiting For Proper Setting Up \\--

    --// Continious Repeating \\--
    repeat
        task.wait()
    until
        --// Can Resume \\--
        AviationFramework:FindFirstChild("Started") and AviationFramework.Started.Value == true
end






local function ForStart()
    --// Function Used To Determined If Aviation Can Be Opperated On \\--
    --// Core Component Function \\--

    local Started = AviationFramework:FindFirstChild("Started")
    assert(Started and Started.Value == true, "Aviation Didn't Start Running Yet!")
end


function Aviation.new(Player, RemoteName)
    --//                   Aviation Constructor                   \\--

    --// Function Used To Create An Aviation Object For The Player \\--
    --// Action Can Only Be Performed Via The Server \\--
    ForStart()


	Location(true) --// Server Action
	assert(typeof(Player) == "Instance" and Player:IsA("Player"), "Argument[1], Player Is Invalid!")

    RemoteName = RemoteName or "Remote-Object"


    local function Folder()
        --// Builds A Folder For The Player \\--
        --// Remote Communication Folder \\--

        local RemoteConnections = Instance.new("Folder")

        RemoteConnections.Name = "Remote-Connection"
        RemoteConnections.Parent = Player

        return RemoteConnections
    end
    local PlayerFolder = Folder()


	return setmetatable({
        Player = Player;

        Instance = PlayerFolder;

        ["RemoteName"] = RemoteName;
        Remotes = {};

        ViderObject = Vider:Debute(Player, PlayerFolder); --// Garbage Collector \\--
    }, Aviation)
end

--//    Serialisation    \\--
function Aviation:Process()
    --// Action Can Only Be Perfomed Via The Server \\--
    --// Process The Object To The Archiver \\--

    --// Can Only Be Done When The Framework Has Started \\--
    ForStart()
	Location(true)


	--// Saves A New Style Of Structure \\--
    local CommunicationUnit = AviationFramework:WaitForChild("CommunicationUnit")
    local ProcessData = CommunicationUnit:WaitForChild("ProcessData")


    --// Sends The Data To The Archiver \\--
	ProcessData:Fire(Request.Format(self))
end

function Aviation.Structure(Argument, Argument2)
    --//            Returns The Player Structure            \\--
    --// Returns An Object Structure Similar To The Original \\--

    ForStart()
	local CommunicationUnit = AviationFramework:WaitForChild("CommunicationUnit")

    local RequestData = CommunicationUnit:WaitForChild("RequestData")
    local RequestServer = CommunicationUnit:WaitForChild("RequestServer")


    local function Obtain(Value, Player)
        local SelfStructure
        local NoYeild = Value


        local Limited = false
        local InitialTime = 0
        local YeildNumber = 0
        local function ToRequest()
            if IsClient then
                return RequestData:InvokeServer()
            elseif IsServer and Player then
                return RequestServer:Invoke(Player)
            end
        end
        local function ToYeild()
            repeat
                task.wait(.25)
                SelfStructure = ToRequest()
            until
                --// Until SelfStructure Isn't Blank \\--
                --// OR \\--
                --// No Yeild Period \\--
                (SelfStructure and SelfStructure ~= {}) or (Limited and (tick() - InitialTime) >= YeildNumber)
        end


        if (type(NoYeild) == "number" and NoYeild == 0) or (type(NoYeild) == "boolean" and NoYeild == true) or (IsServer and (type(NoYeild) ~= "number") or (type(NoYeild) ~= "number" and NoYeild == 0) or not NoYeild) then
            --// Instant Request \\--
            --// Default Server \\--
            SelfStructure = ToRequest()
        elseif typeof(NoYeild) == "number" then
            --// Yeilds Until Item For A Given Amount Of Time \\--
            Limited = true
            InitialTime = tick()
            YeildNumber = NoYeild

            ToYeild()
        else
            --// Default Client \\--
            ToYeild()
        end


        return SelfStructure
    end

    if IsClient then
        --// This Function Yields By Default \\--
		Location(false)
        local PlayerStructure = Obtain(Argument)

		return Request.StructureFormat(PlayerStructure)
	elseif IsServer then
        --// Doesn't Yield By Default \\--
		Location(true)
		assert(Argument, "Argument[1], Player Is Invalid!")

		local PlayerStructure = Obtain(Argument2, Argument)
		return Request.StructureFormat(PlayerStructure)
	end
end






function Aviation:NewRemote(Name)
    --// Creates A Brand New Remote Communication Object \\--
    --// This Action Can Only Be Perfomed On The Client \\--

    --// Optional Paramete Remote Name; \\--
    --// This Function Should NOT Be Called Manually; Might Cause Some Loopholes \\---

	Location(true)
	assert(type(Name) == "string", "Argument[1] Name; Is NOT Of Type ::string::!")

    --// Creates A Remote Communication Object ::RemoteFunction:: \\--
	local RemoteFunction = Instance.new("RemoteFunction")
	RemoteFunction.Name = self.RemoteName or "Remote-Object"


    --self.ViderObject:AjouteAutre(RemoteFunction) --// Garbage Collection


    --// Creation Of Class Object \\--
    --// IMPORTANT! - Player && Instance
    local RemoteObject = setmetatable(
        {
            Name = Name;

            Player = self.Player;
            Instance = RemoteFunction;

            ServerFunction = nil;
        }, ServerFunction)

    self.Remotes[Name] = RemoteObject
    RemoteFunction.Parent = self.Instance


	return RemoteObject
end

function Aviation:DestroyRemote(Name)
    --// Destroys A Remote Object \\--
    --// Not Recommended As RemoteObject Should Have A Presized Goal To Be Created \\--
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


function Aviation:FireAll(Name, ...)
    --// This Method Is Responsible For Firing All Clients's Remote \\--
    --// This Action Can Only Be Done Via The Server \\--

    --// It's Not Really Recommended To Perform This Action Regularly! \\--
    --// Aviation Has To Be Started First \\--

    --// I'd Recommend Running This In A PCall Function \\--
    --// Generally It's NOT Recommended To Expect Anything To Return From This Function \\--

    Location(true)
    ForStart()

    --// Checking The Name To Prevent Server Errors \\--
    assert(typeof(Name) == "string", "Argument[1], Name Is NOT Of Type ::string::!")
    local Players = game:GetService("Players")

    --// Method - Obtain Each Player's Structure And Search For The Remote \\--
    --// Once The Remote Is Found, Fire The Client Else Just Ignore \\--

    local Returns = {} --// Stores Value Returned By The Each Clients Fired \\--

    for _Index, Player in pairs(Players:GetPlayers()) do
        --// Some Player Will NOT Have A Structure, So We Need To Be Very Careful And Check \\--
        --// PlayerStrucute Can Only Be A Table, That's The Best Way For Us To Verify \\--
        local PlayerStructure = Aviation.Structure(Player)

        --// Check \\--
        if type(PlayerStructure) == "table" and PlayerStructure:HasRemote(Name) then
            --// Firing The Remote And Storing The Value Returned \\--
            Returns[tostring(Player.Name)] = {PlayerStructure:GetRemote(Name):FireClient(...)}
        end
    end

    return Returns
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


Aviation.Signal = Signal

return Aviation