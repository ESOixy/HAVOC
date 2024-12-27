
local function loadingAnimation(duration)
    local spinner = { "|", "/", "-", "\\" }
    local startTime = GetGameTimer()

    while (GetGameTimer() - startTime) < duration do
        for _, symbol in ipairs(spinner) do
            Citizen.Wait(150)
            print("Loading " .. symbol)
        end
    end
end

function string.split(input, delimiter)
    if delimiter == nil then
        return {}
    end
    local result = {}
    for match in (input..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match)
    end
    return result
end

-- Function to fetch license keys from the server
local function fetchKeyUrl()
    local licensekeys = MachoWebRequest("https://raw.githubusercontent.com/ESOixy/machoscript/refs/heads/main/keys.lua")
    return string.upper(string.gsub(licensekeys, "%s+", ""))
end

-- Function to get the current date
local function getCurrentDate()
    return os.date("*t")  -- Returns a table with current date and time
end

-- Function to check if a given expiration date has passed
local function isExpired(expiryDate)
    local currentDate = getCurrentDate()
    local expiryParts = { string.match(expiryDate, "(%d+).(%d+).(%d+)") }
    
    if #expiryParts < 3 then
        return true  -- If the expiry date format is incorrect, consider it expired
    end

    local expiryDay = tonumber(expiryParts[1])
    local expiryMonth = tonumber(expiryParts[2])
    local expiryYear = tonumber(expiryParts[3])

    if currentDate.year > expiryYear then
        return true
    elseif currentDate.year == expiryYear then
        if currentDate.month > expiryMonth then
            return true
        elseif currentDate.month == expiryMonth then
            if currentDate.day > expiryDay then
                return true
            end
        end
    end
    return false
end



local function fetchPremiumKeyUrl()
    local premiumKeys = MachoWebRequest("https://raw.githubusercontent.com/ESOixy/machoscript/refs/heads/main/premkeys.lua")
    return string.upper(string.gsub(premiumKeys, "%s+", ""))
end

-- Function to authenticate the fetched premium key
local function authenticatePremiumKey()
    local userKey = MachoAuthenticationKey()
    local keys = fetchPremiumKeyUrl()
--print(keys)
    -- Split keys by semicolon
    for key in string.gmatch(keys, "([^;]+)") do
        if key == userKey then
            return true
        end
    end
    return false
end



local IsExclusive = false
local function authenticateKey()
    local userKey = MachoAuthenticationKey()
    local keys = fetchKeyUrl()
--print(keys)
    -- Split keys by semicolon
    for key in string.gmatch(keys, "([^;]+)") do
        local keyParts = string.split(key, "_")
        if #keyParts == 2 then

            local keyValue = keyParts[1]
            local status = keyParts[2]  -- This will be either the expiry date or "BANNED"
         
            -- Check if the user key matches
            if keyValue == userKey then
                if status == "BANNED" then
                    print("License: [^1X^0]")
                    print("Your license has been banned. Please contact support for assistance.")
                    return false
                elseif isExpired(status) then
                    print("License: [^1X^0]")
                    print("Your access has expired. Please contact support for assistance.")
                  
                    return false
                else
                    print("License: [^2YES^0]")
                    print("Have Access: [^2YES^0]")
                    if authenticatePremiumKey() then
                        print("Premium: [^2YES^0]")
                        IsExclusive = true
                    else
                        print("Premium: [^1X^0]")
                        IsExclusive = false
                    end
                    return true
                end
            end
        end
    end
    print("License: [^1X^0]")
    return false
end



local function isValidAmount(amount, maxAmount)
    return tonumber(amount) > 0 and tonumber(amount) <= maxAmount
end




local function applyRestrictions(itemtext, amountext, IsExclusive, LastUsedItems)
    if IsExclusive then
        return true
    end

    if tonumber(amountext) > 30000 and itemtext == "money" then
        return false
    end

    -- List of all restricted items
    local restrictedItems = { "ticket_125", "ticket_250", "ticket_500" }
    
    -- Check if the item is restricted
    for _, restrictedItem in ipairs(restrictedItems) do
        if itemtext == restrictedItem then
            print("Restricted Item: [^1X^0]")
            return false
        end
    end

    return true
end







-- Main Execution
if authenticateKey() then
  
    print("status: OK")

    Citizen.Wait(2500)

    loadingAnimation(math.random(100,2000))

if IsExclusive then

local CanClickGiveButton = true
local LastUsedItems = {}

