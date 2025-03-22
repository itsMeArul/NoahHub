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

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:FindFirstChildOfClass("Humanoid")

local LocationsPreset = {
    ["Base"] = CFrame.new(-5947, -159, -36),
    ["Camp 1"] = CFrame.new(-3718, 225, 235),
    ["Camp 2"] = CFrame.new(1790, 105, -136),
    ["Camp 3"] = CFrame.new(5893, 321, -19),
    ["Camp 4"] = CFrame.new(8993, 596, 102),
    ["Finish"] = CFrame.new(10993, 539, 107)
}

local function FreezeCharacter(state)
    if Humanoid then
        Humanoid.WalkSpeed = state and 0 or 16
        Humanoid.JumpPower = state and 0 or 50
        Humanoid.PlatformStand = state
    end
end

local function SafeTeleport(cframe)
    if HumanoidRootPart and Humanoid and Humanoid.Health > 0 then
        FreezeCharacter(true)
        task.wait(0.2)
        HumanoidRootPart.CFrame = CFrame.new(cframe.Position +
                                                 Vector3.new(0, 5, 0))
        task.wait(0.5)
        FreezeCharacter(false)

        Fluent:Notify({
            Title = "Teleport Berhasil",
            Content = "Berhasil teleport ke lokasi.",
            Duration = 3
        })
    else
        Fluent:Notify({
            Title = "Teleport Gagal",
            Content = "Karakter tidak ditemukan atau mati!",
            Duration = 5
        })
    end
end

local function StartAutoTeleport()
    for name, cframe in pairs(LocationsPreset) do
        SafeTeleport(cframe)

        if Humanoid.Health <= 0 then
            Fluent:Notify({
                Title = "Teleport Gagal!",
                Content = "Karakter mati saat teleport ke " .. name,
                Duration = 5
            })
            return
        end

        task.wait(1)
    end

    Fluent:Notify({
        Title = "Teleport Selesai!",
        Content = "Anda telah sampai di Finish!",
        Duration = 5
    })
end

Tabs.Main:AddButton({
    Title = "Mulai Auto Teleport",
    Callback = StartAutoTeleport
})

-- Teleport Section
local TeleportSection = Tabs.Teleport:AddSection("Teleport")

local TeleportDropdown = TeleportSection:AddDropdown("TeleportDropdown", {
    Title = "Select Location",
    Values = {"Base", "Camp 1", "Camp 2", "Camp 3", "Camp 4", "Finish"},
    Multi = false,
    Default = "Base"
})

_G.selectedLocation = "Base"

TeleportDropdown:OnChanged(function(value) _G.selectedLocation = value end)

local TeleportButton = TeleportSection:AddButton({
    Title = "Teleport Now",
    Description = "Teleport to selected location",
    Callback = function()
        if LocationsPreset[_G.selectedLocation] then
            SafeTeleport(LocationsPreset[_G.selectedLocation])
        else
            Fluent:Notify({
                Title = "Teleport Gagal",
                Content = "Lokasi tidak ditemukan!",
                Duration = 3
            })
        end
    end
})

-- Teleport to Player Section
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
                SafeTeleport(targetPosition)

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
