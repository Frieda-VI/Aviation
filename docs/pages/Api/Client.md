
# Client Functions of Aviation

Getting the PlayerStructure and RemoteObjects were discussed and explained in *#Sever_and_Client*. So we'll be basing our understanding from there.

---

## Securise

Right after obtaining the *PlayerObject* on the Main Client Runtime, you should call the `:Securise` method. The *Securise* method ensures that the RemoteInstances are exploit proof on the client side.

```lua hl_lines="6-7"
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Aviation = require(ReplicatedStorage:WaitForChild("Aviation"))
Aviation.Await()

local PlayerStructure = Aviation.Structure()
PlayerStructure:Securise()
```


## Attaching Functions

Not all *RemoteObjects* will have functions attached to them, some will be used to __Invoke__ the server. The method demonstrated is a primitive way to attach functions to remotes and is not very efficient, but can still be used sometimes. `:BindToClient()` methods takes in a function which will receive arguments sent by the server. As *RemoteObjects* are two way communication devices they allow the `return` of data back to the Server.


``` lua hl_lines="2-5"
    local Aviation = require(ReplicatedStorage:WaitForChild("Aviation"))

    local PlayerStructure = Aviation.Structure()
    local Messenger = PlayerStructure:GetRemote("Messenger")

    Messenger:BindToClient(function(Message, ...)
        print(Message)
        return "Woah, that's interesting!"
    end)
```

## Efficiently Attaching Functions

Just like how on the Server we have RemoteList, the client has it too.

The way to bind functions to RemoteObjects below is the most efficient and recommended way. RemoteList is a table, you can have creation of RemoteObjects and attach functions to them all in a module and provide it to the PlayerObject to consume.

The :FromStructure() method takes the RemoteList as argument and binds function to the following RemoteObject. The RemoteList is a table "Dictionary", all the indexes are RemoteObject's name and values are functions that are attached to the RemoteObject and called when the RemoteObject is fired from the Server.

```lua hl_lines="1-6 14"
local Aviation = require(ReplicatedStorage:WaitForChild("Aviation"))
Aviation.Await()

local PlayerObject = Aviation.Structure()
local RemoteList = {
    FriedaRemote = function(Message, ...)
        print(Message)
        return "Woah, that's interesting!"
    end);
}

PlayerObject:FromStructure(RemoteList)
```
