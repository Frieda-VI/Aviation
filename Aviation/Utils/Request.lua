--//       Process Aviation Related Objects     \\--
--//  Formats Data So That Aviation Can Read it  \\--
--//                 By Frieda_VI                 \\--

--// Core Service \\--
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")


local ProcessFunctions = {} --// Main Container
ProcessFunctions.__index = ProcessFunctions


local Aviation = ReplicatedStorage:WaitForChild("Aviation")

local Utils = Aviation:WaitForChild("Utils")
local RemoteFunctions = Utils:WaitForChild("RemoteFunctions")


local Vider = require(Utils:WaitForChild("Vider"))

local ClientFunction = require(RemoteFunctions:WaitForChild("ClientFunction"))
local ServerFunction = require(RemoteFunctions:WaitForChild("ServerFunction"))


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

--// Aviation Inherrited Functions \\--
function ProcessFunctions:HasRemote(Name)
	assert(type(Name) == "string", "Argument[1] Is Not Of Type ::string::!")
	return (type(self[Name]) == "table")
end

function ProcessFunctions:GetRemote(Name)
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
function ProcessFunctions:Securise(ExploitingMessage)
	--// This Action Can Only Be Done Via The Client \\--
	--// Should ONLY Be Done Once Per Object By The Client Runtime \\--

	--// Also Helps To Prevent Memory Leakage Via Vider Object \\--
	--// Helps To Keep The RemoteInstances Exploit Proof \\--

	Client()
	local Players = game:GetService("Players")
	local Player = Players.LocalPlayer

	local KickMessage = ExploitingMessage or "You are suspected of cheating!"

	for _Index, Remote in pairs(self) do
		local INSTANCE = Remote.Instance

		if not Instance then
			--// Skips This Iteration If The Remote Doesn't Have An Instance \\-
			continue
		end

		--// RBLXConnections \\--
		local NameChanges = INSTANCE:GetPropertyChangedSignal("Name"):Connect(function()
			--// This Will Be Fired If The Name Of The RemoteInstance Changes \\--

			Player:Kick(KickMessage)
		end)
		local DescendantAdded = INSTANCE.DescendantAdded:Connect(function()
			--// This Will Be Fired If An Object Is Parented To The RemoteInstance \\--

			Player:Kick(KickMessage)
		end)
		local ParentChanges = INSTANCE.AncestryChanged:Connect(function(_, Parent)
			if typeof(Parent) == "Instance" then
				--// This Will Fire If The Parent Of The Remote Instance Is Changed [Not When Object Is Destroyed] \\--

				Player:Kick(KickMessage)
			end
		end)
		local AttributeChanges = INSTANCE.AttributeChanged:Connect(function(_AttributeName)
			--// This Will Fire When An Attribute Is Given To The RemoteInstance \\--

			Player:Kick(KickMessage)
		end)

		--// Binding To Vider Object \\--
		local ViderObject = Vider:Debute(INSTANCE, NameChanges, DescendantAdded, ParentChanges, AttributeChanges)
		ViderObject:AjouteMain(Player)
	end
end






--// Unique Functions \\--
function ProcessFunctions.Format(Structure)
	--// This Format Should NOT Be Use By The Server Runtime \\--
	--// This Function Creates A More Suitable Version For Storing The Aviation Object \\--

	--// Contains Less Details Than The Original \\--
	Server()

	local Player = Structure.Player
	local Remotes = Structure.Remotes
	local Collapser = Structure.Collapser

	local NewStructure = {}
	NewStructure.Player = Player
	NewStructure.Remotes = Remotes
	NewStructure.Collapser = Collapser

	return NewStructure
end


