RDX 				= nil
local Users         = {}

---- MENU

TriggerEvent('rdx:getSharedObject', function(obj) RDX = obj end)

RegisterServerEvent('cuffServer')
AddEventHandler('cuffServer', function(closestID)
	TriggerClientEvent('cuffClient', closestID)
end)

RegisterServerEvent('unCuffServer')
AddEventHandler('unCuffServer', function(closestID)
	TriggerClientEvent('unCuffClient', closestID)
end)

RegisterServerEvent('dragServer')
AddEventHandler('dragServer', function(target)
  local _source = source
  TriggerClientEvent('cuffscript:drag', target, _source)
end)

RDX.RegisterUsableItem('kajdanki', function(source)

	local xPlayer = RDX.GetPlayerFromId(source)

	TriggerClientEvent('cuffs:OpenMenu', source)
end)

---- END MENU


RDX.RegisterServerCallback('rdx_thief:getValue', function(source, cb, targetSID)
    if Users[targetSID] then
        cb(Users[targetSID])
    else
        cb({value = false, time = 0})
    end
end)

RDX.RegisterServerCallback('rdx_thief:getOtherPlayerData', function(source, cb, target)

    local xPlayer = RDX.GetPlayerFromId(target)

    local data = {
      name        = GetPlayerName(target),
      inventory   = xPlayer.inventory,
      accounts    = xPlayer.accounts,
      money       = xPlayer.get('money'),
      weapons     = xPlayer.loadout

    }

      cb(data)

end)


RegisterServerEvent('rdx_thief:stealPlayerItem')
AddEventHandler('rdx_thief:stealPlayerItem', function(target, itemType, itemName, amount)

    local sourceXPlayer = RDX.GetPlayerFromId(source)
    local targetXPlayer = RDX.GetPlayerFromId(target)

    if itemType == 'item_standard' then
        print("item_standard")

        local label = sourceXPlayer.getInventoryItem(itemName).label
        local itemLimit = sourceXPlayer.getInventoryItem(itemName).limit
        local sourceItemCount = sourceXPlayer.getInventoryItem(itemName).count
        local targetItemCount = targetXPlayer.getInventoryItem(itemName).count

        if amount > 0 and targetItemCount >= amount then
    
            if itemLimit ~= -1 and (sourceItemCount + amount) > itemLimit then
                TriggerClientEvent('rdx:showNotification', targetXPlayer.source, _U('ex_inv_lim_target'))
                TriggerClientEvent('rdx:showNotification', sourceXPlayer.source, _U('ex_inv_lim_source'))
            else

                targetXPlayer.removeInventoryItem(itemName, amount)
                sourceXPlayer.addInventoryItem(itemName, amount)

                TriggerClientEvent('rdx:showNotification', sourceXPlayer.source, _U('you_stole') .. ' ~g~x' .. amount .. ' ' .. label .. ' ~w~' .. _U('from_your_target') )
                TriggerClientEvent('rdx:showNotification', targetXPlayer.source, _U('someone_stole') .. ' ~r~x'  .. amount .. ' ' .. label )

            end

        else
             TriggerClientEvent('rdx:showNotification', _source, _U('invalid_quantity'))
        end

    end

  if itemType == 'item_money' then

    if amount > 0 and targetXPlayer.get('money') >= amount then

      targetXPlayer.removeMoney(amount)
      sourceXPlayer.addMoney(amount)

      TriggerClientEvent('rdx:showNotification', sourceXPlayer.source, _U('you_stole') .. ' ~g~$' .. amount .. ' ~w~' .. _U('from_your_target') )
      TriggerClientEvent('rdx:showNotification', targetXPlayer.source, _U('someone_stole') .. ' ~r~$'  .. amount )

    else
      TriggerClientEvent('rdx:showNotification', _source, _U('imp_invalid_amount'))
    end

  end

  if itemType == 'item_account' then

    if amount > 0 and targetXPlayer.getAccount(itemName).money >= amount then

        targetXPlayer.removeAccountMoney(itemName, amount)
        sourceXPlayer.addAccountMoney(itemName, amount)

        TriggerClientEvent('rdx:showNotification', sourceXPlayer.source, _U('you_stole') .. ' ~g~$' .. amount .. ' ~w~' .. _U('of_black_money') .. ' ' .. _U('from_your_target') )
        TriggerClientEvent('rdx:showNotification', targetXPlayer.source, _U('someone_stole') .. ' ~r~$'  .. amount .. ' ~w~' .. _U('of_black_money') )

    else
        TriggerClientEvent('rdx:showNotification', _source, _U('imp_invalid_amount'))
    end

  end

  if itemType == 'item_weapon' then
    print("Item_weapon")
    if amount == nil then amount = 0 end

        targetXPlayer.removeWeapon(itemName, amount)
        sourceXPlayer.addWeapon(itemName, amount)

        TriggerClientEvent('rdx:showNotification', sourceXPlayer.source, _U('you_stole') .. ' ~g~x' .. amount .. ' ' .. label .. ' ~w~' .. _U('from_your_target') )
        TriggerClientEvent('rdx:showNotification', targetXPlayer.source, _U('someone_stole') .. ' ~r~x'  .. amount .. ' ' .. label )
  end
end)

RegisterServerEvent("rdx_thief:update")
AddEventHandler("rdx_thief:update", function(bool)
	local source = source
	Users[source] = {value = bool, time = os.time()}
end)

RegisterServerEvent("rdx_thief:getValue")
AddEventHandler("rdx_thief:getValue", function(targetSID)
    local source = source
	if Users[targetSID] then
		TriggerClientEvent("rdx_thief:returnValue", source, Users[targetSID])
	else
		TriggerClientEvent("rdx_thief:returnValue", source, Users[targetSID])
	end
end)


---- HANDCUFFS + ROPE ----

RDX.RegisterServerCallback('rdx_thief:getItemQ', function(source, cb, item)
    local xPlayer = RDX.GetPlayerFromId(source)
    local quantity = xPlayer.getInventoryItem(item).count
    cb(quantity)
end)