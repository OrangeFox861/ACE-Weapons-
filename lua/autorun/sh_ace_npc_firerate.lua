-- ACE NPC behaviour patch, applied to weapon_ace_base and every weapon derived from it.
--   * Fire rate / burst delay taken from SWEP.FireRate (base hardcodes a 0 burst delay).
--   * NPC bullet spread. The engine's default is 15 degrees, which the base never overrides.
--     Guns hide it because SWEP:GetShootDir() aims at the enemy directly, but launchers read
--     owner:GetAimVector() straight, so they inherited the full 15 degrees of scatter.
-- Per-weapon override: SWEP.NPCBulletSpread (degrees).
--
-- NOTE: the NPC firing loop runs on the AI decision cadence (g_DecisionIntervals: 0.1s at
-- AIE_NORMAL, 0.2s at AIE_EFFICIENT), so weapons with FireRate above ~10 saturate at that
-- ceiling regardless of these values. This is an engine limitation, not a bug in this patch.

local function ApplyNPCTweaks( wep )
    if not wep then return end

    function wep:GetNPCBurstSettings()
        local fr = self.FireRate
        if not fr or fr <= 0 then fr = 10 end

        local clip = (self.Primary and self.Primary.ClipSize) or 1
        local maxAllowed = math.max(1, math.floor(clip * 0.5))

        local minBurst = math.max(1, math.floor(math.min(self.NPCMinBurst or 1, maxAllowed)))
        local maxBurst = math.max(minBurst, math.floor(math.min(self.NPCMaxBurst or minBurst, maxAllowed)))

        return minBurst, maxBurst, 1 / fr
    end

    function wep:GetNPCRestTimes()
        local fr = self.FireRate
        if not fr or fr <= 0 then fr = 1 end
        return 1 / fr, 1 / fr
    end

    function wep:GetNPCBulletSpread( proficiency )
        return self.NPCBulletSpread or 1
    end
end

local function IsACEWep( name, wep )
    return name == "weapon_ace_base"
        or wep.Base == "weapon_ace_base"
        or weapons.IsBasedOn( name, "weapon_ace_base" )
end

-- Stored tables: used by weapons.Get() when it builds copies.
local function PatchStored()
    ApplyNPCTweaks( weapons.GetStored( "weapon_ace_base" ) )

    for _, wep in pairs( weapons.GetList() ) do
        if IsACEWep( wep.ClassName, wep ) then
            ApplyNPCTweaks( wep )
        end
    end
end

-- Shared baseclass tables: the tables live SWEP entities actually use.
local function PatchLive()
    for _, wep in pairs( weapons.GetList() ) do
        local name = wep.ClassName
        if IsACEWep( name, wep ) then
            -- baseclass.Get touches the SWEP/ENT globals as a side effect; keep them untouched.
            local s, e = SWEP, ENT
            SWEP, ENT = nil, nil
            local class = baseclass.Get( name )
            SWEP, ENT = s, e

            ApplyNPCTweaks( class )
        end
    end
end

PatchStored()

hook.Add( "InitPostEntity", "ACE_NPC_Tweaks", function()
    PatchStored()
    PatchLive()
end )
