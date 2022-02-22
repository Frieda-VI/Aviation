--// Main Module \\--

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Aviation = {}
Aviation.__index = Aviation

function Aviation:Init()
	assert(RunService:IsServer(), "Initiation of Aviation is only supported on the server!")
	assert(script.Parent == ReplicatedStorage, "Aviation must be parented to ReplicatedStorage")

	print("Begin Aviation")
end

return Aviation