--// Server Only Method \\--
if IsServer then

	--// This Is A Direct Brought Down Of Aviation From Init Module Script \\--



	--// Sets The Collapse Method For The Server Section \\--
		function ProcessFunctions:Collapse(TypeIndex)
		--// This Function Is Only Meant To Be Called When The Player Is Leaving The Game \\--
		--// Should Be In The `Player.OnLeaving` Method \\--

		--// TypeIndex Can Either Be A Boolean Or A String \\--

		--// If The Boolean Option Is Chosen, The TypeIndex Should Always Equal To True \\--
		--// The Boolean Option Will Call All The Collapser Methods \\--

		--// Boolean :: String \\--

		--// If The String Option Is Chosen, The TypeIndex Should Indicate An Index Leading To A Collapser Method \\--
		--// This Option Ensures That Only One Collapser Is Called, Based On The String Provided \\--


		local ReturnedValues = {} --// A Dictionary Which Keeps Track Of All The Returned Values \\--
		--// ReturnedValues Stores Returned Valued With The TypeIndex \\--
		--// { TypeIndex = { Value1, Value2 } } \\--


		--// The Player The Only Parameter Passed \\--

		if type(TypeIndex) == "boolean" and TypeIndex == true then
			--// Boolean Option \\--
			for _Index, Function in pairs(self.Collapser) do
				--// Loops Through All The Collapsers And Fires Them Individually \\--
				--// Note: No Collapser Method Should EVER Yeild! \\--

				if type(Function) == "function" then
					--// Uses Coroutine To Assume Smooth Running \\--
					--// As Well As Passes The Player `self.Player` As Parameter \\--
					ReturnedValues[TypeIndex] = { coroutine.wrap(Function)(self.Player) }
				else
					--// Safety Precaution But It Shouldn't Ever Happen \\--
					warn("The Function Provided Is Not Of Type ::function::!")
					continue
				end
			end

		elseif type(TypeIndex) == "string" and type(self.Collapser[TypeIndex]) == "function" then
			--// Selects A Specific Collapser Based On The Index \\--
			--// Provides Only One Argument, That Is The Player \\--

			ReturnedValues[TypeIndex] = { coroutine.wrap(self.Collapser[TypeIndex])(self.Player) }

			--// A Unique Function Only Available To The String Option \\--
			function ReturnedValues.Get(Index)
				Index = Index or 1 --// The First Element \\--
				return ReturnedValues[TypeIndex][Index]
			end
		else
			warn("The Function Provided Is Not Of Type ::function::!")
		end


		return ReturnedValues
	end
end



function ProcessFunctions.StructureFormat(FormatedStructure)
	--// This Function Reconstructs The Archiver Formated Version To A More Details \\--
	--// Used Both By The Server And The Client \\--
	local NewStructure = setmetatable({}, ProcessFunctions)

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

			local ToBind = IsServer == true and ServerFunction or ClientFunction
			local self = setmetatable({}, ToBind)

			self.Instance = INSTANCE
			self.Name = Index
			self[FunctionType] = FUNCTION

			if IsServer then
				self.Player = FormatedStructure.Player
			end

			NewStructure[Index] = self
		end
	end

	--// Setting Up The Collapser Section \\--
	--// A Cross Server Only Feature \\--
	if IsServer then
		NewStructure["Player"] = FormatedStructure.Player
		NewStructure["Collapser"] = FormatedStructure.Collapser
	end

	return NewStructure
end




--// Equivalent To FromList In Aviation \\--
--// Client Version \\--
function ProcessFunctions:FromStructure(List)
	Client()
	ASSERT(type(List) == "table", "Structure (List)")

	for Index, Value in pairs(List) do
		if typeof(Index) == "string" and type(Value) == "function" then
			local Remote = self:GetRemote(Index)
			assert(Remote, "Remote " .. Index .. " Is Invalid! HasRemote: " .. tostring(self:HasRemote(Index)))

			--// Binding \\--
			Remote:BindToClient(Value)
		else
			warn(
				"Invalid Dictionary Elements, RemoteName: "
					.. tostring(Index)
					.. ", Function To Bind:"
					.. tostring(Value)
			)
		end
	end
end


return ProcessFunctions