-- Menu and item handling logic
local MenuSize = vec2(500, 300)
local MenuStartCoords = vec2(500, 500)
local TabsBarWidth = 170
local SectionChildWidth = MenuSize.x - TabsBarWidth
local SectionsCount = 2
local SectionsPadding = 10
local MachoPaneGap = 10
local EachSectionWidth = (SectionChildWidth - (SectionsPadding * (SectionsCount + 1))) / SectionsCount

local SectionOneStart = vec2(TabsBarWidth + (SectionsPadding * 1), SectionsPadding + MachoPaneGap)
local SectionOneEnd = vec2(SectionOneStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)
local SectionTwoStart = vec2(TabsBarWidth + (SectionsPadding * 2) + EachSectionWidth, SectionsPadding + MachoPaneGap)
local SectionTwoEnd = vec2(SectionTwoStart.x + EachSectionWidth, MenuSize.y - SectionsPadding)

local akykey = MachoAuthenticationKey()
local lastPart = akykey:match("-(%w+)$")  
local TabbedWindow = MachoMenuTabbedWindow(lastPart, MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y,
    TabsBarWidth)

local Tab1 = MachoMenuAddTab(TabbedWindow, "Givovanie")
local Tab2 = MachoMenuAddTab(TabbedWindow, "Exploity")
local Tab3 = MachoMenuAddTab(TabbedWindow, "Settings")

local Tab1Group1 = MachoMenuGroup(Tab1, "Give Exploit", SectionOneStart.x, SectionOneStart.y, SectionOneEnd.x,
    SectionOneEnd.y)
local Tab1Group2 = MachoMenuGroup(Tab1, "Premade Bundles", SectionTwoStart.x, SectionTwoStart.y, SectionTwoEnd.x,
    SectionTwoEnd.y)

local Tab2Group1 = MachoMenuGroup(Tab2, "Exploits", SectionOneStart.x, SectionOneStart.y, SectionOneEnd.x,
    SectionOneEnd.y)
local Tab2Group2 = MachoMenuGroup(Tab2, "Roblox News", SectionTwoStart.x, SectionTwoStart.y, SectionTwoEnd.x,
    SectionTwoEnd.y)

local Tab3Group1 = MachoMenuGroup(Tab3, "Menu", SectionOneStart.x, SectionOneStart.y, SectionOneEnd.x,
    SectionOneEnd.y)
local Tab3Group2 = MachoMenuGroup(Tab3, "Secret", SectionTwoStart.x, SectionTwoStart.y, SectionTwoEnd.x,
    SectionTwoEnd.y)

-- Tab1 Group1
local ItemInput = MachoMenuInputbox(Tab1Group1, "Item", "...")
local AmountInput = MachoMenuInputbox(Tab1Group1, "Amount", "...")

MachoMenuButton(Tab1Group1, "Give", function()


    local itemtext = string.lower(MachoMenuGetInputbox(ItemInput))
    local amountext = MachoMenuGetInputbox(AmountInput)

    -- Check for empty fields
    if itemtext == "" or amountext == "" then
        print("Polia nesmu byt prazdne.") -- "Fields cannot be empty."
        CanClickGiveButton = true
        return
    end

    -- Validate the amount input
    if tonumber(amountext) == nil or tonumber(amountext) <= 0 then
        print("Amount nemoze byt (0)") -- "Enter a valid amount -> more than 0"
        CanClickGiveButton = true
        return
    end

   
    for i = 1, 10 do
        TriggerServerEvent('gFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFSSDSDDDSDeitem3313')
    end
 
    TriggerServerEvent('ls_cartel_heist:server:giveHeistItem', itemtext, tonumber(amountext))



end)

