
# Vider

Vider is a janitor module that uses French terms. It's recommended to avoid using *Vider* directly in your game as it's specific to Aviation. You could clone *Vider* and place it in *ReplicatedStorage* to use it.

## Constructor

`Vider.new()` is the constructor which doesn't take any arguments and returns a ViderObject.

It is recommended to use `Vider:Debute()` instead of `Vider.new()`. *Debute* takes in a MainInstance and other which are considered as secondary instances. If the MainInstance is destroyed, it will trigger `Vider:Nettoyer` which is the cleaning up method. Other can only be RBXScriptConnection or Instances. *Debute* returns a ViderObject with the MainInstance as the controller and other arguments as secondary objects.

```lua hl_lines="3-5"
local Vider = Aviation.Vider

local myVider = Vider:Debute(workspace.Baseplate, workspace.Changed:Connect(function(Child)
    print(Child)
end), workspace.Part) 

-- Vider only works with instances 
```

## Adding MainInstance

You can have more than 1 MainInstance in your ViderObject, if a MainInstance is destroyed, all the secondary objects will be destroyed but the MainInstances wouldn't be destroyed by default. We use the `:AjouteMain` method on our *ViderObject* to add a MainInstance.

```lua hl_lines="1"
myVider:AjouteMain(workspace)
```

## Adding SecondaryInstance

Just like you can add MainInstances, you can also add more SecondaryInstance which will be Destroyed|Disconnected when *nettoyer* is called.

```lua
myVider:AjouteAutre(workspace.Part1, workspace.Part2, game.Players.PlayerAdded:Connect(function(Player)
    print("A new player has joined the game!")
end))
```

## Cleaning

ViderObjects will manually undergo the cleaning process after a MainInstance is destroyed but it is possible to force clean the ViderObject. The `:Nettoyer` method is called on the ViderObject will forcefully clean the the SecondaryInstance by default, but if `true` is passed as argument, the MainInstances will also be destroyed.

```lua
myVider:Nettoyer() -- Main Instances won't be destroyed
myVider:Nettoyer(true) -- Main Instances will be destroyed
```

## Cleaning Functions

There are 2 functions which run before and after cleaning.

`:AvantNet` method takes a callback function as argument which will be called before cleaning the instances, there can only be 1 *AvantNet* function.

```lua hl_lines="1 5"
myVider:AvantNet(function()
    print("Cleaning process has been triggered")

    mySignal:Destroy() -- Perfect location to Destroy SignalObjects
end)
```

`:ApresNet` method takes a callback function as argument which will be called after cleaning the instances, there can only be 1 *ApresNet* function.

```lua hl_lines="1 3"
myVider:ApresNet(function()
    print("Cleaning process has been completed")
end)
```

SignalObject will be compatible to Vider in the next update.


## Vider Checking
Helps to check wether an object is a ViderObject or not.

```lua hl_lines="2"
local Vider = Aviation.Vider
Vider.IsVider(myVider) --> Proves wether object is a ViderObject or not: boolean
```