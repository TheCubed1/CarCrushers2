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

-- main
lp.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    wait(1)
    vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

while task.wait() do
    local character = getCharacter()

    if not character then return end

    if canSpawn() then
        doBreak = true
        task.delay(10, function() doBreak = false end)
        pcall(function()
            spawnBestCar()
            destroyCar()
        end)
    end
end
