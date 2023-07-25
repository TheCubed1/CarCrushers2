getgenv().Toggle = true
loadstring(game:HttpGet("https://raw.githubusercontent.com/TheCubed1/CarCrushers2/main/idk", true))()
local GUIs = getsenv(Player.PlayerGui:FindFirstChild("GUIs",true))
local OpenDealership = GUIs["OpenDealership"]
local SpawnButton = GUIs["SpawnButton"]

local GetCar = function()
   local IfOnly = Workspace.CarCollection:FindFirstChild(Player.Name,true):FindFirstChild("Car")
   return IfOnly
end

local function Sex()
   print(GetCar())
   GetCar().PrimaryPart.Velocity = Vector3.new(0, 250, 0)
   GetCar().PrimaryPart.CFrame = CFrame.Angles(180, 0, 0)
   wait(.25)
   GetCar().PrimaryPart.Velocity = Vector3.new(0, -250, 0)
   GetCar().PrimaryPart.CFrame = CFrame.Angles(180, 0, 0)
end

spawn(function()
   while wait() and Toggle do
     pcall(function()
           if Player.SpawnTimer.Value <= 0 then
               OpenDealership()
               SpawnButton(true, Enum.UserInputState.Begin)
               repeat wait() until GetCar()
               Sex()
           end
       end)
   end
end)
