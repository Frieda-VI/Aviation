
--// Signal Module For Aviation \\--
--//        By Frieda_VI         \\--


local Signal = {}
Signal.__index = Signal


function Signal.IsSignal(Object)
    --// Checks Wether An Object Is A Signal Object \\--
    return type(Object) == "table" and Object.ClassName == "Signal" and getmetatable(Object) == Signal
end


--// Connection Class \\--
local RbxConnection = {}
RbxConnection.__index = RbxConnection

function RbxConnection:__tostring()
    --// Turns The Connection Table To A String \\--
    --// FR_SignalConnection Means A Frieda Signal Connection \\--
    return "FR_SignalConnection-" .. self.Disabled
end

function RbxConnection.IsConnection(Object)
    --// Checks Wether The Object Passed Is A Connection Or Not \\--
    return type(Object) == "table" and getmetatable(Object) == RbxConnection
end

function RbxConnection.Wrap(FUNCTION)
    --// Creates A Connection \\--
    return setmetatable({
        Disabled = false;
        Function = FUNCTION;
    }, RbxConnection)
end

function RbxConnection:Fire(...)
    if not self.Disabled and type(self.Function) == "function" then
        --// Makes Sure This Is A Valid Function \\--
        self.Function(...)
    end
end

function RbxConnection:Disconnect()
    --// Disables The Connection \\--
    if not self:IsConnection() then
        warn("Attempting To Disable A Non Active Connection!")
        return
    end

    self.Disabled = true
    self.Function = nil

    table.clear(self)
    self = nil
end


function Signal.new()
    --// Signal Constructor \\--
    return setmetatable({
        ClassName = "Signal";

        Connections = {
            --// Will Contain All The Frieda Connection Objects \\--
        };
    }, Signal)
end

function Signal.Wrap(FUNCTION)
    assert(type(FUNCTION) == "function", "Argument[1] Must Be Of Type ::FUNCTION::!")

    --// Creates A Signal And Attaches A Frieda Connection To It \\--

    local WrappedSignal = Signal.new()
    WrappedSignal:Connect(FUNCTION)

    return WrappedSignal
end

function Signal:Destroy()
    if Signal.IsSignal(self) then
        --// Destroys The Signal Object \\--
        self.ClassName = "NonValid"

        for _Index, Connection in pairs(self.Connections) do
            if RbxConnection.IsConnection(Connection) then
                Connection:Disconnect()
            end
        end

        table.clear(self)
        self = nil
    else
        warn("Attempting To Destroy An Invalid Object!")
    end
end


function Signal:Fire(...)
    if not self:IsSignal() then
        warn("Attempting To Fire A Dead Signal!")
        return
    end

    --// Fires Each Connected Frieda Connections \\--
    --// Can Yield, Direct Call \\--

    for _Index, Connection in pairs(self.Connections) do
        Connection:Fire(...)
    end
end

function Signal:FireDefer(...)
    if not self:IsSignal() then
        warn("Attempting To Fire A Dead Signal!")
        return
    end

    --// Defers The Fire Of The Frieda Connections \--
    --// Similar To FireSpawn, But The Thread Does Not Need To Run Immediately \\--

    for _Index, Connection in pairs(self.Connections) do
        task.defer(Connection.Fire, Connection, ...)
    end
end

function Signal:FireSpawn(...)
    if not self:IsSignal() then
        warn("Attempting To Fire A Dead Signal!")
        return
    end

    --// Fires Each Connected Frieda Connections \\--
    --// Creates A New Thread \\--

    for _Index, Connection in pairs(self.Connections) do
        task.spawn(Connection.Fire, Connection, ...)
    end
end


function Signal:Connect(FUNCTION)
    assert(type(FUNCTION) == "function", "Argument[1] Must Be Of Type ::FUNCTION::!")

    --// Connect A Function To The Signal \\--
    local Connection = RbxConnection.Wrap(FUNCTION)

    table.insert(self.Connections, Connection)
    return Connection
end



return Signal