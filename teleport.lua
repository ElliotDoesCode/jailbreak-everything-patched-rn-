--[[
    Made by IAteYourDog#4864
    I don't give permision to re-release or re-use
    Please use credits if using the teleport method in your hub

    Report bugs to me
    v1.1
]]

if not game:IsLoaded() then
    game.Loaded:wait()
end


--[[
    Documentation:
    teleport(cframe)
    slide( cframe, speed (optional) )
    * Both can be called from getgenv as well
]]
for _,_garbage in pairs((getgc(true) or debug.getupvalues() or getupvalues() or getreg())) do
    if (type or typeof)(_garbage) == "table" then
        if rawget(_garbage, "Ragdoll") then
            --Pow pow pow
            _garbage = function(...) return wait(math.pow(10,10,10)) end
        end
    end
end

getgenv().slide = function(cframe, optionalspeed)
    local root = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
    local distance, distancel = cframe.p - root.Position, (cframe - cframe.p) + root.Position
    mag = 8 if tonumber(optionalspeed) then mag = optionalspeed end
    for i = 0, distance.magnitude, mag do
        if game:GetService("Players").LocalPlayer.Character.Humanoid.Sit == true then game:GetService("Players").LocalPlayer.Character.Humanoid.Jump = true end 
        root.CFrame = distancel + distance.Unit * i
        root.Velocity,root.RotVelocity = Vector3.new(),Vector3.new() wait()
        local currentpos = root.Position - Vector3.new(0, root.Position.y, 0) wait() local magafter = ((root.Position - Vector3.new(0,root.Position.y, 0)) - currentpos).magnitude
        if magafter > 500 then wait(3) slide(cframe, optionalspeed) return end
    end
    game:GetService("Players").LocalPlayer.Character.Humanoid:ChangeState(11)
end

local function slidevehicle(vehicle, cframe)
    local worked, failed = pcall(function()
        if vehicle ~= nil then
            vehicle:SetPrimaryPartCFrame(vehicle.PrimaryPart.CFrame + Vector3.new(0,400,0))

            --To prevent bad
            local force = Instance.new("BodyVelocity", vehicle.Engine) force.Name = "Daddy" force.Velocity = Vector3.new(0,0,0) force.MaxForce = Vector3.new(9e9,9e9,9e9) force.P = 1000
            local origin = cframe
            
            wait(0.3)

            cframe = cframe + Vector3.new(0, vehicle.PrimaryPart.Position.y, 0)

            local root, mag = vehicle.PrimaryPart, 14
            local distance, distancel = cframe.p - root.Position, (cframe - cframe.p) + root.Position

            for i = 0, distance.magnitude, mag do
                local nextpos = distancel + distance.Unit * i
                vehicle:SetPrimaryPartCFrame(nextpos)
                root.Velocity,root.RotVelocity = Vector3.new(),Vector3.new()

                local currentpos = vehicle.PrimaryPart.Position - Vector3.new(0, vehicle.PrimaryPart.Position.y, 0)
                wait()
                local magafter = ((vehicle.PrimaryPart.Position - Vector3.new(0,vehicle.PrimaryPart.Position.y, 0)) - currentpos).magnitude

                if magafter > 500 then
                    wait(3)
                    slidevehicle(vehicle, origin)
                    return
                end
            end


            for i = 1, 4 do
                vehicle:SetPrimaryPartCFrame(origin)
            end

            wait(1)

            root.Velocity,root.RotVelocity = Vector3.new(),Vector3.new()
            force:Destroy()
            
            game:GetService("ContextActionService"):UnbindAction("DisableInput")

            game:GetService("VirtualInputManager"):SendKeyEvent(true, "Space", false, game)
            wait()
            game:GetService("VirtualInputManager"):SendKeyEvent(false, "Space", false, game)

            if (origin.p - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 500 then
                wait(2)
                teleport(origin)
                return
            end

            wait(0.3)

            return true
        end
    end)
    if not worked then
        game:GetService("ContextActionService"):UnbindAction("DisableInput")

        return false    
    end
end

getgenv().teleport = function(cframe)
    local debug1, debug2 = pcall(function()
        if (cframe.p - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).magnitude > 200 then
            local vehicles = game:GetService("Workspace").Vehicles:GetChildren()
            table.sort(vehicles, 
                function(v, v2) 
                    local v3 = v.PrimaryPart or v:FindFirstChildWhichIsA("Part")
                    local v4 = v2.PrimaryPart or v2:FindFirstChildWhichIsA("Part")

                    if v3 ~= nil and v4 ~= nil  then
                        return (v3.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).magnitude < 
                        (v4.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).magnitude 
                    end
                end)
            for _,v in pairs(vehicles) do
                if v.PrimaryPart ~= nil and v.Seat.Player.Value == true and tostring(v.Seat.PlayerName.Value) == game:GetService("Players").LocalPlayer.Name then
                    if v.Name == "Camaro" then
                        slidevehicle(v, cframe)
                        return
                    else
                        game:GetService("VirtualInputManager"):SendKeyEvent(true, "Space", false, game)
                        wait()
                        game:GetService("VirtualInputManager"):SendKeyEvent(false, "Space", false, game)
                        wait(1)
                    end
                end
            end

            game:GetService("VirtualInputManager"):SendKeyEvent(true, "W", false, game)
            wait(1)
            game:GetService("VirtualInputManager"):SendKeyEvent(false, "W", false, game)

            for _,v in pairs(vehicles) do
                if v.PrimaryPart ~= nil and v.Seat.Player.Value == false and v.Name == "Camaro" then
                    game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame -= Vector3.new(0,150,0)
                    slide(CFrame.new(Vector3.new(v.Camera.Position.x,-150,v.Camera.Position.z)),4)
                    game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame += Vector3.new(0,v.Camera.CFrame.y + 150,0)
                    for i = 1, 100 do
                        game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.Camera.CFrame.p - Vector3.new(4,1,0))

                        for _,d in pairs(require(game:GetService("ReplicatedStorage").Module.UI).CircleAction.Specs) do
                            if d.Part == v.Seat then
                                d:Callback(d, true)    
                            end
                        end

                        game:GetService("RunService").RenderStepped:wait()
                        
                        if tostring(v.Seat.PlayerName.Value) == game:GetService("Players").LocalPlayer.Name then
                            wait()
                            break
                        end
                    end
                    wait(0.3)
                    if tostring(v.Seat.PlayerName.Value) == game:GetService("Players").LocalPlayer.Name then
                        game:GetService("ContextActionService"):BindAction("DisableInput", 
                        function() return Enum.ContextActionResult.Sink end,
                        false,
                        unpack(Enum.PlayerActions:GetEnumItems()))
                        slidevehicle(v, cframe)
                        break
                    end
                    wait(2)
                end
            end
        else
            pcall(function()
                slide(cframe, 2)
            end)
        end
    end)
    print(debug2)
end
