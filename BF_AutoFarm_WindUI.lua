local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/dist/main.lua"))()

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local lp = Players.LocalPlayer

local cfg = {
    Farm = false,
    FastAttack = false,
    Weapon = "Melee",
    Range = 60,
    Burst = 2,
    MaxTargets = 8,
    Delay = 0,
    Bring = true,
    Height = 20,
    TweenSpeed = 300,
    AutoBuso = true,
    HideUI = false,
}

local pid = game.PlaceId
local World = (pid == 2753915549 or pid == 85211729168715) and 1
    or (pid == 4442272183 or pid == 79091703265657) and 2
    or (pid == 7449423635 or pid == 100117331123089) and 3
    or 0

local V = Vector3.new

local function E(min, mob, quest, num, q, m, ex)
    ex = ex or {}
    return {
        min = min, mob = mob, quest = quest, num = num,
        qpos = q, mpos = m,
        match = ex.match or mob,
        entrance = ex.entrance,
    }
end

local FISH = V(61163.85, 11.68, 1819.78)
local SKY1 = V(-4607.82, 872.54, -1667.56)
local SKY2 = V(-7894.62, 5547.14, -380.29)
local SHIP = V(923.21, 126.98, 32852.83)
local FROST = V(-6508.56, 5000.03, -132.84)

local Quests = {}

Quests[1] = {
    E(1, "Bandit", "BanditQuest1", 1, V(1059.37, 15.45, 1550.42), V(1045.96, 27.0, 1560.82)),
    E(10, "Monkey", "JungleQuest", 1, V(-1598.09, 35.55, 153.38), V(-1448.52, 67.85, 11.47)),
    E(15, "Gorilla", "JungleQuest", 2, V(-1598.09, 35.55, 153.38), V(-1129.88, 40.46, -525.42)),
    E(30, "Pirate", "BuggyQuest1", 1, V(-1141.07, 4.10, 3831.55), V(-1103.51, 13.75, 3896.09)),
    E(40, "Brute", "BuggyQuest1", 2, V(-1141.07, 4.10, 3831.55), V(-1140.08, 14.81, 4322.92)),
    E(60, "Desert Bandit", "DesertQuest", 1, V(894.49, 5.14, 4392.43), V(924.80, 6.45, 4481.59)),
    E(75, "Desert Officer", "DesertQuest", 2, V(894.49, 5.14, 4392.43), V(1608.28, 8.61, 4371.01)),
    E(90, "Snow Bandit", "SnowQuest", 1, V(1389.74, 88.15, -1298.91), V(1354.35, 87.27, -1393.95)),
    E(100, "Snowman", "SnowQuest", 2, V(1389.74, 88.15, -1298.91), V(1201.64, 144.58, -1550.07)),
    E(120, "Chief Petty Officer", "MarineQuest2", 1, V(-5039.59, 27.35, 4324.68), V(-4881.23, 22.65, 4273.75)),
    E(150, "Sky Bandit", "SkyQuest", 1, V(-4839.53, 716.37, -2619.44), V(-4953.21, 295.74, -2899.23)),
    E(175, "Dark Master", "SkyQuest", 2, V(-4839.53, 716.37, -2619.44), V(-5259.84, 391.40, -2229.04)),
    E(190, "Prisoner", "PrisonerQuest", 1, V(5308.93, 1.66, 475.12), V(5098.97, -0.32, 474.24)),
    E(210, "Dangerous Prisoner", "PrisonerQuest", 2, V(5308.93, 1.66, 475.12), V(5654.56, 15.63, 866.30)),
    E(250, "Toga Warrior", "ColosseumQuest", 1, V(-1580.05, 6.35, -2986.48), V(-1820.21, 51.68, -2740.67)),
    E(275, "Gladiator", "ColosseumQuest", 2, V(-1580.05, 6.35, -2986.48), V(-1292.84, 56.38, -3339.03)),
    E(300, "Military Soldier", "MagmaQuest", 1, V(-5313.37, 10.95, 8515.29), V(-5411.16, 11.08, 8454.29)),
    E(325, "Military Spy", "MagmaQuest", 2, V(-5313.37, 10.95, 8515.29), V(-5802.87, 86.26, 8828.86)),
    E(375, "Fishman Warrior", "FishmanQuest", 1, V(61122.65, 18.50, 1569.40), V(60878.30, 18.48, 1543.76), {entrance = FISH}),
    E(400, "Fishman Commando", "FishmanQuest", 2, V(61122.65, 18.50, 1569.40), V(61922.63, 18.48, 1493.93), {entrance = FISH}),
    E(450, "God's Guard", "SkyExp1Quest", 1, V(-4721.89, 843.87, -1949.97), V(-4710.04, 845.28, -1927.31), {entrance = SKY1}),
    E(475, "Shanda", "SkyExp1Quest", 2, V(-7859.10, 5544.19, -381.48), V(-7678.49, 5566.40, -497.22), {entrance = SKY2}),
    E(525, "Royal Squad", "SkyExp2Quest", 1, V(-7906.82, 5634.66, -1411.99), V(-7624.25, 5658.13, -1467.35)),
    E(550, "Royal Soldier", "SkyExp2Quest", 2, V(-7906.82, 5634.66, -1411.99), V(-7836.75, 5645.66, -1790.62)),
    E(625, "Galley Pirate", "FountainQuest", 1, V(5259.82, 37.35, 4050.03), V(5551.02, 78.90, 3930.41)),
    E(650, "Galley Captain", "FountainQuest", 2, V(5259.82, 37.35, 4050.03), V(5441.95, 42.50, 4950.09)),
}

