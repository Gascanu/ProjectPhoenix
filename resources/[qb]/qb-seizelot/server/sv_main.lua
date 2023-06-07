local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('rhodinium-seizelot:server:GetDepotVehiclesPD', function(source, cb)
    exports.oxmysql:execute('SELECT * FROM player_vehicles WHERE state = ?', {2}, function(result)
        if not result or json.encode(result) == "[]" then cb({}) end
        cb(result)
    end)
end)

RegisterNetEvent('rhodinium-seizelot:server:ReturnVehicle', function(data)
    local plate = data.plate
    local state = 0 
    --TriggerClientEvent('QBCore:Notify', src, "Vehicle has been released at the impound", 'success')
    exports.oxmysql:execute('UPDATE player_vehicles SET state = ? WHERE plate = ?', {state, plate})
end)

RegisterNetEvent('rhodinium:server:CreateInvoice', function(billed, billerjob, billerfirstname, billiercitizenid , amount)
    local cash = tonumber(amount)
    local billedCID = billed
    -- local billerInfo = biller
    local BilledPlayer = QBCore.Functions.GetPlayerByCitizenId(billed)
    

    local resource = GetInvokingResource()
    -- print('Ai')
    -- --if not cash or not billedCID or not billerInfo then return end
    -- print('I work')
    MySQL.Async.insert('INSERT INTO phone_invoices (citizenid, amount, society, sender, sendercitizenid) VALUES (?, ?, ?, ?, ?)',{
        billedCID,
        cash,
        billerjob,
        billerfirstname,
        billiercitizenid
    }, function(id)
        if id then
            TriggerClientEvent('qb-phone:client:AcceptorDenyInvoice', BilledPlayer.PlayerData.source, id, billerfirstname, billerjob, billiercitizenid, cash, resource)
        end
    end)
end)