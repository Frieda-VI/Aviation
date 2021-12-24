
# The Aviation Library | Framework

## Introduction

> **What's Aviation?**

Aviation is a library and *partial framework* designed for Roblox and is meant to replace the *direct usage* of RemoteEvent and RemoteFunctions. It helps to keep communication between client and server and vice versa organised and well maintained. Aviation was formerly known as 'hypixel26's Custom RemoteFramework', and is provided to you by [Frieda_VI](https://www.roblox.com/users/479498903/profile).

---

> **Why Aviation?**

Aviation was designed to be used as a remote filler but why use it? Each players have their own set of RemoteObjects, all having a uniform name, and changing properties of the RemoteObject will result in a `#!lua Player:Kick()`. It helps to keep your code organised, efficient and exploit prof.

Aviation is not for everyone, I expect people who are good at managing their codes and RemoteEvents|Functions to be using Aviation.


```lua hl_lines="2"
while true do
    RemoteEvent:FireServer(...)
end
```

If your game is coded like the code above, that is the **overly** usage of RemoteEvents|Functions, I'd suggest you stay away from Aviation as this style of coding is not efficient at all and is to be avoided.