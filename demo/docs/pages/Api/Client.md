
# Client Functions of Aviation

Getting the PlayerStructure and Getting RemoteObjects were discussed and explained in *#Sever_and_Client*. So we'll be basing our understanding from there.

---

## Securise

Right after obtaining the *PlayerObject* on the Main Client Runtime, you should call the `:Securise` method. The *Securise* method ensure that the RemoteInstances are exploit prof on the ClientSide.

```lua hl_lines="6-7"
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Aviation = require(ReplicatedStorage:WaitForChild("Aviation"))
Aviation.Await()

local PlayerStructure = Aviation.Structure()
PlayerStructure:Securise()
```


## Attaching Functions

Not all *RemoteObjects* will have functions attached to them as some will be used to __Invoke__ the server. The method demonstrated is a primitive way to attach functions to remotes is not very efficient when used as such but it can still be used sometimes. `:BindToClient()` methods takes in a function which will receive arguments sent by the server. As *RemoteObjects* are two way communication devices they allow the `return` of data back to the Server.


``` lua hl_lines="2-5"
    local Aviation = require(ReplicatedStorage:WaitForChild("Aviation"))

    local PlayerStructure = Aviation.Structure()
    local Messenger = PlayerStructure:GetRemote("Messenger")

    Messenger:BindToClient(function(Message, ...)
        print(Message)
        return "Woah, that's interesting!"
    end)
```

## Efficient Attaching Functions

Just like the on the Server we have *RemoteList*, on the client too we have *RemoteList*.

The way to bind functions to RemoteObjects below is the most efficient and recommended way. *RemoteList* is a table, you can have creation of RemoteObjects and attach functions to them all in a module and provide it to the *PlayerObject* to consume. 

The `:FromStructure()` method takes the *RemoteList* as argument and binds function to the following RemoteObject. The *RemoteList* is a table"Dictionary", all the __indexes__ are RemoteObject's name and __values__ are functions that are attached to the RemoteObject and called when the RemoteObject is fired from the Server.

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
end)
```
