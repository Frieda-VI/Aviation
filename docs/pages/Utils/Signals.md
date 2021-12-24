
# Signal

Signals allows you to have your own customised version of Roblox events which can receive callback functions. Signals works on both the Client and the Server and should be kept to the code where it was created. 

```lua hl_lines="2 4-6 8"
local Signals = Aviation.Signal
local mySignal = Signals.new()

mySignal:Connect(function(Message)
    print(Message)
end)

mySignal:Fire("Aviation signals are pog!")
```

## Creating Signals

`Signal.new()` is the signal constructor which doesn't take any arguments and returns a SignalObject on which Callback functions can be attached.

```lua
local mySignal = Signal.new()
```

Constructs a new Signal that wraps a function and returns a SignalObject, the SignalObject can then be mounted with more callback functions. Not that Wrap should only be called once, as it will create a new SignalObject.

```lua hl_lines="1-3"
local myConnection = Signal.Wrap(function(Message)
    print(Message)
end)
```

## Destroying Signals

SignalObjects have a `:Destroy()` method which will disconnect all the attached functions to the Signal and will attempt to clear the Signal. Thus rendering the following signal useless.

```lua hl_lines="1"
myConnection:Destroy()
```

## Attaching Functions

Functions can be attached to Signals, very simply. `:Connect()` takes in a callback function which will be call when a Signal is fired. Callback functions are allowed to yield and multiple callback functions can be attached to a SignalObject.

```lua hl_lines="1-3"
myConnection:Connect(function(Message)
    print(Message)
end)

myConnection:Connect(function(Message)
    StringValue.Value = tostring(Message)
end)
```

## Fire Signals

There are 3 ways of firing signals. Well be taking the `myConnection` for example.

### Fire

The default `:Fire()` function yields by default.

```lua hl_lines="1"
myConnection:Fire("Hello world")
```

### FireSpawn

The `:FireSpawn()` function doesn't yield and uses `task.spawn`, which creates a new thread.

```lua hl_lines="1"
myConnection:FireSpawn("Hello world")
```

### FireDefer

The `:FireDefer()` function doesn't yield and uses `task.defer`, which can be used to achive a similar behaviour to `:FireSpawn`.

```lua hl_lines="1"
myConnection:FireDefer("Hello world")
```


## Signal Checking
Helps to check wether an object is a SignalObject or not.

```lua hl_lines="2"
local Signal = Aviation.Signal
Vider.IsSignal(myVider) --> Proves wether object is a SignalObject or not: boolean
```