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
--          surface.DrawText("+")
--			
--			surface.SetFont( "HudDefault" )
--			surface.SetTextColor( 0, 0, 0 )
--			surface.SetTextPos( x - 47, y + 125)
--			surface.DrawText(" ___^___    50")
--			
--			surface.SetTextPos( x - 35, y + 220 )
--			surface.DrawText(" __^__      75")
--			
--			surface.SetTextPos( x - 23, y + 300 )
--			surface.DrawText( " _^_        100")
--
--			surface.SetTextPos( x + 180, y + 125 )
--			surface.SetTextColor( 230, 0, 0 )
			
--          surface.SetTextColor( 0, 0, 0 )
--			surface.SetTextPos( x - 9, y + 380 )
--			surface.DrawText( "-:-     125")


surface.SetTexture( surface.GetTextureID( "ace+/sprites/M32" ) )
surface.SetDrawColor( 255, 255, 255, 255 )
surface.DrawTexturedRect( x - ScrH() / 2, y - ScrH() / 1.98, ScrH(), ScrH() )

			return true
		end

	
end