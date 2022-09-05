
# Shared Functions

> What are Shared Functions 
Shared functions are functions which are available on both the server and client, but they might not function the same.

## Await

The `.Await()` method is an incontournable function which can be used by the server or client. To avoid errors, you should __ALWAYS__ use the `.Await()` before making your first reference to functions concerning Aviation.

```lua hl_lines="2"
local Aviation = require(ReplicatedStorage:WaitForChild("Aviation"))
Aviation.Await()
```

---

## Retriving PlayerObject

To obtain the *PlayerObject* on another ServerScript that's not the Runtime or a LocalScript, we use `.Structure()` on Aviation. Since the *PlayerObject* has lost some of it's core functionality, we can call it **PlayerStructure**.

=== "Server"
    ```lua hl_lines="2"
    local Aviation = require(ReplicatedStorage:WaitForChild("Aviation"))
    local PlayerStructure = Aviation.Structure(Player) -- The Player must be provided
    ```

=== "Client"
    ```lua hl_lines="2-3"
    local Aviation = require(ReplicatedStorage:WaitForChild("Aviation"))
    local PlayerStructure = Aviation.Structure() -- Will yield unless if you send a false as argument
    local PlayerStructure1 = Aviation.Structure(false)
    ```

## Getting RemoteObject

The `:HasRemote` is a method than can be called on the PlayerObject to ensure that a certain RemoteObject is present or not. `HasRemote` takes the argument of the RemteObject name and returns a boolean confirming wether the RemoteObject exists or not.

This function can be used on both the initial *PlayerObject* or the *PlayerStructure*. The `:GetRemote()` method takes the RemoteObject's name as argument and returns the RemoteObject. This code can be used by both the Server (initial runtime or random ServerScript) and the Client.

```lua hl_lines="2-3"
local PlayerStructure = Aviation.GetStructure(Player)
local Messenger = PlayerStructure:GetRemote("Messenger")
local FriedaRemote = PlayerStructure:GetRemote("FriedaRemote")
```

## Firing the Server | Client

Firing the Server or Client is as simple as saying `RemoteObject:FireClient(Args)` or `RemoteObject:FireServer(Args)`, the fire methods can be given any arguments and will return data sent by the Server|Client. The `:FireClient()` method does NOT need the Player to be sent as an argument.


=== "Server"
```lua
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Aviation = require(ReplicatedStorage:WaitForChild("Aviation"))
    Aviation.Await()

    local PlayerStructure = Aviation.Structure(Player) -- The Player


    local ClientReply = PlayerStructure:GetRemote("Messenger"):FireClient("Hello world from Aviation!")
    print("The Client Said", ClientReply)
```
=== "Client"
```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Aviation = require(ReplicatedStorage:WaitForChild("Aviation"))
Aviation.Await()

local PlayerStructure = Aviation.Structure()
PlayerStructure:Securise()

PlayerStructure:GetRemote("FriedaRemote"):FireServer("Is it fun?") -- Can return a Value
```
