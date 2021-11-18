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
This is a basic Boilerplate for the AviationRuntime -> Runtime Server
```lua
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Aviation = require(ReplicatedStorage:WaitForChild("Aviation"))
Aviation:Start() --// Starts the Aviation Framework

local RemoteTable = {
    "Example" = function(Player, ...)
        --// This function will be called When the Client fires the example remote \\--
        print(Player.Name .. " Fired Example 1")
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
    
    PlayerRemote:Process() -> All player remote should be processed as soon the functions are attached
    --[[
        Creating new remotes outside this script will require the PlayerRemote to be Processed again!
        It's a bad behaviour to create RemoteObjects outside of the RunTime Script.
    ]]--
end)
```

> Creation of RemoteObject
```lua
    --// Remote Objects can also be create like this instead of the table manner \\--
    local Example3 = PlayerRemote:CreateRemote("Example3")
```

> Binding of Function

```lua
    --// Beside the table way, function can be binded to RemoteObjects in a way demonstrated below \\--
    
    Example2:BindToServer(function(Player, Message)
        print("Example2" .. tostring("Message"))
    end)
    
    --[[
        You can also attach a function separately to the RemoteObject,
        does the same thing as if you had mentioned the function in RemoteTable.
    ]]--
```
> Other ServerScript

Often times, you won't be using the RunTime code to host all your code, that's exactly why we need a way to get the PlayerRemote from other scripts

```lua
    --// This way works both both on the server and the client \\--
    Aviation.Structure(Player)
    --[[ 
    Note: The Player argument is passed only when it's on the Server,
    if you're running this code on the Client, you don't need to pass the Player.
    ]]--
```

Futher notes, you can destroy RemoteObject by calling their Destroy function. `RemoteObject:Destroy`

If you created a RemoteObject or binded a function to in on the Server, it's essential to Process the Player's Remote again. `PlayerRemote:Process`

You can check wether a RemoteObject exists or not. `PlayerRemote:HasRemote()` -Works on the Client & Server

---

## Client Usage

On the Client, you're required to have a main Client `Runtime`.
To get the Player's Structure simple do `local PlayerRemote = Aviation.Structure()`

After obtaining the Player's Structure make sure to Securise it. `PlayerRemote:Securise()`  Securise ensures that the RemoteObjects are well protected on the Client and changes by the Client that make them more vulnerable to exploits is prevented.

> Client Boilerplate

```lua
    local Aviation = require(game:GetService("ReplicatedStorage"):WaitForChild("Aviation"))
    Aviation:Await()
    
    wait(.2) --// Waits for the Player's structure "PlayerRemote" to be processed 
    local PlayerRemote = Aviation.Structure()
    PlayerRemote:Securise() --// Should only be done once by the Client
    
    local FunctionTable = {
        Example3 = function()
        --// This Function will be fired when the Server invokes the Client
            print("Hello World From The Server")
        end;
    }
    PlayerRemote:FromStructure(FunctionTable) --// Same as :FromList on the Server
    
    local Example = PlayerRemote:GetRemote("Example") --// Gets The Requested Remote 
    Example:FireServer()
```

You can also manually bind client function to the RemoteObject using this method instead of the FunctionTable method.

```lua
    local Example3 = PlayerRemote:GetRemote("Example3")
    
    Example3:BindToClient(function()
        --// This Function will be fired when the Server invokes the Client
            print("Hello World From The Server")
    end)
```

`.Structure` can be called on all the Client and ServerScripts. 

---

## Invoking Server And Client

This is probably the most important part and the simplest. To fire the Client we simple do `RemoteObject:FireClient(Arguments)` and to fire the Server, `RemoteObject:FireServer(Arguments)`. Note that you do not have to pass the Player as argument in them!

> **FireAll**

`FireAll` is a method can be performed on the Server which takes a Remote name as first argument and other arguments and fires all the Clients remote which returns a dictionary of all the values returned by each corresponding Clients. It's generally recommended to run this function in a PCall or avoid using it.

Usage

```lua
local Aviation = require(ReplicatedStorage:WaitForChild("Aviation")
Aviation:Await()

local ReturnedValues = Aviation:FireAll("Example3", Arguments...)

--// This method is called directly on Aviation \\--
```
**Return DictionaryFormat: {PlayerName = { Retured Values} }**

---

## @ Contact Me

If ever you spot any bugs or problems please DM me on Discord `ImportLua#9522` or [Twitter](https://twitter.com/LuaImport), thank you for using my Framework!

[Github Repository](https://github.com/Frieda-VI/Aviation)
