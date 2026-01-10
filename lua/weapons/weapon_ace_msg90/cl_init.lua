include("shared.lua")

function SWEP:DoDrawCrosshair(x, y)
    local Zoom = self:GetZoomState()
    self:DrawScope(Zoom)

    local owner = self:GetOwner()
    local inaccuracy = math.min(owner:GetVelocity():Length() / owner:GetRunSpeed(), 1)
    inaccuracy = math.max(inaccuracy, self.Heat / self.HeatMax)

        if Zoom then


surface.SetTexture( surface.GetTextureID( "ace+/sprites/mil_dot" ) )
surface.SetDrawColor( 255, 255, 255, 255 )
surface.DrawTexturedRect( x - ScrH() / 2, y - ScrH() / 1.98, ScrH(), ScrH() )



            return true
        end





end