Quests[2] = {
    E(700, "Raider", "Area1Quest", 1, V(-429.54, 71.77, 1836.18), V(-728.33, 52.78, 2345.77)),
    E(725, "Mercenary", "Area1Quest", 2, V(-429.54, 71.77, 1836.18), V(-1004.32, 80.16, 1424.62)),
    E(775, "Swan Pirate", "Area2Quest", 1, V(638.44, 71.77, 918.28), V(1068.66, 137.61, 1322.11)),
    E(800, "Factory Staff", "Area2Quest", 2, V(632.70, 73.11, 918.67), V(73.08, 81.86, -27.47)),
    E(875, "Marine Lieutenant", "MarineQuest3", 1, V(-2440.80, 71.71, -3216.07), V(-2821.37, 75.90, -3070.09)),
    E(900, "Marine Captain", "MarineQuest3", 2, V(-2440.80, 71.71, -3216.07), V(-1861.23, 80.18, -3254.70)),
    E(950, "Zombie", "ZombieQuest", 1, V(-5497.06, 47.59, -795.24), V(-5657.78, 78.97, -928.69)),
    E(975, "Vampire", "ZombieQuest", 2, V(-5497.06, 47.59, -795.24), V(-6037.67, 32.18, -1340.66)),
    E(1000, "Snow Trooper", "SnowMountainQuest", 1, V(609.86, 400.12, -5372.26), V(549.15, 427.39, -5563.70)),
    E(1050, "Winter Warrior", "SnowMountainQuest", 2, V(609.86, 400.12, -5372.26), V(1142.75, 475.64, -5199.42)),
    E(1100, "Lab Subordinate", "IceSideQuest", 1, V(-6064.07, 15.24, -4902.98), V(-5707.47, 15.95, -4513.39)),
    E(1125, "Horned Warrior", "IceSideQuest", 2, V(-6064.07, 15.24, -4902.98), V(-6341.37, 15.95, -5723.16)),
    E(1175, "Magma Ninja", "FireSideQuest", 1, V(-5428.03, 15.06, -5299.43), V(-5449.67, 76.66, -5808.20)),
    E(1200, "Lava Pirate", "FireSideQuest", 2, V(-5428.03, 15.06, -5299.43), V(-5213.33, 49.74, -4701.45)),
    E(1250, "Ship Deckhand", "ShipQuest1", 1, V(1037.80, 125.09, 32911.60), V(1212.01, 150.79, 33059.25), {entrance = SHIP}),
    E(1275, "Ship Engineer", "ShipQuest1", 2, V(1037.80, 125.09, 32911.60), V(919.48, 43.54, 32779.97), {entrance = SHIP}),
    E(1300, "Ship Steward", "ShipQuest2", 1, V(968.81, 125.09, 33244.13), V(919.44, 129.56, 33436.04), {entrance = SHIP}),
    E(1325, "Ship Officer", "ShipQuest2", 2, V(968.81, 125.09, 33244.13), V(1036.02, 181.44, 33315.73), {entrance = SHIP}),
    E(1350, "Arctic Warrior", "FrostQuest", 1, V(5667.66, 26.80, -6486.09), V(5966.25, 62.97, -6179.38), {entrance = FROST}),
    E(1375, "Snow Lurker", "FrostQuest", 2, V(5667.66, 26.80, -6486.09), V(5407.07, 69.19, -6880.88)),
    E(1425, "Sea Soldier", "ForgottenQuest", 1, V(-3054.44, 235.54, -10142.82), V(-3028.22, 64.67, -9775.43)),
    E(1450, "Water Fighter", "ForgottenQuest", 2, V(-3054.44, 235.54, -10142.82), V(-3352.90, 285.02, -10534.84)),
}