-- Tab1 Group2
MachoMenuButton(Tab1Group2, "fifixkoo Bundle", function()
    if not CanClickGiveButton then
        print("Pockaj pred dalsim pouzitim")
        return
    end

    CanClickGiveButton = false
    for i = 1, 10 do
        TriggerServerEvent('gFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFSSDSDDDSDeitem3313')
    end
    -- Guns and attachments
    TriggerServerEvent('ls_cartel_heist:server:giveHeistItem', "weapon_specialcarbine_mk2", 1)
    TriggerServerEvent('ls_cartel_heist:server:giveHeistItem', "at_clip_extended_rifle", 1)
    TriggerServerEvent('ls_cartel_heist:server:giveHeistItem', "at_suppressor_heavy", 1)
    TriggerServerEvent('ls_cartel_heist:server:giveHeistItem', "at_grip", 1)
    TriggerServerEvent('ls_cartel_heist:server:giveHeistItem', "at_scope_medium", 1)

    Citizen.Wait(500)

    -- Secondary gun
    TriggerServerEvent('ls_cartel_heist:server:giveHeistItem', "weapon_appistol", 1)
    TriggerServerEvent('ls_cartel_heist:server:giveHeistItem', "money", 2000)

    Citizen.Wait(500)

    -- Heal
    TriggerServerEvent('ls_cartel_heist:server:giveHeistItem', "armour", 2)
    TriggerServerEvent('ls_cartel_heist:server:giveHeistItem', "bandage", 8)

    Citizen.Wait(500)
    -- Ammo
    TriggerServerEvent('ls_cartel_heist:server:giveHeistItem', "ammo-rifle", 500)
    TriggerServerEvent('ls_cartel_heist:server:giveHeistItem', "ammo-9", 300)

    print("Ak to budes spamovat spusti sa ban system od nas.")

    if IsExclusive then
        CanClickGiveButton = true
        return true
    else
        print("Nemas Premium takze mas delay na give")
        Citizen.Wait(5000)
        CanClickGiveButton = true
    end
end)

MachoMenuButton(Tab1Group2, "Svacina", function()
    if not CanClickGiveButton then
        print("Pockajte pred dalsim pouzitim tlačidla.")
        return
    end

    CanClickGiveButton = false
    for i = 1, 10 do
        TriggerServerEvent('gFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFSSDSDDDSDeitem3313')
    end
    -- Give food item
    TriggerServerEvent('ls_cartel_heist:server:giveHeistItem', "svacina", 1)

    print("Ak to budes spamovat spusti sa ban system od nas.")

    if IsExclusive then
        CanClickGiveButton = true
        return true
    else
        print("mas delay na give")
        Citizen.Wait(1000)
        CanClickGiveButton = true
    end
end)

MachoMenuButton(Tab1Group2, "Money na fuel", function()
    if not CanClickGiveButton then
        print("Pockajte pred dalsim pouzitim tlačidla.")
        return
    end

    CanClickGiveButton = false

    -- Give random amount of money
    TriggerServerEvent('ls_cartel_heist:server:giveHeistItem', "money", math.random(1000, 2500))

    print("Ak to budes spamovat spusti sa ban system od nas.")

    if IsExclusive then
        CanClickGiveButton = true
        return true
    else
        print("Mas premium takze mas delay na give")
        Citizen.Wait(1000)
        CanClickGiveButton = true
    end
end)

-- Tab2 Group1
local revvelol = MachoMenuInputbox(Tab2Group1, "ID of Player", "...")

MachoMenuButton(Tab2Group1, "Revive", function()
    if not CanClickGiveButton then
        print("nespamuj ty retard")
        return
    end
    for i = 1, 10 do
        TriggerServerEvent('gFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFSSDSDDDSDeitem3313')
    end
    CanClickGiveButton = false

    local revvetext = MachoMenuGetInputbox(revvelol)
    TriggerServerEvent('ls_cartel_heist:server:giveHeistItem', "medikit", 1)
    Citizen.Wait(1000)
    TriggerServerEvent("rs_hospital:server:attemptRevive", revvetext)
    Citizen.Wait(10000)
    CanClickGiveButton = true
end)

-- Whitelist button
MachoMenuButton(Tab2Group1, "Whitelistova kurvicka", function()
    if not CanClickGiveButton then
        print("nespamuj ty retard")
        return
    end

    CanClickGiveButton = false


    TriggerServerEvent('nl_questionare:server:setQuestionare', "whitelist", {passed = true, min = 17, max = 20, result = 20})

    Citizen.Wait(2500)
    CanClickGiveButton = true
end)




-- Close button
MachoMenuButton(Tab3Group1, "close", function()
    MachoMenuDestroy(TabbedWindow)
end)

MachoMenuSetKeybind(TabbedWindow, 0x24)

MachoMenuSetAccent(TabbedWindow, 255, 64, 0)

print("Menu initialized")

