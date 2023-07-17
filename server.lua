---@diagnostic disable: undefined-global

local VORPcore = {}
TriggerEvent("getCore", function(core)
    VORPcore = core
end)

local Inventory = exports.vorp_inventory:vorp_inventoryApi()


RegisterServerEvent('npcloot:give_reward', function(data)
    if data ~= 1 then -- change this number acording to  your client side  cheaters can see this so do a new number and in client as well on this event they must match
        return print("cheater detected Id:", _source, GetPlayerName(_source), GetPlayerIdentifiers(_source))
    end

    local _source = source
    local User = VORPcore.getUser(_source)

    if not User then
        return
    end

    local Character = User.getUsedCharacter

    if not Config.canreceiveWeapons then
        goto continue
    end
    local chance = math.random(1, Config.ChaceGettingWeapon)
    if chance < Config.receiveWeapon then
        local ammo = { ["nothing"] = 0 }
        local reward1 = Config.weapons
        local chance1 = math.random(1, #reward1)

        Inventory.canCarryWeapons(_source, 1, function(cb)
            if not cb then
                return VORPcore.NotifyRightTip(_source, Config.Translate.invFull, 3000)
            end
        end)

        Inventory.createWeapon(_source, Config.weapons[chance1].name, ammo, {})
        VORPcore.NotifyRightTip(_source, Config.Translate.youGot .. " " .. Config.weapons[chance1].label, 3000)
    end

    ::continue::

    if not Config.canreceiveMoney then
        goto continue1
    end
    local chance1 = math.random(1, Config.ChanceGettingMoney)
    if chance1 < Config.receiveMoney then
        local item_type = math.random(1, #Config.money)
        Character.addCurrency(0, Config.money[item_type])
        VORPcore.NotifyRightTip(_source, Config.Translate.youGot .. " " .. string.format("%.2f", Config.money[item_type]) .. "$", 2000)
    end

    ::continue1::

    if not Config.canreceiveGold then
        goto continue2
    end
    local chance2 = math.random(1, Config.ChanceGettingGold)
    if chance2 < Config.receiveGold then
        local item_type = math.random(1, #Config.gold)
        Character.addCurrency(1, Config.gold[item_type])
        VORPcore.NotifyRightTip(_source, Config.Translate.youGot .. " " .. Config.gold[item_type] .. " " .. Config.Translate.nugget, 2000)
    end

    ::continue2::

    if not Config.canreceiveItems then
        return
    end

    local chance3 = math.random(1, Config.ChanceGettingItem)
    if chance3 < Config.receiveItem then
        local chance4 = math.random(1, #Config.items)
        local count = 1
        local canCarry = Inventory.canCarryItems(_source, count)                             --can carry inv space
        local canCarry2 = Inventory.canCarryItem(_source, Config.items[chance4].name, count) --cancarry item limit

        if not canCarry then
            return VORPcore.NotifyRightTip(_source, Config.Translate.invFullItems .. " " .. Config.items[chance4].label, 30000)
        end

        if not canCarry2 then
            return VORPcore.NotifyRightTip(_source, Config.Translate.invFullItems .. " " .. Config.items[chance4].label, 30000)
        end

        Inventory.addItem(_source, Config.items[chance4].name, count)
        VORPcore.NotifyRightTip(_source, Config.Translate.youGot .. " " .. Config.items[chance4].label, 3000)
    end
end)
