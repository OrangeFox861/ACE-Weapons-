-- Scalable, soundless smoke effect used by ACE.PlayLaunchEffect for launcher
-- backblast and trailing smoke. Unlike "ace_smoke" this never triggers ACE.SBlast
-- (explosion audio/screenshake), which keeps the launch audio clean.
-- Data:
--   Origin     - smoke position
--   Normal     - emission direction
--   Radius     - overall size in units (preferred)
--   Magnitude  - emission speed/density scale
--   Start      - colour as a Vector(r, g, b)

function EFFECT:Init(data)
    self.Origin = data:GetOrigin()
    self.Dir = data:GetNormal() or Vector(0, 0, 1)
    if self.Dir:LengthSqr() == 0 then
        self.Dir = Vector(0, 0, 1)
    end
    self.Dir = self.Dir:GetNormalized()

    local size = data:GetRadius()
    if not size or size <= 0 then
        size = (data:GetScale() or 1) * 40
    end

    local magnitude = data:GetMagnitude()
    if not magnitude or magnitude <= 0 then magnitude = 10 end

    local start = data:GetStart()
    local col
    if start and start:LengthSqr() > 0 then
        col = Color(start.x, start.y, start.z)
    else
        col = Color(200, 200, 200)
    end

    local emitter = ParticleEmitter(self.Origin)
    if not emitter then return end

    local speedMul = magnitude / 20
    local count = math.max(math.floor(size / 3), 6)
    for _ = 1, count do
        local smoke = emitter:Add("particle/smokesprites_000" .. math.random(1, 9), self.Origin + VectorRand() * size * 0.5)
        if smoke then
            local vel = (self.Dir * math.Rand(0.2, 1) + VectorRand() * 0.6):GetNormalized() * math.Rand(30, 120) * speedMul
            smoke:SetVelocity(vel + Vector(0, 0, math.Rand(20, 60)))
            smoke:SetDieTime(math.Rand(1.0, 2.2))
            smoke:SetStartAlpha(math.Rand(70, 130))
            smoke:SetEndAlpha(0)
            smoke:SetStartSize(math.Rand(0.6, 1.1) * size)
            smoke:SetEndSize(math.Rand(2, 4) * size)
            smoke:SetRoll(math.Rand(0, 360))
            smoke:SetRollDelta(math.Rand(-1, 1))
            smoke:SetAirResistance(60)
            smoke:SetGravity(Vector(0, 0, 20))
            smoke:SetColor(col.r, col.g, col.b)
        end
    end
end

function EFFECT:Think()
    return false
end

function EFFECT:Render()
end
