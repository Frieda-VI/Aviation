# The Aviation Framework

This is the Aviation Framework for Roblox which helps to keep communication between client and server and vice versa organised and well maintained. Also known as 'hypixel26's Custom RemoteFramework'.

## Installation Process

Installing Aviation for your ROJO project is quite simple. 

>**VSC & Rojo workflow:**

1. Add The Aviation Folder to your project
1. Use Rojo to point the Aviation to ReplicatedStorage.

[Pointing to ReplicatedStorage](https://github.com/Frieda-VI/Aviation/blob/main/default.project.json)

>**Roblox workflow**
1. Get [Aviation](https://www.roblox.com/library/8014570440/Aviation-V1) from the Roblox Library.
2. Place directly within ReplicatedStorage.

## Basic Usage
Aviation aims at not disturbing your scripting style. Thus Aviation tries to keep stuff as simple as it can possible get..

The most basic usage would look as such:
```lua
--// Server \\--
local Aviation = require(ReplicatedStorage:WaitForChild("Aviation"))
Aviation:Start()
Aviation:Await()
--// The Start method should only be fired once by the server in order to start the Framework \\--
--[[
    The Await method yeilds until Aviation is Started by the Server.
     It helps to prevent errors..
]]--
```

```lua
--// Client \\--
local Aviation = require(ReplicatedStorage:WaitForChild("Aviation"))
Aviation:Await()
--// The Await method can be called by both the Server and the Client \\--
```

---
## Server Usage
This is a basic Boilerplate for the AviationRuntime -> Server
```lua
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Aviation = require(ReplicatedStorage:WaitForChild("Aviation"))
Aviation:Start() --// Starts the Aviation Framework

local RemoteTable = {
    "Example" = function(Player, ...)
        --// This function will be called When the Client fires the example remote \\--
    end;
    "Example2"
    --[[
    If The Value Attached To An Index Isn't A Function,
    A RemoteOject Will Be Created With Not Functions Attached.
    ]]--
}

Players.PlayerAdded:Connect(function(Player)
    Aviation:Await()
    local PlayerRemote = Aviation.new(Player)
    --.new -> Creates an aviation object
    PlayerRemote:FromList(RemoteTable) -> Creates remote object and attaches a function to them if they had one
    
    local Example2 = PlayerRemote:GetRemote("Example2") -> Returns the RemoteObject requested
    Example2:BindToServer(function(Player, Message)
        print("Example2" .. tostring("Message"))
    end)
    --[[
        You can also attach a function separately to the RemoteObject,
        does the same thing as if you had mentioned the function in RemoteTable.
    ]]--
    
    PlayerRemote:Process() -> All player remote should be processed as soon the functions are attached
    --[[
        Creating new remotes outside this script will require the PlayerRemote to be Processed again!
        It's a bad behaviour to create RemoteObjects outside of the RunTime Script.
    ]]--
end)
```