Quests[3] = {
    E(1500, "Pirate Millionaire", "PiratePortQuest", 1, V(-290.07, 42.90, 5581.59), V(-245.996, 47.31, 5584.10)),
    E(1525, "Pistol Billionaire", "PiratePortQuest", 2, V(-290.07, 42.90, 5581.59), V(-187.33, 86.24, 6013.51)),
    E(1575, "Dragon Crew Warrior", "AmazonQuest", 1, V(5832.84, 51.68, -1101.52), V(6141.14, 51.35, -1340.74)),
    E(1600, "Dragon Crew Archer", "AmazonQuest", 2, V(5833.11, 51.60, -1103.07), V(6616.42, 441.77, 446.05)),
    E(1625, "Hydra Enforcer", "VenomCrewQuest", 1, V(4620.62, 1002.30, 399.09), V(4620.62, 1002.30, 399.09)),
    E(1650, "Venomous Assailant", "VenomCrewQuest", 2, V(4697.59, 1100.65, 946.40), V(4697.59, 1100.65, 946.40)),
    E(1700, "Marine Commodore", "MarineTreeIsland", 1, V(2180.54, 27.82, -6741.55), V(2286.01, 73.13, -7159.81)),
    E(1725, "Marine Rear Admiral", "MarineTreeIsland", 2, V(2179.99, 28.73, -6740.06), V(3656.77, 160.52, -7001.60)),
    E(1775, "Fishman Raider", "DeepForestIsland3", 1, V(-10581.66, 330.87, -8761.19), V(-10407.53, 331.76, -8368.52)),
    E(1800, "Fishman Captain", "DeepForestIsland3", 2, V(-10581.66, 330.87, -8761.19), V(-10994.70, 352.38, -9002.11)),
    E(1825, "Forest Pirate", "DeepForestIsland", 1, V(-13234.04, 331.49, -7625.40), V(-13274.48, 332.38, -7769.58)),
    E(1850, "Mythological Pirate", "DeepForestIsland", 2, V(-13234.04, 331.49, -7625.40), V(-13680.61, 501.08, -6991.19)),
    E(1900, "Jungle Pirate", "DeepForestIsland2", 1, V(-12680.38, 389.97, -9902.02), V(-12256.16, 331.74, -10485.84)),
    E(1925, "Musketeer Pirate", "DeepForestIsland2", 2, V(-12680.38, 389.97, -9902.02), V(-13457.90, 391.55, -9859.18)),
    E(1975, "Reborn Skeleton", "HauntedQuest1", 1, V(-9479.22, 141.22, 5566.09), V(-8763.72, 165.72, 6159.86)),
    E(2000, "Living Zombie", "HauntedQuest1", 2, V(-9479.22, 141.22, 5566.09), V(-10144.13, 138.63, 5838.09)),
    E(2025, "Demonic Soul", "HauntedQuest2", 1, V(-9516.99, 172.02, 6078.47), V(-9505.87, 172.10, 6158.99)),
    E(2050, "Posessed Mummy", "HauntedQuest2", 2, V(-9516.99, 172.02, 6078.47), V(-9582.02, 6.25, 6205.48)),
    E(2075, "Peanut Scout", "NutsIslandQuest", 1, V(-2104.39, 38.10, -10194.22), V(-2143.24, 47.72, -10029.995)),
    E(2100, "Peanut President", "NutsIslandQuest", 2, V(-2104.39, 38.10, -10194.22), V(-1859.35, 38.10, -10422.43)),
    E(2125, "Ice Cream Chef", "IceCreamIslandQuest", 1, V(-820.65, 65.82, -10965.80), V(-872.25, 65.82, -10919.96)),
    E(2150, "Ice Cream Commander", "IceCreamIslandQuest", 2, V(-820.65, 65.82, -10965.80), V(-558.06, 112.05, -11290.77)),
    E(2200, "Cookie Crafter", "CakeQuest1", 1, V(-2021.32, 37.80, -12028.73), V(-2374.14, 37.80, -12125.31)),
    E(2225, "Cake Guard", "CakeQuest1", 2, V(-2021.32, 37.80, -12028.73), V(-1598.31, 43.77, -12244.58)),
    E(2250, "Baking Staff", "CakeQuest2", 1, V(-1927.92, 37.80, -12842.54), V(-1887.81, 77.62, -12998.35)),
    E(2275, "Head Baker", "CakeQuest2", 2, V(-1927.92, 37.80, -12842.54), V(-2216.19, 82.88, -12869.29)),
    E(2300, "Cocoa Warrior", "ChocQuest1", 1, V(233.23, 29.88, -12201.23), V(-21.55, 80.57, -12352.39)),
    E(2325, "Chocolate Bar Battler", "ChocQuest1", 2, V(233.23, 29.88, -12201.23), V(582.59, 77.19, -12463.16)),
    E(2350, "Sweet Thief", "ChocQuest2", 1, V(150.51, 30.69, -12774.50), V(165.19, 76.06, -12600.84)),
    E(2375, "Candy Rebel", "ChocQuest2", 2, V(150.51, 30.69, -12774.50), V(134.87, 77.25, -12876.55)),
    E(2400, "Candy Pirate", "CandyQuest1", 1, V(-1150.04, 20.38, -14446.33), V(-1310.50, 26.02, -14562.40)),
    E(2425, "Snow Demon", "CandyQuest1", 2, V(-1150.04, 20.38, -14446.33), V(-880.20, 71.25, -14538.61)),
    E(2450, "Isle Outlaw", "TikiQuest1", 1, V(-16548.82, 55.61, -172.81), V(-16479.90, 226.61, -300.31)),
    E(2475, "Island Boy", "TikiQuest1", 2, V(-16548.82, 55.61, -172.81), V(-16849.40, 192.87, -150.79)),
    E(2500, "Sun-kissed Warrior", "TikiQuest2", 1, V(-16538, 55, 1049), V(-16347, 64, 984), {match = "kissed Warrior"}),
    E(2525, "Isle Champion", "TikiQuest2", 2, V(-16541.02, 57.31, 1051.46), V(-16602.10, 130.39, 1087.25)),
    E(2551, "Serpent Hunter", "TikiQuest3", 1, V(-16679.48, 176.75, 1474.40), V(-16679.48, 176.75, 1474.40)),
    E(2575, "Skull Slayer", "TikiQuest3", 2, V(-16759.59, 71.28, 1595.34), V(-16759.59, 71.28, 1595.34)),
    E(2600, "Reef Bandit", "SubmergedQuest1", 1, V(10882.26, -2086.32, 10034.23), V(10736.62, -2087.84, 9338.49)),
    E(2625, "Coral Pirate", "SubmergedQuest1", 2, V(10882.26, -2086.32, 10034.23), V(10965.10, -2158.88, 9177.26)),
    E(2650, "Sea Chanter", "SubmergedQuest2", 1, V(10882.26, -2086.32, 10034.23), V(10621.03, -2087.84, 10102.03)),
    E(2675, "Ocean Prophet", "SubmergedQuest2", 2, V(10882.26, -2086.32, 10034.23), V(11056.14, -2001.67, 10117.45)),
    E(2700, "High Disciple", "SubmergedQuest3", 1, V(9636.52, -1992.20, 9609.53), V(9828.09, -1940.91, 9693.06)),
    E(2725, "Grand Devotee", "SubmergedQuest3", 2, V(9636.52, -1992.20, 9609.53), V(9557.58, -1928.04, 9859.18)),
}

