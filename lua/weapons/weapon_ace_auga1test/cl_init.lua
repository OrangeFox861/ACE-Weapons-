include("shared.lua")

function SWEP:DoDrawCrosshair(x, y)
	local Zoom = self:GetZoomState()
	self:DrawScope(Zoom)

	local owner = self:GetOwner()
	local inaccuracy = math.min(owner:GetVelocity():Length() / owner:GetRunSpeed(), 1)
	inaccuracy = math.max(inaccuracy, self.Heat / self.HeatMax)

		if Zoom then
--				surface.DrawRect(x - 500, y + 0, 495, 2)
--				surface.DrawRect(x + 5, y + 0, 495, 2)			
--				surface.DrawRect(x - 1, y + 5, 2, 500)						
--				surface.DrawRect(x - 1, y - 500, 2, 495)					
--			surface.SetFont( "HudDefault" )
--			surface.SetTextColor( 0, 0, 0 )
--			surface.SetTextPos( x - 7, y - 10)
--			surface.DrawText("O")

surface.SetTexture( surface.GetTextureID( "ace+/sprites/aug" ) )
surface.SetDrawColor( 255, 255, 255, 255 )
surface.DrawTexturedRect( x - ScrH() / 2, y - ScrH() / 1.98, ScrH(), ScrH() )


			return true
		end

	
end