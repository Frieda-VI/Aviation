
--// Request Object Module \\--
--// By Frieda_VI \\--

--// Top Tier Services \\--
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

--// Statics \\--
local TransferFunctions = {}
TransferFunctions.__index = TransferFunctions

local Aviation = ReplicatedStorage:WaitForChild("Aviation")
local Components = Aviation:WaitForChild("Components")

local RemoteFunctions = require(Components:WaitForChild("Functions"))
local Vider = require(Components:WaitForChild("Vider"))

local IsClient = RunService:IsClient()
local IsServer = RunService:IsServer()

--// Basic Util Functions \\--
local function Client()
	assert(IsClient, "This Action Can Only Be Performed On The Client")
end

local function Server()
	assert(IsServer, "This Action Can Only Be Performed On The Server")
end

local function ASSERT(Variable, Name)
	assert(Variable, "Argument[" .. Name .. "]" .. "Is Invalid!")
end

--// Functions Used For Deserialise \\--

--// Aviation Inherrited Functions
function TransferFunctions:HasRemote(Name)
    assert(type(Name) == "string", "Argument[1] Is Not Of Type ::string::!")
    return (type(self[Name]) == "table")
end

function TransferFunctions:GetRemote(Name)
	assert(Name, "Argument[1], Name Is Invalid!")
    assert(self:HasRemote(Name), "Attempt To Request For An Invalid Remote Object! NAME `" .. Name .. "`")

	local RequestedRemote = self[Name]
	if not RequestedRemote then
        --// Safety Measure, Will Likely Not Occur \\--
        warn("Remote " .. Name .. " Couldn't Be Found!")
        return
    end

	return RequestedRemote, RequestedRemote.Instance
end

--// Exploit Protection \\--
function TransferFunctions:Securise()
    --// This Action Can Only Be Done Via The Client \\--
    --// Should ONLY Be Done Once Per Object By The Client Runtime \\--
    Client()
    local Players = game:GetService("Players")
    local Player = Players.LocalPlayer

    for _Index, Remote in pairs(self) do
		local INSTANCE = Remote.Instance

		if not Instance then
			--// Skips This Iteration If The Remote Doesn't Have An Instance \\-
			continue
		end
        local ViderObject = Vider:Debute(INSTANCE, INSTANCE:GetPropertyChangedSignal("Name"):Connect(function()
            Player:Kick("You Were Suspected Of Cheating!")
        end))
        ViderObject:AjouteMain(Player)
    end
end

--// Unique Functions \\--
function TransferFunctions.Format(Structure)
	--// This Format Should NOT Be Use By The Server Runtime \\--
    --// This Function Creates A More Suitable Version For Storing The Aviation Object \\--

    --// Contains Less Details Than The Original \\--
	Server()
	
	local Player = Structure.Player
	local Remotes = Structure.Remotes
	
	local NewStructure = {}
	NewStructure.Player = Player
	NewStructure.Remotes = Remotes
	
	return NewStructure
end

function TransferFunctions.StructureFormat(FormatedStructure)
    --// This Function Reconstructs The Archiver Formated Version To A More Details \\--
    --// Used Both By The Server And The Client \\--
	local NewStructure = setmetatable({}, TransferFunctions)
	
	for Index, Value in pairs(FormatedStructure.Remotes) do
		if type(Value) == "table" then
            --// Creation Of Remote Objects \\--
			local INSTANCE = Value["Instance"]

            --// Sets The Function Based On The Location \\--
            --// Sets The Function Type \\--
            local FUNCTION, FunctionType
            if IsServer then
                FunctionType = "ServerFunction"
                FUNCTION = Value["ServerFunction"]
            elseif IsClient then
                FunctionType = "Client"
                FUNCTION = Value["ClientFunction"]
            end
			
			local self = setmetatable({}, RemoteFunctions)

			self.Instance = INSTANCE
			self.Name = Index
			self[FunctionType] = FUNCTION

			if IsServer then
				self.Player = FormatedStructure.Player
			end
			
			NewStructure[Index] = self
		end
	end
	
	return NewStructure
end

--// Equivalent To FromList In Aviation \\--
--// Client Version \\--
function TransferFunctions:FromStructure(List)
	Client()
	ASSERT(type(List) == "table", "Structure (List)")
	
	for Index, Value in pairs(List) do
		if typeof(Index) == "string" and type(Value) == "function" then
			local Remote = self:GetRemote(Index)
			assert(Remote, "Remote " .. Index .. " Is Invalid! HasRemote: " .. tostring(self:HasRemote(Index)))
			
            --// Binding \\--
			Remote:BindToClient(Value)
		else
			warn("Invalid Dictionary Elements, RemoteName: " .. tostring(Index) .. ", Function To Bind:" .. tostring(Value))
		end
	end
end

return TransferFunctions