local function pickQuest(lvl)
    if World == 0 then return nil, "Unsupported place" end
    if World == 1 and lvl >= 700 then return nil, "Level 700+ needs Sea 2" end
    if World == 2 and lvl < 700 then return nil, "Sea 2 starts at level 700, farm in Sea 1 first" end
    if World == 2 and lvl >= 1500 then return nil, "Level 1500+ needs Sea 3" end
    if World == 3 and lvl < 1500 then return nil, "Sea 3 starts at level 1500, farm in Sea 2 first" end
    local best
    for _, e in ipairs(Quests[World]) do
        if e.min <= lvl then best = e end
    end
    return best
end

local function getHRP()
    local c = lp.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function getHum()
    local c = lp.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function notify(text)
    pcall(function()
        WindUI:Notify({Title = "HollyScriptX", Content = text, Duration = 5})
    end)
end

local CommF = RS:WaitForChild("Remotes"):WaitForChild("CommF_")

local net
local function getRemote(name)
    if not (net and net.Parent) then
        local m = RS:FindFirstChild("Modules")
        net = m and m:FindFirstChild("Net")
    end
    return net and net:FindFirstChild(name)
end

local lastEquip = 0
local function ensureTool()
    local char = lp.Character
    if not char then return nil end
    for _, t in ipairs(char:GetChildren()) do
        if t:IsA("Tool") and t.ToolTip == cfg.Weapon then
            return t
        end
    end
    if os.clock() - lastEquip > 0.4 then
        lastEquip = os.clock()
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            for _, t in ipairs(lp.Backpack:GetChildren()) do
                if t:IsA("Tool") and t.ToolTip == cfg.Weapon then
                    hum:EquipTool(t)
                    break
                end
            end
        end
    end
    return nil
