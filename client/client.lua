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

local weatherZones = {}
for k, v in ipairs(Config.WeathersZones) do
  weatherZones[k] = {
    coord = v.coord,
    radius = v.radius,
    weathertype = v.weathertype,
    timecycles = v.timecycles,
    extratimecycle = v.extratimecycle
  }
end

CreateThread(function()
  while true do
    local ped = PlayerPedId()
    local coord = GetEntityCoords(ped)
    local n = #weatherZones

    for i = 1, n do
      local zone = weatherZones[i]
      if #(coord - zone.coord) < zone.radius then
        local weathertype = zone.weathertype
        SetWeatherTypeNow(weathertype)
        SetWeatherTypeNowPersist(weathertype)
        SetOverrideWeather(weathertype)
        if zone.timecycles then
          SetTimecycleModifier(zone.timecycles)
          SetExtraTimecycleModifier(zone.extratimecycle)
        end
        while #(coord - zone.coord) < zone.radius do
          coord = GetEntityCoords(ped)
          Wait(1500)
        end
        ResetWeather()
        Wait(500)
      end
    end
    Wait(1000)
  end
end)