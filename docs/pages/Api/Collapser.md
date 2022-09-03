# Collapser

## Intro

With Aviation Version `4.3.0`, we brought something new into the framework. This version is purely oriented on Server features, and all features will be covered through this webpage itself.  

## What is a collapser?

Collapser is an extremely useful feature as it is a way of communicating with the remotes on the Player's behalf. Collapser was created with the aim of being called when the Player is leaving the game as `Destroy` method for the AviationObject (PlayerStructure).

### Code Sampling

Here are some basic example on how the Collapser is meant to be used:

```lua
--// This Is Our Sample Code \\--
local Players = game:GetService("Players")

local Aviation = require(game:GetService("ReplicatedStorage"):WaitForChild("Aviation"))
Aviation.Start()

local RemoteList = {}
local PlayerStructures = {}

Players.PlayerAdded:Connect(function(Player)
    Aviation.Await()

    local PlayerStructure = Aviation.new(Player)
    PlayerStructure:FromList(RemoteList)
    PlayerStructure:Process() --// Sending To The Archiver \\--

    PlayerStructures[Player] = PlayerStructure --// Keeping Record \\--
end)

Players.PlayerRemoving:Connect(function(Player)
    --// Performing Garbage Collecting \\--
    PlayerStructures[Player] = nil
end)
```

Now let's see how we could use the Collapser

```lua hl_lines="8-15"
--// This Expands Upon The Sample Code \\--
local RemoteList = {
    "Example1", --// Basic (Creates A RemoteObject)
    ["Example2"] = function(Player, ...)
        --// This Is The Stable Method \\--
        --// Creates And Binds A Function To The RemoteObject \\--
        return
    end,

    ["Example3"] = {
        ["Callback"] = function(Player, ...)
            return performTask(Player, ...)
        end,
        ["Collapser"] = function(Player)
            return "Example3"
        end
    }
}
```

The `Example3` RemoteObject is the perfect example of how to set and create a Collapser for a RemoteObject. It is similar to the Stable Method of creating RemoteObject with the expection that it takes in a table instead of a function. The dictionary (table) should only contain two indexes, `Callback` and `Collapser`. 

The `Callback` is the regular function binded to the RemoteObject, like for `Example2`.
The `Collapser`, on the other hand provides a function which will be called when the `PlayerStructure.Collapse` method is called. **Note: The Collapser Method should not yield!**

There are two different methods of calling the Collapse method but they both function in the same manner. **Note: It is recommended that the Collapse method be called only when the Player is leaving, as Collapse is sign of Destroy.** However the Collapse method, doesn't have destroying capacities, and will not affect the AviationObject.

```lua hl_lines="6 8"
--// This Expands Upon The Sample Code And All Previous Code From Above \\--

Players.PlayerRemoving:Connect(function(Player)
    local PlayerStructure = PlayerStructures[Player]
    if PlayerStructure then
        local Returns = PlayerStructure:Collapse(true)

        print(Returns.Example3[1])
    end

    --// Performing Garbage Collecting \\--
    PlayerStructures[Player] = nil
end)
```

This is the first method of calling the Collapse method, and there exists two methods of performing the task. This first method aims at calling all RemoteObject's Collapser and takes a boolean `true` as argument.

Both methods of Collapsing has the overall same type of returning mechanism, however the second method has a unique function which aims to make finding the returned values easier. The returned values of each RemoteObject is sealed in a table, and this table is then sealed into another general table containing all the returned values with the RemoteObject name as indexer. That means that Example3's collapser will have `Example3` as indexer.

Representation of the return[1] format: `{ Example3 = { "Example3" }, SampleExample = { "SampleExampleString", 2, true } }`. Any values returned will be orderly arranged in the table. 

```lua hl_lines="6 8"
--// This Expands Upon The Sample Code And All Previous Code From Above \\--

Players.PlayerRemoving:Connect(function(Player)
    local PlayerStructure = PlayerStructures[Player]
    if PlayerStructure then
        local Returns = PlayerStructure:Collapse("Example3")

        print(Returns.Example3[1], Returns.Get(1), Returns.Get())
    end

    --// Performing Garbage Collecting \\--
    PlayerStructures[Player] = nil
end)

```

The second method of collapsing is specific to 1 Indexer. Instead of a boolean `true` being provided as argument, it takes a specific string `Example3` as argument. This Indexer is then used to find the Collapser for the RemoteObject under the name of the Indexer.

All the returned values are stored similarly to the first method. But with only one RemoteObject's Collapser being called, there's only going to be one returned table. Therefore, the return table for the second method offers a `.Get` method which takes a number as parameter. This number is then used to obtain the returned value according to the order returned, if left blank, it returns the first returned value of the Collapse method.

That's about it all on Collapser.

## Structure [Server Only]

With Update Version 4.3.0, a brand new method of obtaining a PlayerStructure from the server has been implemented. *This method is prone to failure if it's used with Parallel Lua.*

### Code Sampling

```lua hl_lines="12-13"
--// This Is A Different Script Instance From The Above Code Samping \\--

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Aviation = require(ReplicatedStorage:WaitForChild("Aviation"))

Players.PlayerAdded:Connect(function(Player)
    Aviation.Await()
    task.wait(1) --// It's logical to not get the structure right away

    local PlayerStructure = Aviation.GetStructure(Player)
    local Returns = PlayerStructure:Collapse(true)

    print(Returns.Example3[1])
end
```

The `.GetStructure` method is a short and more performant way of obtaining the original PlayerStructure created. This doesn't aim at replace the classical `.Structure` method which also takes `Player` as argument but simply aims at providing more accesibility.

`.GetStructure` and `.Structure` do not perform the same. `GetStructure` is only available on the server and it provides the original AviationObject created whilst `.Structure` is available on both the client and the server but it provides a modified AviationObject which doesn't directly inherrit from the Aviation class.

**Keep in mind that both methods do provide the Collapsing feature.**
