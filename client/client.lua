--THREAD
local lootedNpcs = {}
CreateThread(function()
    repeat Wait(5000) until LocalPlayer.state.IsInSession

    while true do
        local sleep = 0
        local size = GetNumberOfEvents(0)
        if size > 0 then
            for i = 0, size - 1 do
                local eventAtIndex = GetEventAtIndex(0, i)

                if eventAtIndex == 1376140891 then
                    local eventStruct = DataView.ArrayBuffer(256)
                    eventStruct:SetInt32(0, 0)
                    eventStruct:SetInt32(8, 0)
                    eventStruct:SetInt32(16, 0)
                    local view = Citizen.invokeNative(0x57EC5FA4D4D6AFCA, 0, i, eventStruct:Buffer(), 3, Citizen.returnResultAnyway());
                    local entity = view[2]
                    if not GetPedAnimalType(entity) then
                        local eventDataSize = 3
                        local eventDataStruct = DataView.ArrayBuffer(128)
                        eventDataStruct:SetInt32(0, 0)
                        eventDataStruct:SetInt32(8, 0)
                        eventDataStruct:SetInt32(16, 0)
                        local is_data_exists = Citizen.InvokeNative(0x57EC5FA4D4D6AFCA, 0, i, eventDataStruct:Buffer(), eventDataSize)
                        if is_data_exists then -- can contiue
                            if PlayerPedId() == eventDataStruct:GetInt32(0) then
                                local type = GetPedType(entity)
                                if type == 4 then
                                    if Citizen.InvokeNative(0x8DE41E9902E85756, entity) then -- _IS_ENTITY_FULLY_LOOTED
                                        local netid = NetworkGetNetworkIdFromEntity(entity)
                                        if not lootedNpcs[netid] then
                                            lootedNpcs[netid] = true
                                            TriggerServerEvent("npcloot:give_reward", netid)
                                        else
                                            print("already looted")
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)

RegisterNetEvent("npcloot:looted", function(netid)
    lootedNpcs[netid] = nil
end)
