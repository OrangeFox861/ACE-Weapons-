include("shared.lua")

function SWEP:DoDrawCrosshair(x, y)
	local Zoom = self:GetZoomState()
	self:DrawScope(Zoom)

	local owner = self:GetOwner()
	local inaccuracy = math.min(owner:GetVelocity():Length() / owner:GetRunSpeed(), 1)
	inaccuracy = math.max(inaccuracy, self.Heat / self.HeatMax)

		if Zoom then
--			surface.SetDrawColor(Color(0, 0, 0, 255 - inaccuracy * 150))
--
--			surface.SetDrawColor(Color(0, 0, 0, 255))
--          surface.SetTextPos( x - 5, y + 0)
--			
--			surface.SetTextColor( 0, 0, 0 )
--            surface.DrawText("+")
--			
--			surface.SetFont( "HudDefault" )
--			surface.SetTextColor( 0, 0, 0 )
--			surface.SetTextPos( x - 47, y + 30)
--			surface.DrawText(" ___^___    125")
--			
--			surface.SetTextPos( x - 35, y + 68 )
--			surface.DrawText(" __^__      175")
--			
--			surface.SetTextPos( x - 23, y + 105 )
--			surface.DrawText( " _^_        225")

surface.SetTexture( surface.GetTextureID( "ace+/sprites/RPG7" ) )
surface.SetDrawColor( 255, 255, 255, 255 )
surface.DrawTexturedRect( x - ScrH() / 2, y - ScrH() / 1.98, ScrH(), ScrH() )


			return true
		end

	
end