local function ResetWeather()
  ClearOverrideWeather()
  ClearWeatherTypePersist()
  Wait(100)
  ClearExtraTimecycleModifier()
  ClearTimecycleModifier()
  SetOverrideWeather(Config.DefaultWeather)
  SetWeatherTypeNow(Config.DefaultWeather)
  SetWeatherTypeNowPersist(Config.DefaultWeather)
end

CreateThread(function()
  while true do
      local ped = PlayerPedId()
      local coord = GetEntityCoords(ped)
      local inZone = false

      for _, zone in ipairs(Config.WeathersZones) do
          local distance = #(coord - zone.coord)
          
          if distance < zone.radius then
              inZone = true

              SetWeatherTypeNow(zone.weathertype)
              SetWeatherTypeNowPersist(zone.weathertype)
              SetOverrideWeather(zone.weathertype)

              if zone.timecycles then
                  SetTimecycleModifier(zone.timecycles)
                  if zone.extratimecycle then
                      SetExtraTimecycleModifier(zone.extratimecycle)
                  end
              end

              while #(GetEntityCoords(ped) - zone.coord) < zone.radius do
                  Wait(1500)
                  coord = GetEntityCoords(ped)
              end

              ResetWeather()
              break
          end
      end

      if not inZone then
          ResetWeather()
          Wait(1000)
      end
  end
end)