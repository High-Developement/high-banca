ESX = exports["es_extended"]:getSharedObject()

Citizen.CreateThread(function()
		Citizen.Wait(2000)
		for k,v in ipairs(Config.Banche)do
			local blip = AddBlipForCoord(v.x, v.y, v.z)
			SetBlipSprite (blip, v.blip)
			SetBlipDisplay(blip, 4)
			SetBlipScale  (blip, v.blipScale)
			SetBlipColour (blip, v.blipColor)
			SetBlipAsShortRange(blip, true)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString(v.blipText)
			EndTextCommandSetBlipName(blip)
		end
end)


Citizen.CreateThread(function()
    while true do
        for k, v in pairs(Config.Banche) do
          local playerPed = GetPlayerPed(-1)
          local playerPos = GetEntityCoords(playerPed)
          local markerPos = vector3(v.x, v.y, v.z)
          local distance = #(playerPos - markerPos)

          DrawMarker(
              2,
              v.x, v.y, v.z,
              0.0, 0.0, 0.0,
              0.0, 0.0, 0.0,
              0.6, 0.6, 0.6,
              0.8, 0.8, 0.8,
              255, 255, 255,
              false,
              false, false, 2, false,
              nil, nil, nil, false
          )

            if distance <= 1.5 then
              if IsControlJustReleased(0, 38) then
                  ESX.TriggerServerCallback('high_bank:requestinfo', function(bankMoney, iban)
                      if bankMoney then
                          openBank(bankMoney, iban)
                      end
                  end)
              end
            end
        end
      Wait(0)
    end
end)

openBank = function (bankMoney, iban)
    TriggerServerEvent('high_bank:creaIban')
    lib.registerContext({
        id = 'event_menu',
        title = 'Banca',
        menu = 'some_menu',
        options = {
          {
            title = 'Saldo: '..bankMoney .. '€',
          },
          {
            title = 'Iban: '..iban,
          },
          {
            title = 'Deposita',
            onSelect = function ()
                local input = lib.inputDialog('Deposita', {'inserisci l\'importo da depositare'})
 
                if not input then return end
                local depositare = input[1]
                TriggerServerEvent('high_bank:deposita', depositare)
            end,
          },
          {
            title = 'Preleva',
            onSelect = function ()
                local input = lib.inputDialog('Preleva', {'inserisci l\'importo da prelevare'})
 
                if not input then return end
                local prelevare = input[1]
                TriggerServerEvent('high_bank:preleva', prelevare)
            end,
          },
          {
            title = 'Trasferisci',
            onSelect = function ()
              local input = lib.inputDialog('Trasferisci', {'IBAN a cui trasferire l\'importo','inserisci l\'importo da trasferire'})
  
              if not input then return end
              local ibanacuitrasferire = input[1]
              local importodatrasferire = input[2]
              TriggerServerEvent('high_bank:trasferisci', ibanacuitrasferire, importodatrasferire)              
            end,
          },
        }
      })
     
    lib.showContext('event_menu')
end