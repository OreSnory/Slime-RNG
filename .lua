local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Slime RNG - マリン",
   --ScriptID = "sid_8sjmcfk70kuj",
   LoadingTitle = "Slime RNG Script",
   LoadingSubtitle = "By マリン",
   ShowText = "マリン",

   ToggleUIKeybind = "K",

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "Slime RNG - マリン"
   },

   Discord = {
      Enabled = true,
      Invite = "zHFNDBRWZB",
      RememberJoins = true
   },
   
})

local Main = Window:CreateTab("Main")

local Section = Main:CreateSection("AutoFarm")

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Remotes
local Roll = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("leifstout_networker@0.3.1"):WaitForChild("networker"):WaitForChild("_remotes"):WaitForChild("RollService"):WaitForChild("RemoteFunction")
local EquipBest = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("leifstout_networker@0.3.1"):WaitForChild("networker"):WaitForChild("_remotes"):WaitForChild("InventoryService"):WaitForChild("RemoteFunction")

-- Variables
local LocalPlayer = Players.LocalPlayer

local RollCoolDown = LocalPlayer.PlayerGui.Root.BottomBarStats.StatsList.RollSpeedStat.Content.Value.TextLabel.Text:match("[%d%.]+")

local Toggle = Main:CreateToggle({
    Name = "Auto Roll",
    CurrentValue = false,
    Flag = "AutoRoll",
    Callback = function(Value)
        AutoRoll = Value

        if AutoRoll then
            task.spawn(function()
                while AutoRoll do
                    Roll:InvokeServer("requestRoll")
                    task.wait(RollCoolDown)
                end
            end)
        end
    end
})

local AutoEquipBestConn

Main:CreateToggle({
    Name = "Auto Equip Best",
    CurrentValue = false,
    Flag = "AutoEquipBest",
    Callback = function(Value)
        AutoEquipBest = Value

        if AutoEquipBest then
            AutoEquipBestConn = LocalPlayer:GetAttributeChangedSignal("NumRolls"):Connect(function()
                EquipBest:InvokeServer("requestEquipBest")
            end)
        else
            if AutoEquipBestConn then
                AutoEquipBestConn:Disconnect()
                AutoEquipBestConn = nil
            end
        end
    end
})

Rayfield:LoadConfiguration()
