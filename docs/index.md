
# The Aviation Library | Framework

## Introduction

> **What is Aviation?**

Aviation is a library and *partial framework* designed for Roblox and is meant to replace the *direct usage* of RemoteEvent and RemoteFunction. It helps to keep communication between client and server, and vice versa organised while being well maintained. Aviation was formerly known as 'hypixel26's Custom RemoteFramework', and is provided to you by [Frieda_VI](https://www.roblox.com/users/479498903/profile).

---

> **Why Aviation?**

Aviation was designed to be used as a remote filler, but why use it? Each player has their own set of RemoteObjects, all having a uniform name. Changing properties of the RemoteObjects will result in a `#!lua Player:Kick()`. It helps to keep your code organised, efficient and exploit proof.

Aviation is not for everyone, I expect people who are good at managing their code and RemoteEvents|Functions to be using Aviation.


```lua hl_lines="2"
while true do
    RemoteEvent:FireServer(...)
end
```

If your game is coded similarly to the code above, and **excessively** uses RemoteEvents|Functions, I'd suggest you stay away from Aviation, as this style of coding is not efficient at all, and is to be avoided.