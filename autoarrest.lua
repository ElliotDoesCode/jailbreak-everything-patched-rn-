--[[
    IAteYourDog's Autoarrest
    https://forum.robloxscripts.com/showthread.php?tid=3516
    v2

    Latest update:
        - Complete rewrite
        - Very low ban risk (still use alt though, report if ban risk increases)
        * please report bugs to me

    All source code goes credits to IAteYourDog#4864
    Use the loadstring instead of the script wont work next update
]]

if not game:IsLoaded() then
    game.Loaded:wait()
end


game.StarterGui:SetCore("SendNotification", {
    Title = "Sussy Baka",
    Text = "Script back up, please report bugs",
    Duration = 15,
    Button1 = "Okay idc"
})

--Counts executions (if you think spamming it does shit it really doesn't)
print(game:HttpGet("https://api.countapi.xyz/hit/autoarrest/key"))

local player = game:GetService("Players").LocalPlayer
local players = game:GetService("Teams").Criminal:GetPlayers()
local currenthash = "f836f06d"
local oldhash = nil

local function push(arg, optionaltime, amountoftimes)
    local times = amountoftimes or 1

    for i = 0, times, 1 do
        local inputmanager = game:GetService("VirtualInputManager")
        inputmanager:SendKeyEvent(true, arg, false, game)

        --Tonumber in case I make optionaltime a string, sorry nerds
        local waitime = tonumber(optionaltime) or 0

        wait(waitime)

        inputmanager:SendKeyEvent(false, arg, false, game)
    end

end

local function serverhop()
    pcall(function()
        local api = game:HttpGet("https://games.roblox.com/v1/games/606849621/servers/Public?limit=100&sortOrder=Asc",true)
        for _,i in ipairs(game:GetService("HttpService"):JSONDecode(api).data) do
            pcall(function()
                if i.maxPlayers > i.playing and i.ping < 300 and i.id ~= game.JobId then
                    game.Players.LocalPlayer:Kick("Teleporting")
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId,i.id)
                end
            end)
        end
    end)
end

local function slideto(cframe, optionalspeed)
    local root = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
    local distance, distancel = cframe.p - root.Position, (cframe - cframe.p) + root.Position
    local previousgrav = workspace.Gravity workspace.Gravity = 0 mag = 8 if tonumber(optionalspeed) then mag = optionalspeed end
    for i = 0, distance.magnitude, mag do
        if game:GetService("Players").LocalPlayer.Character.Humanoid.Sit == true then game:GetService("Players").LocalPlayer.Character.Humanoid.Jump = true end 
        root.CFrame = distancel + distance.Unit * i
        root.Velocity,root.RotVelocity = Vector3.new(),Vector3.new() wait()
    end
    workspace.Gravity = previousgrav game:GetService("Players").LocalPlayer.Character.Humanoid:ChangeState(11)
end

pcall(function()
    local torso = player.Character.LowerTorso.Root
    torso:Clone().Parent = torso.Parent 
    torso:Destroy()
end)

--Made by me, I'll know if you steal cause I'm outside your window
local function instatp(cframe)
    pcall(function()
        local torso = player.Character.LowerTorso.Root
        torso:Clone().Parent = torso.Parent 
        torso:Destroy()
        wait()
    end)
    if player.Character.Humanoid.Sit == true then
        push("Space")
    end
    player.Character.HumanoidRootPart.CFrame = cframe
end

--Core
local arrestmodule = require(game:GetService("ReplicatedStorage").Module.UI).CircleAction.Specs
local done = false

local function arrest(player)
    pcall(function()
        for _,v in next, arrestmodule do
            if v.Name == "Arrest" and v.PlayerName == player.Name then
                v:Callback(v,true)
            end
        end
    end)
end

local function eject(player)
    pcall(function()
        for _,v in next, arrestmodule do
            if v.Name == "Eject" and (v.Part.Position - player.Character.HumanoidRootPart.Position).magnitude < 50 then
                v:Callback(v, true)
            end
        end
    end)
end

local function canarrest(player)
    pcall(function()
        for _,v in next, arrestmodule do
            if v.Name == "Arrest" and v.PlayerName == player.Name then
                return true
            end
        end
        return false
    end)
end

local function nearplayer()
   local closest = nil
   for _,v in pairs(game:GetService("Players"):GetChildren()) do
        if v.Team == game:GetService("Teams").Criminal then
            if closest == nil then
                closest = v 
            end
            pcall(function()
                if (v.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).magnitude < (closest.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).magnitude then
                    closest = v 
                end
            end)
        end
    end
    if closest ~= nil then
        return closest
    else
        return nil
    end
end

local autocuffs = coroutine.create(function()
    while true do
        wait(3) 
        push("Two",0,1)
    end
end)
coroutine.resume(autocuffs)

for _,v in next, getgc(true) do
    if type(v) == "table" then
        if rawget(v, 'Ragdoll') then 
            v.Ragdoll = function(...) return wait(math.pow(10,10,10)) end 
        end
    end    
end

local start = tick()
local doplayers = coroutine.create(function()

    local remote = debug.getupvalue(require(game:GetService("ReplicatedStorage").Module.AlexChassis).SetEvent, 1)
    for i = 1, 30 do 
        remote:FireServer(currenthash, "Police")
        remote:FireServer(oldhash, "Police")
    end

    wait(3)

    print("Tried")

    if player.Team == game:GetService("Teams").Police then
        game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer("Made by IAteYourDog (4,8,6,4)","All")
        
        while tick() - start < 120 or done == true do
            local a,b = pcall(function()
                local v = nearplayer()

                if v ~= nil then
                    local moneybefore = player.leaderstats.Money.Value

                    game:GetService("Workspace").Camera.CameraSubject = v.Character.HumanoidRootPart
                    wait()

                    repeat 
                        slideto(v.Character.HumanoidRootPart.CFrame)
                        wait()
                    until v:FindFirstChild("Character") == nil or (player.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude < 100
                    
                    local toolong = tick()
                    while toolong - tick() < 25 do
                        instatp(v.Character.HumanoidRootPart.CFrame + Vector3.new(math.random(-3,3),math.random(-2,1),math.random(-3,3)))
                        game:GetService('RunService').RenderStepped:wait()
                        eject(v)
                        arrest(v)
                        if v.Parent ==nil or v.Team == game:GetService("Teams").Prisoner or canarrest(v) == false or tonumber(player.leaderstats.Money.Value) > tonumber(moneybefore) or player.Character.Humanoid.Health < 5 then
                            v.Team = nil
                            break
                        end
                    end
                end
            end)
            if not a then print(b) end
        end
    end

    print("Done")

    local queuemethods = (syn and syn.queue_on_teleport) or queue_on_teleport
    queuemethods([[if not game:IsLoaded() then game.Loaded:Wait() end 
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ElliotDoesCode/jailbreak/main/autoarrest.lua",true))()]])
    while wait() do
        serverhop()
        wait(2)
    end
end)

coroutine.resume(doplayers)
