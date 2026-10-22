-- ACE launcher fire-effect system.
-- Provides ACE.PlayLaunchEffect(swep, cfg) which spawns configurable muzzle flash,
-- backblast and smoke effects for launcher-type SWEPs. Effects are spawned on the
-- server and networked to every client.
--
-- The config lives on the weapon (SWEP.LaunchEffect). Every sub-effect (Flash,
-- Backblast, Smoke, Light) accepts the following keys:
--
--   Name       string  Particle system or effect name.
--   Type       string  "effect" (util.Effect, default) or "particle" (ParticleEffect).
--   Enabled    bool    Set to false to skip this sub-effect.
--   Scale      number  Size multiplier (applied to Radius and Magnitude).
--   Radius     number  Radius passed straight to the effect (units depend on the effect).
--   Magnitude  number  Magnitude passed straight to the effect.
--   Offset     Vector  Offset in local muzzle axes (forward, right, up).
--   Angle      Angle   Extra rotation applied on top of the muzzle angle.
--   Normal     Vector  Local direction used for the effect normal (optional).
--   Reverse    bool    Use the reverse of forward as the normal (for backblast).
--   Color      Color   Start colour of the effect.
--   Entity     Entity  Optional entity passed to the effect.
--   Attach     string  Optional viewmodel attachment name used for the origin.
--   Delay      number  Seconds to wait before spawning this sub-effect.
--
-- Light additionally supports Brightness (a dlight brightness value).

ACE = ACE or {}
ACE.LaunchFX = ACE.LaunchFX or {}

if SERVER then
    AddCSLuaFile("acf/shared/sh_ace_launchfx.lua")
    AddCSLuaFile("effects/ace_launchfx_light/init.lua")
    AddCSLuaFile("effects/ace_launchflash/init.lua")
    AddCSLuaFile("effects/ace_launchsmoke/init.lua")
end

local VectorZero = Vector(0, 0, 0)

local function ResolveOrigin(swep, owner, part)
    if part.Attach and IsValid(owner) and owner.GetViewModel then
        local vm = owner:GetViewModel()
        if IsValid(vm) then
            local id = vm:LookupAttachment(part.Attach)
            if id and id > 0 then
                local att = vm:GetAttachment(id)
                if att then return att.Pos, att.Ang end
            end
        end
    end

    if IsValid(owner) then
        local aim = owner.ACE_AntiTankAim
        if aim and owner.ACE_AntiTankAimTime and CurTime() <= owner.ACE_AntiTankAimTime then
            local dir = aim - owner:GetShootPos()
            if dir:LengthSqr() > 0.01 then
                return owner:GetShootPos(), dir:Angle()
            end
        end

        return owner:GetShootPos(), owner:GetAimVector():Angle()
    end

    return swep:GetPos(), swep:GetAngles()
end

local function SpawnPart(swep, owner, part)
    local basePos, baseAng = ResolveOrigin(swep, owner, part)

    local f, r, u = baseAng:Forward(), baseAng:Right(), baseAng:Up()
    local off = part.Offset or VectorZero
    local pos = basePos + f * off.x + r * off.y + u * off.z
    local ang = baseAng + (part.Angle or angle_zero)

    local normal
    if part.Normal then
        normal = (f * part.Normal.x + r * part.Normal.y + u * part.Normal.z):GetNormalized()
    elseif part.Reverse then
        normal = -f
    else
        normal = f
    end

    if part.Type == "particle" then
        ParticleEffect(part.Name, pos, ang, swep)
        return
    end

    local scale = part.Scale or 1
    local ed = EffectData()
    ed:SetOrigin(pos)
    ed:SetAngles(ang)
    ed:SetNormal(normal)
    ed:SetScale(scale)
    ed:SetRadius((part.Radius or 0) * scale)
    ed:SetMagnitude((part.Magnitude or 0) * scale)

    if part.Color then
        ed:SetStart(Vector(part.Color.r, part.Color.g, part.Color.b))
    end

    if IsValid(part.Entity) then
        ed:SetEntity(part.Entity)
    end

    util.Effect(part.Name, ed)
end

local function SpawnLight(swep, owner, light)
    local basePos, baseAng = ResolveOrigin(swep, owner, light)
    local f, r, u = baseAng:Forward(), baseAng:Right(), baseAng:Up()
    local off = light.Offset or VectorZero
    local pos = basePos + f * off.x + r * off.y + u * off.z

    local c = light.Color or Color(255, 128, 48)
    local ed = EffectData()
    ed:SetOrigin(pos)
    ed:SetScale((light.Radius or 300) * (light.Scale or 1))
    ed:SetMagnitude(light.Brightness or 1)
    ed:SetStart(Vector(c.r, c.g, c.b))

    util.Effect("ace_launchfx_light", ed)
end

local function QueuePart(swep, owner, part, delay)
    if not part or part.Enabled == false then return end
    if not part.Name then return end

    local wait = (part.Delay or 0) + (delay or 0)
    if wait <= 0 then
        SpawnPart(swep, owner, part)
    else
        timer.Simple(wait, function()
            if IsValid(swep) then
                SpawnPart(swep, owner, part)
            end
        end)
    end
end

-- cfg is SWEP.LaunchEffect
function ACE.PlayLaunchEffect(swep, cfg)
    if not SERVER then return end
    if not IsValid(swep) or not cfg or cfg.Enabled == false then return end

    local owner = swep:GetOwner()
    if not IsValid(owner) then return end

    QueuePart(swep, owner, cfg.Flash, cfg.Delay)
    QueuePart(swep, owner, cfg.Backblast, cfg.Delay)
    QueuePart(swep, owner, cfg.Smoke, cfg.Delay)

    if cfg.Light and cfg.Light.Enabled ~= false then
        SpawnLight(swep, owner, cfg.Light)
    end
end
