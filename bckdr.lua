-- ============================================
-- HOSHINO LIVE SCANNER v3.0 (LALOOL-STYLE)
-- ============================================

local HoshinoScanner = {
    Version = "3.0-LALOOL-EDITION",
    GitHubRaw = "https://raw.githubusercontent.com",
    BackdoorDatabase = {},
    GameSpecificSignatures = {}
}

-- ============================================
-- 1. LOAD DATABASE FROM GITHUB (SIMULATION)
-- ============================================
function HoshinoScanner:LoadDatabase()
    -- Signature backdoor dari berbagai game
    self.BackdoorDatabase = {
        -- Arsenal
        {GameId = 286090429, Signatures = {
            "Arsenal_AdminPanel",
            "A_BackdoorSystem",
            "Remote_AdminAccess"
        }},
        
        -- Prison Life
        {GameId = 155615604, Signatures = {
            "PrisonLife_GodMode",
            "PL_AdminRemote",
            "Secret_CellTeleport"
        }},
        
        -- Adopt Me
        {GameId = 920587237, Signatures = {
            "AdoptMe_UnlockAllPets",
            "AM_AdminCommands",
            "Backdoor_TradingSystem"
        }},
        
        -- Brookhaven
        {GameId = 4924922222, Signatures = {
            "Brookhaven_AdminHouse",
            "BH_SecretRoom",
            "Remote_UnlockAll"
        }}
    }
    
    -- Generic signatures (untuk semua game)
    self.GenericSignatures = {
        RemoteNames = {
            "Admin", "Backdoor", "Secret", "God", "Fly", "Noclip",
            "Unlock", "Teleport", "Bypass", "Cheat", "Hack", "Exploit",
            "OPCode", "Whitelist", "Mod", "Owner", "Root", "System"
        },
        
        ScriptPatterns = {
            "function backdoor",
            "local admin =",
            "secretkey =",
            "bypassfilter",
            "fireclickdetector"
        },
        
        PartNames = {
            "AdminBase", "SecretRoom", "Backdoor", "Hidden",
            "TeleportPad", "GodModeZone", "FlyArea"
        }
    }
end

-- ============================================
-- 2. GET CURRENT GAME INFO
-- ============================================
function HoshinoScanner:GetGameInfo()
    local placeId = game.PlaceId
    local gameName = game:GetService("MarketplaceService"):GetProductInfo(placeId).Name
    
    return {
        PlaceId = placeId,
        Name = gameName,
        IsKnownGame = false,
        SpecificSignatures = {}
    }
end

-- ============================================
-- 3. DEEP SIGNATURE SCAN
-- ============================================
function HoshinoScanner:DeepSignatureScan()
    local results = {}
    local gameInfo = self:GetGameInfo()
    
    -- Cek database untuk game ini
    for _, gameData in ipairs(self.BackdoorDatabase) do
        if gameData.GameId == gameInfo.PlaceId then
            gameInfo.IsKnownGame = true
            gameInfo.SpecificSignatures = gameData.Signatures
            break
        end
    end
    
    -- SCAN PHASE 1: Remote Objects
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            local objName = string.lower(obj.Name)
            
            -- Cek signature spesifik game
            if gameInfo.IsKnownGame then
                for _, sig in ipairs(gameInfo.SpecificSignatures) do
                    if string.find(objName, string.lower(sig)) then
                        table.insert(results, {
                            Type = "🚨 GAME-SPECIFIC BACKDOOR",
                            Object = obj:GetFullName(),
                            Signature = sig,
                            Confidence = "HIGH"
                        })
                    end
                end
            end
            
            -- Cek generic signatures
            for _, sig in ipairs(self.GenericSignatures.RemoteNames) do
                if string.find(objName, string.lower(sig)) then
                    table.insert(results, {
                        Type = "⚠️ SUSPICIOUS REMOTE",
                        Object = obj:GetFullName(),
                        Signature = sig,
                        Confidence = "MEDIUM"
                    })
                end
            end
        end
    end
    
    -- SCAN PHASE 2: Script Content (ModuleScript only)
    for _, script in pairs(game:GetDescendants()) do
        if script:IsA("ModuleScript") then
            pcall(function()
                local source = script.Source:lower()
                for _, pattern in ipairs(self.GenericSignatures.ScriptPatterns) do
                    if string.find(source, pattern:lower()) then
                        table.insert(results, {
                            Type = "💀 SUSPICIOUS CODE",
                            Object = script:GetFullName(),
                            Signature = pattern,
                            Confidence = "MEDIUM-HIGH"
                        })
                    end
                end
            end)
        end
    end
    
    -- SCAN PHASE 3: Suspicious Parts
    for _, part in pairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            local partName = string.lower(part.Name)
            for _, sig in ipairs(self.GenericSignatures.PartNames) do
                if string.find(partName, string.lower(sig)) then
                    table.insert(results, {
                        Type = "📍 SUSPICIOUS PART",
                        Object = part:GetFullName(),
                        Signature = sig,
                        Confidence = "LOW-MEDIUM"
                    })
                end
            end
        end
    end
    
    return results, gameInfo
end

