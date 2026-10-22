-- Generic dynamic light used by ACE.PlayLaunchEffect to light up launcher muzzle
-- flashes, backblast and smoke. Data:
--   Origin      - light position
--   Scale       - light radius
--   Magnitude   - light brightness
--   Start       - colour as a Vector(r, g, b)

local LightIndex = 0

local function NextLightIndex()
    LightIndex = LightIndex + 1
    if LightIndex > 64 then LightIndex = 1 end
    return LightIndex
end

function EFFECT:Init(data)
    local dlight = DynamicLight(NextLightIndex())
    if not dlight then return end

    local c = data:GetStart()
    local size = data:GetScale()
    local brightness = data:GetMagnitude()

    dlight.Pos = data:GetOrigin()
    dlight.r = c.x
    dlight.g = c.y
    dlight.b = c.z
    dlight.Brightness = brightness
    dlight.Decay = 1000 / 0.1
    dlight.Size = size
    dlight.DieTime = CurTime() + 0.06
end

function EFFECT:Think()
    return false
end

function EFFECT:Render()
end
