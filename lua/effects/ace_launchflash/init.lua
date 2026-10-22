-- Scalable launcher muzzle/launch flash used by ACE.PlayLaunchEffect.
-- Size is taken from EffectData radius (already multiplied by Scale in the module).
-- No sound is played here so the launch keeps only the weapon/missile audio.
-- Data:
--   Origin  - flash position
--   Normal  - forward direction of the flash
--   Radius  - base size in units (preferred)
--   Scale   - size multiplier used when Radius is not supplied

function EFFECT:Init(data)
    self.Origin = data:GetOrigin()
    self.Dir = data:GetNormal() or Vector(1, 0, 0)
    if self.Dir:LengthSqr() == 0 then
        self.Dir = Vector(1, 0, 0)
    end
    self.Dir = self.Dir:GetNormalized()

    local size = data:GetRadius()
    if not size or size <= 0 then
        size = (data:GetScale() or 1) * 50
    end
    self.Size = size

    local emitter = ParticleEmitter(self.Origin)
    if not emitter then return end

    local dir = self.Dir
    local origin = self.Origin

    -- Hot core / flame
    local cores = math.max(math.floor(size / 4), 4)
    for _ = 1, cores do
        local flame = emitter:Add("particles/flamelet" .. math.random(1, 5), origin + VectorRand() * size * 0.15)
        if flame then
            local vel = (dir * math.Rand(0.4, 1.4) + VectorRand() * 0.5):GetNormalized() * math.Rand(150, 500) * (size / 40)
            flame:SetVelocity(vel)
            flame:SetDieTime(math.Rand(0.06, 0.18))
            flame:SetStartAlpha(255)
            flame:SetEndAlpha(0)
            flame:SetStartSize(math.Rand(0.6, 1.3) * size)
            flame:SetEndSize(math.Rand(1.4, 2.2) * size)
            flame:SetRoll(math.Rand(0, 360))
            flame:SetRollDelta(math.Rand(-4, 4))
            flame:SetAirResistance(120)
            flame:SetColor(255, math.random(140, 210), 60)
        end
    end

    -- Bright white core
    for _ = 1, math.max(math.floor(size / 10), 2) do
        local core = emitter:Add("effects/blueflare1", origin + dir * size * 0.1 + VectorRand() * size * 0.1)
        if core then
            core:SetVelocity(dir * math.Rand(50, 200) * (size / 40))
            core:SetDieTime(math.Rand(0.03, 0.08))
            core:SetStartAlpha(255)
            core:SetEndAlpha(0)
            core:SetStartSize(math.Rand(0.8, 1.4) * size)
            core:SetEndSize(math.Rand(1.2, 1.8) * size)
            core:SetRoll(math.Rand(0, 360))
            core:SetRollDelta(math.Rand(-6, 6))
            core:SetAirResistance(80)
            core:SetColor(255, 240, 200)
        end
    end

    -- Sparks
    for _ = 1, math.max(math.floor(size / 6), 3) do
        local spark = emitter:Add("effects/spark", origin)
        if spark then
            spark:SetVelocity((dir * math.Rand(0.3, 1) + VectorRand() * 0.8):GetNormalized() * math.Rand(300, 900) * (size / 40))
            spark:SetDieTime(math.Rand(0.1, 0.35))
            spark:SetStartAlpha(255)
            spark:SetEndAlpha(0)
            spark:SetStartSize(math.Rand(0.6, 1.2) * size * 0.25)
            spark:SetEndSize(0)
            spark:SetAirResistance(60)
            spark:SetGravity(Vector(0, 0, -400))
            spark:SetColor(255, math.random(180, 230), 120)
        end
    end

    -- Immediate smoke puff
    for _ = 1, math.max(math.floor(size / 8), 2) do
        local smoke = emitter:Add("particle/smokesprites_000" .. math.random(1, 9), origin + dir * size * 0.2)
        if smoke then
            smoke:SetVelocity((dir * math.Rand(0.5, 1) + VectorRand() * 0.4):GetNormalized() * math.Rand(100, 300) * (size / 40))
            smoke:SetDieTime(math.Rand(0.6, 1.4))
            smoke:SetStartAlpha(math.Rand(90, 150))
            smoke:SetEndAlpha(0)
            smoke:SetStartSize(math.Rand(0.8, 1.2) * size)
            smoke:SetEndSize(math.Rand(2, 3) * size)
            smoke:SetRoll(math.Rand(0, 360))
            smoke:SetRollDelta(math.Rand(-1, 1))
            smoke:SetAirResistance(150)
            smoke:SetGravity(Vector(0, 0, 60))
            local g = math.random(150, 200)
            smoke:SetColor(g, g, g)
        end
    end
end

function EFFECT:Think()
    return false
end

function EFFECT:Render()
end