-- ============================================
-- 4. ADVANCED: CHECK FOR OBFUSCATED BACKDOORS
-- ============================================
function HoshinoScanner:CheckObfuscated()
    local obfuscatedResults = {}
    
    -- Cari encoded/encrypted strings
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("StringValue") then
            local value = obj.Value
            -- Cek Base64 encoded
            if #value > 20 and value:match("^[A-Za-z0-9+/]+=*$") then
                table.insert(obfuscatedResults, {
                    Type = "🔐 BASE64 ENCODED",
                    Object = obj:GetFullName(),
                    Value = value:sub(1, 50) .. "..."
                })
            end
            
            -- Cek hex string panjang
            if #value >= 32 and value:match("^[a-fA-F0-9]+$") then
                table.insert(obfuscatedResults, {
                    Type = "⚡ HEX ENCRYPTED",
                    Object = obj:GetFullName(),
                    Value = value:sub(1, 32) .. "..."
                })
            end
        end
    end
    
    return obfuscatedResults
end

-- ============================================
-- 5. LIVE DATABASE UPDATE (SIMULASI)
-- ============================================
function HoshinoScanner:CheckForUpdates()
    -- Ini simulate aja, aslinya LALOOL beneran fetch dari GitHub
    print("[Hoshino] Checking for database updates...")
    
    -- Simulasi dapat update baru
    local newSignatures = {
        {GameId = game.PlaceId, Signatures = {"New_Backdoor_2024", "Latest_Exploit"}}
    }
    
    -- Merge dengan database existing
    for _, newSig in ipairs(newSignatures) do
        local exists = false
        for _, existing in ipairs(self.BackdoorDatabase) do
            if existing.GameId == newSig.GameId then
                exists = true
                break
            end
        end
        
        if not exists then
            table.insert(self.BackdoorDatabase, newSig)
        end
    end
    
    return #newSignatures
end

-- ============================================
-- 6. MAIN EXECUTION
-- ============================================
function HoshinoScanner:ExecuteFullScan()
    -- Load database
    self:LoadDatabase()
    
    -- Check updates
    local updates = self:CheckForUpdates()
    
    -- Get game info
    local gameInfo = self:GetGameInfo()
    
    -- Deep scan
    local scanResults, gameInfo = self:DeepSignatureScan()
    
    -- Check obfuscated
    local obfuscatedResults = self:CheckObfuscated()
    
    -- Generate report
    local report = {
        ScannerVersion = self.Version,
        GameInfo = gameInfo,
        ScanTime = os.date("%X"),
        TotalScanned = #scanResults + #obfuscatedResults,
        UpdatesAvailable = updates,
        Results = scanResults,
        Obfuscated = obfuscatedResults
    }
    
    return report
end

-- ============================================
-- 7. UI & OUTPUT
-- ============================================
function HoshinoScanner:DisplayResults(report)
    print("\n" .. string.rep("=", 50))
    print("🔥 HOSHINO LIVE SCANNER v3.0 🔥")
    print("LALOOL-STYLE BACKDOOR DETECTION")
    print(string.rep("=", 50))
    
    print("📊 GAME INFO:")
    print("   Name: " .. report.GameInfo.Name)
    print("   Place ID: " .. report.GameInfo.PlaceId)
    print("   Known Game: " .. tostring(report.GameInfo.IsKnownGame))
    
    print("\n🔍 SCAN RESULTS:")
    if #report.Results == 0 and #report.Obfuscated == 0 then
        print("   ✅ No backdoors detected")
    else
        print("   🚨 " .. report.TotalScanned .. " suspicious objects found!")
        
        for i, result in ipairs(report.Results) do
            print("   " .. i .. ". " .. result.Type)
            print("      Object: " .. result.Object)
            print("      Signature: " .. result.Signature)
            print("      Confidence: " .. result.Confidence)
        end
        
        for i, result in ipairs(report.Obfuscated) do
            print("   ⚡ " .. (#report.Results + i) .. ". " .. result.Type)
            print("      Object: " .. result.Object)
            print("      Value: " .. result.Value)
        end
    end
    
    print("\n🔄 UPDATES:")
    print("   Database signatures: " .. #HoshinoScanner.BackdoorDatabase .. " games")
    print("   New updates: " .. report.UpdatesAvailable)
    
    print("\n💡 RECOMMENDATION:")
    if report.GameInfo.IsKnownGame then
        print("   This game is in database. Check specific signatures above.")
    else
        print("   Game not in database. Using generic detection only.")
    end
    
    print(string.rep("=", 50))
    
    -- Copy to clipboard
    local summary = "Hoshino Scan - " .. report.GameInfo.Name .. "\n"
    summary = summary .. "Found: " .. report.TotalScanned .. " suspicious objects\n"
    
    pcall(function()
        setclipboard(summary)
        print("📋 Summary copied to clipboard!")
    end)
end

-- ============================================
-- 8. AUTO-RUN
-- ============================================
HoshinoScanner:LoadDatabase()
local report = HoshinoScanner:ExecuteFullScan()
HoshinoScanner:DisplayResults(report)

-- ============================================
-- 9. EXPORT FUNCTION FOR LOADSTRING
-- ============================================
return function()
    return HoshinoScanner:ExecuteFullScan()
end
