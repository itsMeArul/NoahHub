-- Load Fluent
local Fluent = loadstring(game:HttpGet(
                              "https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet(
                                   "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet(
                                        "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- Window
local Window = Fluent:CreateWindow({
    Title = "[🖱️] Antartica | NoahHUB",
    SubTitle = "https://www.getalok.store",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false,
    Theme = "Amethyst",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Opsi Fluent
local Options = Fluent.Options

-- Tab UI
local Tabs = {
    Main = Window:AddTab({Title = "Main", Icon = "house"}),
    Teleport = Window:AddTab({Title = "Teleport", Icon = "compass"}),
    Settings = Window:AddTab({Title = "Settings", Icon = "settings"})
}

Fluent:Notify({
    Title = "NoahHUB Freemium",
    Content = "Script berhasil dimuat!",
    Duration = 5
})

-- Auto Clicker Section
local AutoClickerSection = Tabs.Main:AddSection("Auto Clicker")
_G.autoClicker = false

function autoClicker()
    task.spawn(function()
        while _G.autoClicker do
            local event = game:GetService("ReplicatedStorage"):FindFirstChild(
                              "events-shared/network@GlobalEvents")
            if event and event:FindFirstChild("placeBlock") then
                event.placeBlock:FireServer()
            end
            wait(0.1)
        end
    end)
end

local ToggleClicker = AutoClickerSection:AddToggle("AutoClickerToggle", {
    Title = "Enable Auto Clicker",
    Default = false
})

ToggleClicker:OnChanged(function(value)
    _G.autoClicker = value
    if _G.autoClicker then
        autoClicker()
        Fluent:Notify({
            Title = "Auto Clicker",
            Content = "Auto Clicker telah diaktifkan!",
            Duration = 3
        })
    else
        Fluent:Notify({
            Title = "Auto Clicker",
            Content = "Auto Clicker telah dinonaktifkan!",
            Duration = 3
        })
    end
end)

-- Auto Open Egg Section
local EggSection = Tabs.Main:AddSection("Auto Open Egg")
_G.autoOpenEgg = false
_G.selectedEgg = "Cactus Egg"

function autoOpenEgg()
    task.spawn(function()
        while _G.autoOpenEgg do
            local args = {[1] = 19, [2] = _G.selectedEgg}

            local event = game:GetService("ReplicatedStorage"):FindFirstChild(
                              "functions-shared/network@GlobalFunctions")
            if event and event:FindFirstChild("s:openEgg") then
                event["s:openEgg"]:FireServer(unpack(args))
            end
            wait(0.5)
        end
    end)
end

local ToggleEgg = EggSection:AddToggle("AutoOpenEggToggle", {
    Title = "Enable Auto Open Egg",
    Default = false
})

ToggleEgg:OnChanged(function(value)
    _G.autoOpenEgg = value
    if _G.autoOpenEgg then autoOpenEgg() end
end)

local EggDropdown = EggSection:AddDropdown("EggSelection", {
    Title = "Select Egg",
    Values = {"Cactus Egg", "Dragon Egg", "Golden Egg"},
    Multi = false,
    Default = "Cactus Egg"
})

EggDropdown:OnChanged(function(value) _G.selectedEgg = value end)

-- Rebirth Section
local RebirthSection = Tabs.Main:AddSection("Rebirth")

_G.rebirthNow = false

local ToggleRebirth = RebirthSection:AddToggle("RebirthToggle", {
    Title = "Rebirth Now",
    Default = false
})

ToggleRebirth:OnChanged(function(value)
    if value then

        local args = {[1] = 0}

        local event = game:GetService("ReplicatedStorage"):FindFirstChild(
                          "functions-shared/network@GlobalFunctions")
        if event and event:FindFirstChild("s:rebirth") then
            event["s:rebirth"]:FireServer(unpack(args))

            Fluent:Notify({
                Title = "Rebirth",
                Content = "Rebirth berhasil dilakukan!",
                Duration = 3
            })
        end

        task.wait(0.5) 
        ToggleRebirth:SetValue(false)
    end
end)

local TeleportSection = Tabs.Teleport:AddSection("Teleport")

local locations = {
    ["Spawn"] = CFrame.new(-329, 8, 7),
    ["Gacha"] = CFrame.new(-329, 8, 7)
}

local TeleportDropdown = TeleportSection:AddDropdown("TeleportDropdown", {
    Title = "Select Location",
    Values = {"Spawn", "Gacha"},
    Multi = false,
    Default = "Spawn"
})

_G.selectedLocation = "Spawn"

TeleportDropdown:OnChanged(function(value) _G.selectedLocation = value end)

local TeleportButton = TeleportSection:AddButton({
    Title = "Teleport Now",
    Description = "Teleport to selected location",
    Callback = function()
        local player = game.Players.LocalPlayer
        if player and player.Character and
            player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame =
                locations[_G.selectedLocation]

            Fluent:Notify({
                Title = "Teleport",
                Content = "Teleported to " .. _G.selectedLocation,
                Duration = 3
            })
        end
    end
})

local TeleportPlayerSection = Tabs.Teleport:AddSection("Teleport to Player")

function getPlayers()
    local players = {}
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            table.insert(players, player.Name)
        end
    end
    return players
end

_G.selectedPlayer = nil
_G.playersList = getPlayers()

local PlayerDropdown = TeleportPlayerSection:AddDropdown("PlayerDropdown", {
    Title = "Select Player",
    Values = _G.playersList,
    Multi = false
})

PlayerDropdown:OnChanged(function(value) _G.selectedPlayer = value end)

local RefreshPlayersButton = TeleportPlayerSection:AddButton({
    Title = "Refresh Player List",
    Description = "Update the list of players in the game",
    Callback = function()
        _G.playersList = getPlayers()
        PlayerDropdown:SetValues(_G.playersList)

        Fluent:Notify({
            Title = "Player List Updated",
            Content = "Daftar pemain telah diperbarui!",
            Duration = 3
        })
    end
})

local TeleportToPlayerButton = TeleportPlayerSection:AddButton({
    Title = "Teleport to Player",
    Description = "Teleport to the selected player",
    Callback = function()
        if _G.selectedPlayer then
            local targetPlayer = game.Players:FindFirstChild(_G.selectedPlayer)
            if targetPlayer and targetPlayer.Character and
                targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local targetPosition = targetPlayer.Character.HumanoidRootPart
                                           .CFrame
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                    targetPosition

                Fluent:Notify({
                    Title = "Teleport Success",
                    Content = "Teleported to " .. _G.selectedPlayer,
                    Duration = 3
                })
            else
                Fluent:Notify({
                    Title = "Teleport Failed",
                    Content = "Pemain tidak ditemukan atau tidak memiliki karakter!",
                    Duration = 3
                })
            end
        else
            Fluent:Notify({
                Title = "No Player Selected",
                Content = "Pilih pemain sebelum teleport!",
                Duration = 3
            })
        end
    end
})

-- Save Manager & Interface Manager Setup
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("NoahHUB")
SaveManager:SetFolder("NoahHUB/game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
Window:SelectTab(1)
SaveManager:LoadAutoloadConfig()
