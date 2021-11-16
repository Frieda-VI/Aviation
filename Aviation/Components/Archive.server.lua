
--// Archive Script \\--
--// By Frieda_VI \\--

--// Script In Charge Of Archiving Structures \\--
--// Also Works As A Cleaner \\--

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Aviation Variables And Statics \\--
local Manager = ReplicatedStorage:WaitForChild("Aviation")
local CommunicationUnit = Manager:WaitForChild("CommunicationUnit")

local ProcessData = CommunicationUnit:WaitForChild("ProcessData")
local RequestData = CommunicationUnit:WaitForChild("RequestData")
local RequestServer = CommunicationUnit:WaitForChild("RequestServer")

--// Archiver \\--
local Archiver = {}

--// Key Should NEVER Change In Game! \\--
local String = "SECURED_"

--// Function \\--

local function Remove(Player)
    --// Garbage Collector \\--
	if Archiver[String .. Player.UserId] then
		Archiver[String .. Player.UserId] = nil
	else
		warn("Archieve Information Doesn't Exist:", Player.UserId, Archiver)
	end
end

local function Post(Player)
	assert(Player, "Player Is Invalid")

	if Archiver[String .. Player.UserId] then
		local PlayerArchive = Archiver[tostring(String .. Player.UserId)]
		return PlayerArchive
	end
	
	return
end

ProcessData.Event:Connect(function(Structure)
	local Player = Structure.Player
	Archiver[String .. Player.UserId] = Structure
end)

RequestData.OnServerInvoke = Post
RequestServer.OnInvoke = Post
Players.PlayerRemoving:Connect(Remove)