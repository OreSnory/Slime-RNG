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

-- Variables
local LocalPlayer = Players.LocalPlayer
local RollCoolDown = LocalPlayer.PlayerGui.Root.BottomBarStats.StatsList.RollSpeedStat.Content.Value.TextLabel.Text:match("[%d%.]+")

-- Modules
local client = require(ReplicatedStorage.Packages.DataService).client
local UpgradeTree = require(ReplicatedStorage.Source.Features.Upgrades.UpgradeTree)
local UpgradeUtils = require(ReplicatedStorage.Source.Features.Upgrades.UpgradeServiceUtils)

-- Remotes
local Roll = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("leifstout_networker@0.3.1"):WaitForChild("networker"):WaitForChild("_remotes"):WaitForChild("RollService"):WaitForChild("RemoteFunction")
local EquipBest = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("leifstout_networker@0.3.1"):WaitForChild("networker"):WaitForChild("_remotes"):WaitForChild("InventoryService"):WaitForChild("RemoteFunction")
local BuyUpgrade = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("leifstout_networker@0.3.1"):WaitForChild("networker"):WaitForChild("_remotes"):WaitForChild("UpgradeService"):WaitForChild("RemoteFunction")

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

local Toggle = Main:CreateToggle({
    Name = "Auto Buy Upgrades",
    CurrentValue = false,
    Flag = "AutoBuyUpgrades",
    Callback = function(Value)
        AutoBuyUpgrades = Value

        if AutoBuyUpgrades then
            task.spawn(function()
                while AutoBuyUpgrades do
                    for _, Upgrades in next, UpgradeTree do
                        for _, Tiles in next, Upgrades do
                            if Tiles.cost and not UpgradeUtils.ownsUpgrade(Tiles.id, client:get("upgrades") or {}) and (client:get()[Tiles.cost.currency] or 0) >= Tiles.cost.amount then
                                BuyUpgrade:InvokeServer("requestUnlock", Tiles.id)
                                task.wait(1)
                            end
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

Rayfield:LoadConfiguration()