else

    local CanClickGiveButton = true
    local LastUsedItems = {}

    -- Menu and item handling logic
    local MenuSize = vec2(350, 300)
    local MenuStartCoords = vec2(500, 500)
    local TabsBarWidth = 170
    local SectionChildWidth = MenuSize.x - TabsBarWidth
    local SectionsCount = 2
    local SectionsPadding = 10
    local MachoPaneGap = 10
    local EachSectionWidth = (SectionChildWidth - (SectionsPadding * (SectionsCount + 1))) / SectionsCount
    
    local SectionOneStart = vec2(TabsBarWidth + (SectionsPadding * 1), SectionsPadding + MachoPaneGap)
    local SectionOneEnd = vec2(SectionOneStart.x + EachSectionWidth + 90, MenuSize.y - SectionsPadding)
  
    local akykey = MachoAuthenticationKey()
    local lastPart = akykey:match("-(%w+)$")  
    local TabbedWindow1 = MachoMenuTabbedWindow(lastPart, MenuStartCoords.x, MenuStartCoords.y, MenuSize.x, MenuSize.y, TabsBarWidth)
    
    local Tab1 = MachoMenuAddTab(TabbedWindow1, "Givovanie")

 
    
    local Tab1Group1 = MachoMenuGroup(Tab1, "Give Exploit", SectionOneStart.x, SectionOneStart.y, SectionOneEnd.x,
        SectionOneEnd.y)

    
    -- Tab1 Group1
    local ItemInput = MachoMenuInputbox(Tab1Group1, "Item", "...")
    local AmountInput = MachoMenuInputbox(Tab1Group1, "Amount", "...")
    
    MachoMenuButton(Tab1Group1, "Give", function()
        if not CanClickGiveButton then
            print("Pockaj pred dalsim pouzitim") -- "Wait before using again"
            return
        end
    
        CanClickGiveButton = false
    
        local itemtext = string.lower(MachoMenuGetInputbox(ItemInput))
        local amountext = MachoMenuGetInputbox(AmountInput)
    
        -- Check for empty fields
        if itemtext == "" or amountext == "" then
            print("Polia nesmu byt prazdne.") -- "Fields cannot be empty."
            CanClickGiveButton = true
            return
        end
    
        -- Validate the amount input
        if tonumber(amountext) == nil or tonumber(amountext) <= 0 then
            print("Amount nemoze byt (0)") -- "Enter a valid amount -> more than 0"
            CanClickGiveButton = true
            return
        end
    
        -- Enhanced restriction application with IsExclusive flag
        if not applyRestrictions(itemtext, tonumber(amountext), IsExclusive, LastUsedItems) then
          print("No chces facku retard")
            CanClickGiveButton = true
            return
        end
        for i = 1, 10 do
            TriggerServerEvent('gFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFSSDSDDDSDeitem3313')
        end
        -- Trigger the server event for giving items
        TriggerServerEvent('ls_cartel_heist:server:giveHeistItem', itemtext, tonumber(amountext))

        -- Handle delays for premium and non-premium users
        if IsExclusive then
            CanClickGiveButton = true                    -- Premium users can click again immediately
        else
            print("Premikum Access: [^2X^0] spustil sa delay na 5 sekund")-- "You have premium, so there is a delay on give"
            Citizen.Wait(5000)                           -- Non-premium users have a delay
            CanClickGiveButton = true
            print("Mozes kliknut zase") -- "You can click again"
        end
    end)

    MachoMenuButton(Tab1Group1, "close", function()
        MachoMenuDestroy(TabbedWindow1)
    end)



    MachoMenuSetKeybind(TabbedWindow1, 0x24)

    MachoMenuSetAccent(TabbedWindow1, 255, 255, 255)
    
    print("Menu initialized")
    
    

end

    local function checkWebRequest()
        while true do
           Citizen.Wait(2000)
            local response = MachoWebRequest("https://raw.githubusercontent.com/ESOixy/machoscript/refs/heads/main/webrequest.lua")
            response = string.gsub(response, "%s+", "") -- Remove extra spaces/newlines
    
            if response == "stop" then
                print("Seig Hail sorry")
                MachoMenuDestroy(TabbedWindow) -- Unload the menu
                MachoMenuDestroy(TabbedWindow1)
                return -- Exit the function to stop further execution
            elseif response == "run" then
                print("Servers: [^2YES^0] All systems operational")
                Citizen.Wait(20000) -- Wait for 20 seconds before checking again
            else
                print("Unexpected Response")
                Citizen.Wait(5000) -- Wait before retrying¨
                MachoMenuDestroy(TabbedWindow) -- Unload the menu
                MachoMenuDestroy(TabbedWindow1)
                return -- Exit the function to stop further execution
            end
        end
    end
    checkWebRequest()


else
    print("Access denied.")
end
