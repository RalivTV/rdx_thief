---Key: https://docs.fivem.net/game-references/controls/
local Keys = {
	-- Letters
    ["A"] = 0x7065027D,
    ["B"] = 0x4CC0E2FE,
    ["C"] = 0x9959A6F0,
    ["D"] = 0xB4E465B4,
    ["E"] = 0xCEFD9220,
    ["F"] = 0xB2F377E8,
    ["G"] = 0x760A9C6F,
    ["H"] = 0x24978A28,
    ["I"] = 0xC1989F95,
    ["J"] = 0xF3830D8E,
    -- Missing K, don't know if anything is actually bound to it
    ["L"] = 0x80F28E95,
    ["M"] = 0xE31C6A41,
    ["N"] = 0x4BC9DABB, -- Push to talk key
    ["O"] = 0xF1301666,
    ["P"] = 0xD82E0BD2,
    ["Q"] = 0xDE794E3E,
    ["R"] = 0xE30CD707,
    ["S"] = 0xD27782E3,
    -- Missing T
    ["U"] = 0xD8F73058,
    ["V"] = 0x7F8D09B8,
    ["W"] = 0x8FD015D8,
    ["X"] = 0x8CC9CD42,
    -- Missing Y
    ["Z"] = 0x26E9DC00,

    -- Symbol Keys
    ["RIGHTBRACKET"] = 0xA5BDCD3C,
    ["LEFTBRACKET"] = 0x430593AA,
    -- Mouse buttons
    ["MOUSE1"] = 0x07CE1E61,
    ["MOUSE2"] = 0xF84FA74F,
    ["MOUSE3"] = 0xCEE12B50,
    ["MWUP"] = 0x3076E97C,
    -- Modifier Keys
    ["CTRL"] = 0xDB096B85,
    ["TAB"] = 0xB238FE0B,
    ["SHIFT"] = 0x8FFC75D6,
    ["SPACEBAR"] = 0xD9D0E1C0,
    ["ENTER"] = 0xC7B5340A,
    ["BACKSPACE"] = 0x156F7119,
    ["LALT"] = 0x8AAA0AD4,
    ["DEL"] = 0x4AF4D473,
    ["PGUP"] = 0x446258B6,
    ["PGDN"] = 0x3C3DD371,
    -- Function Keys
    ["F1"] = 0xA8E3F467,
    ["F4"] = 0x1F6D95E5,
    ["F6"] = 0x3C0A40F2,
    -- Number Keys
    ["1"] = 0xE6F612E4,
    ["2"] = 0x1CE6D9EB,
    ["3"] = 0x4F49CC4C,
    ["4"] = 0x8F9F9E58,
    ["5"] = 0xAB62E997,
    ["6"] = 0xA1FDE2A6,
    ["7"] = 0xB03A913B,
    ["8"] = 0x42385422,
    -- Arrow Keys
    ["DOWN"] = 0x05CA7C52,
    ["UP"] = 0x6319DB71,
    ["LEFT"] = 0xA65EBAB4,
    ["RIGHT"] = 0xDEB34313
}

local canHandsUp = true
local handsup = false

AddEventHandler('handsup:toggle', function(param)
	canHandsUp = param
end)

Citizen.CreateThread(function()


	while true do
		Citizen.Wait(0)

		if canHandsUp then
			if IsControlJustReleased(0, Keys['X']) then
				local playerPed = PlayerPedId()

				RequestAnimDict('random@mugging3')
				while not HasAnimDictLoaded('random@mugging3') do
					Citizen.Wait(100)
				end

				if not handsup then
					handsup = true
					TaskPlayAnim(playerPed, 'random@mugging3', 'handsup_standing_base', 6.0, -6.0, -1, 49, 0, 0, 0, 0)
					TriggerServerEvent('rdx_thief:update', handsup)
					HaendeHoch()
				else
					handsup = false
					ClearPedSecondaryTask(playerPed)
					TriggerServerEvent('rdx_thief:update', handsup)
				end
			end
		end
	end
end)

function HaendeHoch()
	Citizen.CreateThread(function()
		while handsup do
			Citizen.Wait(1)
			DisableControlAction(0, 1, true) 				-- Disable pan
			DisableControlAction(0, 2, true) 				-- Disable tilt
			DisableControlAction(0, 24, true) 				-- Attack
			DisableControlAction(0, 257, true) 				-- Attack 2
			DisableControlAction(0, 25, true) 				-- Aim
			DisableControlAction(0, 263, true) 				-- Melee Attack 1

			DisableControlAction(0, Keys['R'], true) 		-- Reload
			DisableControlAction(0, Keys['SPACE'], true) 	-- Jump
			DisableControlAction(0, Keys['TAB'], true) 		-- Select Weapon
			DisableControlAction(0, Keys['F'], true) 		-- Also 'enter'?

			DisableControlAction(0, Keys['F2'], true) 		-- Inventory
			DisableControlAction(0, Keys['F3'], true) 		-- Animations
			DisableControlAction(0, Keys['F5'], true) 		-- Bag
			DisableControlAction(0, Keys['F6'], true) 		-- Job & Panicbutton
			DisableControlAction(0, Keys['F7'], true) 		-- Billing
			DisableControlAction(0, Keys['F9'], true) 		-- Job

			DisableControlAction(0, Keys['V'], true) 		-- Disable changing view
			DisableControlAction(0, Keys['C'], true) 		-- Disable looking behind
			DisableControlAction(2, Keys['P'], true)		-- Disable pause screen

			DisableControlAction(0, 59, true) 				-- Disable steering in vehicle
			DisableControlAction(0, 71, true) 				-- Disable driving forward in vehicle
			DisableControlAction(0, 72, true) 				-- Disable reversing in vehicle

			DisableControlAction(2, Keys['LEFTCTRL'], true) -- Disable going stealth

			DisableControlAction(0, 47, true)  				-- Disable weapon
			DisableControlAction(0, 264, true) 				-- Disable melee
			DisableControlAction(0, 257, true) 				-- Disable melee
			DisableControlAction(0, 140, true) 				-- Disable melee
			DisableControlAction(0, 141, true) 				-- Disable melee
			DisableControlAction(0, 142, true) 				-- Disable melee
			DisableControlAction(0, 143, true) 				-- Disable melee
			DisableControlAction(0, 75, true)  				-- Disable exit vehicle
			DisableControlAction(27, 75, true) 				-- Disable exit vehicle
		end
	end)
end