end

local function getHits(origin)
    local found = {}
    local folder = workspace:FindFirstChild("Enemies")
    if not folder then return nil end
    for _, mob in ipairs(folder:GetChildren()) do
        local h = mob:FindFirstChildOfClass("Humanoid")
        local r = mob:FindFirstChild("HumanoidRootPart")
        if h and r and h.Health > 0 then
            local d = (r.Position - origin).Magnitude
            if d <= cfg.Range then
                table.insert(found, {mob = mob, root = r, dist = d})
            end
        end
    end
    if #found == 0 then return nil end
    table.sort(found, function(a, b) return a.dist < b.dist end)
    local hits, roots = {}, {}
    for i = 1, math.min(#found, cfg.MaxTargets) do
        table.insert(hits, {found[i].mob, found[i].root})
        table.insert(roots, found[i].root)
    end
    return found[1].root, hits, roots
end

local lastAtk = 0
RunService.Heartbeat:Connect(function()
    if not (cfg.Farm or cfg.FastAttack) then return end
    if os.clock() - lastAtk < cfg.Delay then return end
    lastAtk = os.clock()

    local hrp = getHRP()
    if not hrp then return end
    local tool = ensureTool()
    if not tool then return end

    local first, hits, roots = getHits(hrp.Position)
    if not first then return end

    local tip = tool.ToolTip
    if tip == "Melee" or tip == "Sword" then
        local atk = getRemote("RE/RegisterAttack")
        local hit = getRemote("RE/RegisterHit")
        if not (atk and hit) then return end
        local cdv = tool:FindFirstChild("Cooldown")
        local cd = cdv and cdv.Value or 0.25
        for _ = 1, cfg.Burst do
            atk:FireServer(cd)
            hit:FireServer(first, hits)
        end
    elseif tip == "Gun" then
        local shoot = getRemote("RE/ShootGunEvent")
        if not shoot then return end
        for _ = 1, cfg.Burst do
            shoot:FireServer(first.Position, roots)
        end
    elseif tip == "Blox Fruit" then
        local click = tool:FindFirstChild("LeftClickRemote")
        if not click then return end
        local dir = (first.Position - hrp.Position)
        if dir.Magnitude < 0.1 then return end
        for _ = 1, cfg.Burst do
            click:FireServer(dir.Unit, 1)
        end
    end
end)

local farmToken = 0
local state = {fails = {}, skip = {}, status = "Idle"}

local function tweenTo(cf)
    local hrp = getHRP()
    if not hrp then return end
    local dist = (hrp.Position - cf.Position).Magnitude
    if dist <= 120 then
        hrp.CFrame = cf
        return
    end
    local token = farmToken
    local tw = TweenService:Create(hrp, TweenInfo.new(dist / cfg.TweenSpeed, Enum.EasingStyle.Linear), {CFrame = cf})
    tw:Play()
    while tw.PlaybackState == Enum.PlaybackState.Playing do
        if token ~= farmToken or not cfg.Farm then
            tw:Cancel()
            break
        end
        task.wait()
    end
end

local function travelTo(q, pos)
    local hrp = getHRP()
    if not hrp then return end
    if q.entrance and (hrp.Position - pos).Magnitude > 2500 then
        pcall(function() CommF:InvokeServer("requestEntrance", q.entrance) end)
        task.wait(1.5)
    end
    tweenTo(CFrame.new(pos))
end

local function getMobs(q)
    local list = {}
    local folder = workspace:FindFirstChild("Enemies")
    if not folder then return list end
    for _, m in ipairs(folder:GetChildren()) do
        local h = m:FindFirstChildOfClass("Humanoid")
        local r = m:FindFirstChild("HumanoidRootPart")
        if h and r and h.Health > 0 and string.find(m.Name, q.match, 1, true) then
            table.insert(list, m)
        end
    end
    return list
end

local function spawnPos(q, from)
    local best, bd = nil, math.huge
    local ok, spawns = pcall(function()
        return workspace._WorldOrigin.EnemySpawns:GetChildren()
    end)
    if ok then
        for _, s in ipairs(spawns) do
            if s:IsA("BasePart") and string.find(s.Name, q.match, 1, true) then
                local d = (s.Position - from).Magnitude
                if d < bd then
                    bd = d
                    best = s.Position
                end
            end
        end
    end
    return best or q.mpos
end

local function questGui()
    local ok, g = pcall(function() return lp.PlayerGui.Main.Quest end)
    return ok and g or nil
end

local function questTitle(g)
    local ok, t = pcall(function() return g.Container.QuestTitle.Title.Text end)
    return ok and t or ""
end

local function stopFarm(reason)
    cfg.Farm = false
    farmToken += 1
    state.status = reason or "Stopped"
    if reason then notify(reason) end
    pcall(function() if _G.HSXFarmToggle then _G.HSXFarmToggle:Set(false) end end)
end

local function farmStep()
    local hum = getHum()
    local hrp = getHRP()
    if not hum or not hrp or hum.Health <= 0 then
        state.status = "Waiting for character"
        return
    end

    local lvl = lp.Data.Level.Value

    local q, why = pickQuest(lvl)
    if not q then
        stopFarm(why)
        return
    end

    if cfg.AutoBuso and not lp.Character:FindFirstChild("HasBuso") then
        pcall(function() CommF:InvokeServer("Buso") end)
    end

    local key = q.quest .. q.num
    local g = questGui()
    local hasQuest = g and g.Visible

    if hasQuest and not string.find(questTitle(g), q.match, 1, true) then
        pcall(function() CommF:InvokeServer("AbandonQuest") end)
        hasQuest = false
    end

    if not hasQuest and not state.skip[key] then
        state.status = "Getting quest: " .. q.quest
        travelTo(q, q.qpos)
        local hrp2 = getHRP()
        if hrp2 and (hrp2.Position - q.qpos).Magnitude <= 20 then
            pcall(function() CommF:InvokeServer("StartQuest", q.quest, q.num) end)
            task.wait(0.4)
            local g2 = questGui()
            if not (g2 and g2.Visible) then
                state.fails[key] = (state.fails[key] or 0) + 1
                if state.fails[key] >= 3 then
                    state.skip[key] = true
                    notify("Quest " .. q.quest .. " would not start, farming " .. q.mob .. " without it")
                end
            end
        end
        return
    end

    local mobs = getMobs(q)
    if #mobs == 0 then
        state.status = "Looking for " .. q.mob
        local sp = spawnPos(q, hrp.Position)
        travelTo(q, sp + Vector3.new(0, cfg.Height, 0))
        return
    end

    table.sort(mobs, function(a, b)
        return (a.HumanoidRootPart.Position - hrp.Position).Magnitude < (b.HumanoidRootPart.Position - hrp.Position).Magnitude
    end)
    local target = mobs[1]
    local lock = target.HumanoidRootPart.Position
    state.status = "Lv " .. lvl .. " | " .. q.mob .. " x" .. #mobs

    if cfg.Bring then
        pcall(function() sethiddenproperty(lp, "SimulationRadius", math.huge) end)
        for _, m in ipairs(mobs) do
            local r = m:FindFirstChild("HumanoidRootPart")
            local h = m:FindFirstChildOfClass("Humanoid")
            if r and h and (r.Position - lock).Magnitude <= 350 then
                pcall(function()
                    r.CFrame = CFrame.new(lock)
                    r.CanCollide = false
                    h.WalkSpeed = 0
                    h.JumpPower = 0
                end)
            end
        end
    end

    tweenTo(CFrame.new(lock + Vector3.new(0, cfg.Height, 0)))
end

RunService.Stepped:Connect(function()
    local c = lp.Character
    if not c then return end
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if cfg.Farm then
        for _, p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
        if hrp and not hrp:FindFirstChild("HSXFarmBV") then
            local bv = Instance.new("BodyVelocity")
            bv.Name = "HSXFarmBV"
            bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
            bv.Velocity = Vector3.zero
            bv.Parent = hrp
        end
    elseif hrp then
        local bv = hrp:FindFirstChild("HSXFarmBV")
        if bv then bv:Destroy() end
    end
end)

lp.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

local function farmLoop()
    local token = farmToken
    while cfg.Farm and token == farmToken do
        local ok, err = pcall(farmStep)
        if not ok then warn("[HSX Farm]", err) end
        task.wait(0.1)
    end
end

local Window = WindUI:CreateWindow({
    Title = "HollyScriptX",
    Author = "Blox Fruits | discord.gg/hsx",
    Icon = "swords",
    Theme = "Light",
    Size = UDim2.fromOffset(580, 460),
})

pcall(function()
    Window:SetToggleKey(Enum.KeyCode.RightShift)
end)

local FarmTab = Window:Tab({ Title = "Auto Farm", Icon = "sprout" })

local statusPara
pcall(function()
    statusPara = FarmTab:Paragraph({ Title = "Status", Desc = "Idle" })
end)

_G.HSXFarmToggle = FarmTab:Toggle({
    Title = "Auto Farm Level",
    Desc = "Quests and mobs for your level, up to the target level",
    Value = false,
    Callback = function(v)
        cfg.Farm = v
        farmToken += 1
        if v then
            if World == 0 then
                stopFarm("Unsupported place")
                return
            end
            task.spawn(farmLoop)
        else
            state.status = "Stopped"
        end
    end,
})

FarmTab:Dropdown({
    Title = "Weapon Type",
    Values = { "Melee", "Sword", "Gun", "Blox Fruit" },
    Value = "Melee",
    Callback = function(v) cfg.Weapon = v end,
})

FarmTab:Toggle({
    Title = "Bring Mobs",
    Desc = "Pull nearby mobs into one spot",
    Value = true,
    Callback = function(v) cfg.Bring = v end,
})

FarmTab:Toggle({
    Title = "Auto Buso Haki",
    Value = true,
    Callback = function(v) cfg.AutoBuso = v end,
})

FarmTab:Toggle({
    Title = "Hide UI",
    Desc = "Toggle the whole window on/off",
    Value = false,
    Callback = function(v)
        cfg.HideUI = v
        pcall(function()
            if v then
                Window:Hide()
            else
                Window:Show()
            end
        end)
    end,
})

FarmTab:Slider({
    Title = "Hover Height",
    Value = { Min = 5, Max = 50, Default = 20 },
    Step = 1,
    Callback = function(v) cfg.Height = v end,
})

FarmTab:Slider({
    Title = "Travel Speed",
    Value = { Min = 100, Max = 400, Default = 300 },
    Step = 10,
    Callback = function(v) cfg.TweenSpeed = v end,
})

local AtkTab = Window:Tab({ Title = "Fast Attack", Icon = "zap" })

AtkTab:Toggle({
    Title = "Fast Attack",
    Desc = "Works without auto farm too, uses the Weapon Type from the farm tab",
    Value = false,
    Callback = function(v) cfg.FastAttack = v end,
})

AtkTab:Slider({
    Title = "Range",
    Value = { Min = 10, Max = 200, Default = 60 },
    Step = 1,
    Callback = function(v) cfg.Range = v end,
})

AtkTab:Slider({
    Title = "Burst (hits per tick)",
    Value = { Min = 1, Max = 10, Default = 2 },
    Step = 1,
    Callback = function(v) cfg.Burst = v end,
})

AtkTab:Slider({
    Title = "Max Targets",
    Value = { Min = 1, Max = 15, Default = 8 },
    Step = 1,
    Callback = function(v) cfg.MaxTargets = v end,
})

AtkTab:Slider({
    Title = "Delay (ms, 0 = every frame)",
    Value = { Min = 0, Max = 500, Default = 0 },
    Step = 10,
    Callback = function(v) cfg.Delay = v / 1000 end,
})

task.spawn(function()
    while true do
        task.wait(1)
        if statusPara then
            pcall(function()
                statusPara:SetDesc(state.status)
            end)
        end
    end
end)

notify("Loaded. Pick a weapon type, then turn Auto Farm Level on")
