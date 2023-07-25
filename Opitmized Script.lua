-- library

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Rain-Design/Libraries/main/Revenant.lua", true))()
local Flags = Library.Flags

local Window = Library:Window({
    Text = "Main"
})

local Window3 = Library:Window({
    Text = "Extra"
})


-- services
local players = game:GetService("Players")
local vu = game:GetService("VirtualUser")


-- variables
local lp = players.LocalPlayer
local carCollection = workspace.CarCollection
local guiScript = getsenv(lp.PlayerGui:WaitForChild("GUIs"))
local openFunc = guiScript["OpenDealership"]
local spawnFunc = guiScript["SpawnButton"]
local doBreak = false


-- functions
local function getCurrentCar()
    local car = carCollection:FindFirstChild(lp.Name)
    if not car then return nil end
   
    local model = car:FindFirstChild("Car")
    if not model then return nil end

    local isNotBroken =
        model:FindFirstChild("Wheels"):FindFirstChildOfClass("Part") and
        model:FindFirstChild("Body"):FindFirstChild("Engine"):FindFirstChildOfClass("MeshPart")

    return isNotBroken and model or nil
end

local function getCharacter()
    return lp.Character or lp.CHaracterAdded:Wait()
end

local function canSpawn()
    return lp.SpawnTimer.Value <= 0
end

local function spawnBestCar()
    openFunc()
    spawnFunc(true, Enum.UserInputState.Begin)
end

local function destroyCar()
    local hum = getCharacter():FindFirstChildOfClass("Humanoid")
    local hrp = getCharacter():FindFirstChild("HumanoidRootPart")

    if not hum or not hrp then return end

    local car = getCurrentCar()

    repeat task.wait() until car.PrimaryPart ~= nil

    -- Death to the car!!!
    repeat task.wait()
        car = getCurrentCar()
        if not car then return end
       
        task.wait(.1)

        pcall(function()
            if not car.PrimaryPart then return end
            car.PrimaryPart.Velocity = Vector3.new(0, 300, 0)
            car.PrimaryPart.CFrame *= CFrame.Angles(180, 0, 0)
        end)

        task.wait(.1)

        pcall(function()
            if not car.PrimaryPart then return end
            car.PrimaryPart.Velocity = Vector3.new(0, -400, 0)
            car.PrimaryPart.CFrame *= CFrame.Angles(180, 0, 0)
        end)
       
    until not doBreak
end


-- GUI

local AutofarmEnabled = false

Window:Toggle({
    Text = "AutoFarm",
    Flag = Autofarm,
    Callback = function(bool)
        if bool == true then
            AutofarmEnabled = true

            Library:Notification({
                Text = "AutoFarm has been activated.",
                Duration = 2.5
            })

            while AutofarmEnabled do
                wait(0.5)
                if canSpawn() then
                    doBreak = true
                    task.delay(10, function()
                        doBreak = false
                    end)
                    pcall(function()
                        spawnBestCar()
                        destroyCar()
                    end)
                end
            end
        else
            AutofarmEnabled = false

            Library:Notification({
                Text = "AutoFarm has been deactivated.",
                Duration = 2.5
            })
        end
    end
})


Window:Button({
    Text = "Spawn Best Car",
    Callback = function()
    	spawnBestCar()
    end
})

Window:Button({
    Text = "Destroy Car",
    Callback = function()
        doBreak = true
        task.delay(10, function() doBreak = false end)
        pcall(function()
            destroyCar()
        end)
    end
})


Window3:Toggle({
    Text = "Anti AFK",
    Callback = function(bool)
        if bool == true then
        	Library:Notification({
            	Text = "Anti AFK has been activated.",
            	Duration = 2.5
        	})
        	for i,v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
                v:Disable()
            end
        else
        	Library:Notification({
            	Text = "Anti AFK has been deactivated.",
            	Duration = 2.5
        	})
        	for i,v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
                v:Enable()
            end
        end
    end
})

Window3:Toggle({
    Text = "No 3D Rendering",
    Callback = function(bool)
        if bool == true then
        	Library:Notification({
            	Text = "3D Rendering has been deactivated.",
            	Duration = 2.5
        	})
        	game:GetService("RunService"):Set3dRenderingEnabled(false)
        else
        	Library:Notification({
            	Text = "3D Rendering has been activated.",
            	Duration = 2.5
        	})
        	game:GetService("RunService"):Set3dRenderingEnabled(true)
        end
    end
})

Window3:Keybind({
    Text = "Toggle Library",
    Default = Enum.KeyCode.F4,
    Callback = function()
        Library:Toggle()
    end
})
