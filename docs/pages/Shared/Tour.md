
# Tour to Aviation

## Contains a concrete example of Aviation and how to properly use it on the Client and the Server.
The examples below do not demonstrate it's full usage and functions but just a quick overview of how you'd use it.


> Server Code

The code below demonstrates the usage of RemoteObjects, creation of RemoteObjects, binding functions to them and the usage of signals.

```lua
--// Aviation Remote Server RunTime \\--

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")


local Aviation = require(ReplicatedStorage:WaitForChild("Aviation"))
local Signal = Aviation.Signal

Aviation.Start() --// Should only be called ONCE


local FriedaSignal = Signal.Wrap(function(Message)
    --// Creates a signal and feeds it a function
    print(Message)
end)

--// Remote list can just be in a Module, containing all the Remotes
--// It helps to create multiple remotes at 1 time
local RemoteList = {
    -- NAME: FUNCTION

    FriedaRemote = function(Player, CustomMessage)
        FriedaSignal:Fire(CustomMessage)
    end;
    "Messenger"
}


Players.PlayerAdded:Connect(function(Player)
    Aviation.Await() -- Everything is loaded


    local PlayerObject = Aviation.new(Player, "Relative~Remote~Name")
    PlayerObject:FromList(RemoteList)


    PlayerObject:Process() --// MUST Process after remotes are created


    task.wait(5)
    local ClientReply = PlayerObject:GetRemote("Messenger"):FireClient("Hello world from Aviation!")

    print("The Client Said", ClientReply)
end)
```

> Client Code

Demonstration of how to use Aviation on the client. Uses `:Securise` which helps to make your RemoteObjects exploit proof and not changeable. 
Features used in the Client Code: 

+ Securing RemoteObjects.
+ Attaching functions to RemoteObjects.
+ Firing RemoteObjects.

```lua
--// Main Client Runtime \\--
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")


local Aviation = require(ReplicatedStorage:WaitForChild("Aviation"))
Aviation.Await()


local PlayerStructure = Aviation.Structure()
PlayerStructure:Securise() -- To be run once on the main client runtime


PlayerStructure:FromStructure{
    Messenger = function(Message)
        print(Message)
        return "Woah, that's interesting!"
    end,
}

PlayerStructure:GetRemote("FriedaRemote"):FireServer("Is it fun?")
```