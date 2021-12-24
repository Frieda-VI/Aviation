
# Server Functions of Aviation


## Basic Configuration

Server scripts using *Aviation* should require and `.await()` until it starts. You would usually want to dedicate an entire server script just for the creation of RemoteObjects and in that script, you should call the `.Start()` method on *Aviation*.

``` lua hl_lines="5 6"
--// Aviation runner dedicated to creating RemoteEvents \\--
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Aviation = require(ReplicatedStorage:WaitForChild("Aviation"))
Aviation.Start()
```

The `.Start()` method should only be called ONCE by a ServerScript. It's meant to initialise core compoenents of Aviation and to get it to run thus marking it's name to **start**.

``` lua hl_lines="3"
--// Random Server Script \\-- 
local Aviation = require(ReplicatedStorage:WaitForChild("Aviation")) 
Aviation.Await()
```

All ServerScripts using Aviation SHOULD call the `.Await()` function on Aviation to ensure that everything has been correctly loaded. The *Await* method will yield until the *Start* method has been called on Aviation by a ServerScript.


## RemoteObject Creation

RemoteObjects are two way conversation objects meaning they inherrit from *RemoteFunctions* directly. The creation of RemoteObjects should be wrapped by the `.PlayerAdded` event, and it is one of the most important features that the Server provides.The examples below assumes that we are using the code above demonstrating how to *start* Aviation

In order to creat RemoteObjects, we need an AviationObject on which RemoteObject creation can be performed.

### AviationObject Creation

`Aviation.new()` takes 2 arguments, the Player and an optional argument which consists of the Remote name that will be used by all the *RemoteFunction* instance. The Aviation constructor (`Aviation.new()`) returns an AviationObject(PlayerObject).
Right after creating and attaching functions to the `AviationObject`|`PlayerObject`, you're required to call the `:Process()` method on the AviationObject to ensure that it's processed and can used by the client.

Since the *AviationObject* is dedicated to a Player, we can call it a **PlayerObject**. 


``` lua hl_lines="4 8"
    Players.PlayerAdded:Connect(function(Player)
        Aviation.Await() --// Await is used to make sure that Aviation has begin operating

        local PlayerObject = Aviation.new(Player, "Secured-RemoteObject")

        --// CREATION OF REMOTEOBJECTS \\--

        PlayerObject:Process()
    end)
```

### Creating RemoteObject

Now that we have our *PlayerObject*, we can begin creating remotes which should be done before processing `PlayerObject:Process()` the *PlayerObject*.

The method demonstrated below is a primitive method, and is not recommended to be used directly but it is important to learn how Aviation functions in order to properly use it. Later on you will learn about a more efficient method at creating *RemoteObjects* and attaching functions to them. The `:CreateRemote()` method takes the Remote's name as argument and returns a RemoteObject, which functions can be attached to. The code below assumes that you're using the codes above to create the *PlayerObject*.

``` lua hl_lines="1"
    local FriedaRemote = PlayerObject:CreateRemote("FriedaRemote")

    PlayerObject:Process()
```

### Attaching Functions

Not all *RemoteObjects* will have functions attached to them as some will be used to __Invoke__ the client. The method demonstrated is a primitive way to attach functions to remotes is not very efficient when used as such but it can still be used sometimes. `:BindToServer()` methods takes in a function and feed it the Player as the first argument, and all the arguments provided by the client. *RemoteObjects* are two way communication devices, meaning they can `return` data back to the client.

> All functions MUST be attached to their RemoteObjects before processing the *PlayerObject*.

``` lua hl_lines="2-5"
    local FriedaRemote = PlayerObject:CreateRemote("FriedaRemote")
    FriedaRemote:BindToServer(function(Player, ...)
        print("Frieda Remote was invoked by " .. Player.Name, ...)
        return true
    end)

    PlayerObject:Process()
```

### Create & Attach

The way to create RemoteObjects and attach functions to them below is the most efficient and recommended way. *RemoteList* is a table, you can have create RemoteObjects and attach functions to them all in a module and provide it to the *PlayerObject* to consume. 

The `:FromList()` method takes the *RemoteList* as argument and construct *RemoteObjects* based on the list provided and should be called before processing the PlayerObject. The *RemoteList* is a table"Dictionary", all the __indexes__ are RemoteObject's name and __values__ are functions that are going to call when the RemoteObject is fired, which is an optional field.

```lua hl_lines="1-7 14"
local RemoteList = {
    FriedaRemote = function(Player, ...)
        print("Frieda Remote was invoked by " .. Player.Name, ...)
        return true
    end);
    "Messenger"
}

Players.PlayerAdded:Connect(function(Player)
    Aviation.Await() --// Await is used to make sure that Aviation has begin operating

    local PlayerObject = Aviation.new(Player, "Secured-RemoteObject")

    PlayerObject:FromList(RemoteList)

    PlayerObject:Process()
end)
```

### Fire all Client

Firing a specific Client on the Server needs a player from which you'll retrive the *PlayerStructure* and call the `:FireClient` method on. The `:FireClient` method does **not** consume a Player. What about firing all the Remotes of a Player?

The `:FireAll` method is called directly on Aviation and takes the RemoteObject name that is to be fired as first argument and the rest of the arguments are passed. This method returns a table of all the PlayerResponces if there were any.

How the PlayerResponces is structured, `{PlayerName = {Data, Data, ...}}`.


```lua hl_lines="2"
local Aviation = require(ReplicatedStorage:WaitForChild("Aviation"))
local PlayerResponces = Aviation:FireAll("Messenger", "Hello world from Aviation!")

print("Frieda responded with", table.unpack(PlayerResponces["Frieda_VI"]))
```