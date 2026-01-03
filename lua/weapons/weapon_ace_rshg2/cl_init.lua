include("shared.lua")

function SWEP:DoDrawCrosshair(x, y)
	local Zoom = self:GetZoomState()
	self:DrawScope(Zoom)

	local owner = self:GetOwner()
	local inaccuracy = math.min(owner:GetVelocity():Length() / owner:GetRunSpeed(), 1)
	inaccuracy = math.max(inaccuracy, self.Heat / self.HeatMax)

		if Zoom then
		--	surface.SetDrawColor(Color(0, 0, 0, 255 - inaccuracy * 150))

		--	surface.SetDrawColor(Color(0, 0, 0, 255))
        --    surface.SetTextPos( x - 6, y + 0)
			
		--	surface.SetTextColor( 0, 0, 0 )
      --      surface.DrawText("+")
			
	--		surface.SetFont( "HudDefault" )
	--		surface.SetTextColor( 0, 0, 0 )
	--		surface.SetTextPos( x - 48, y + 58)
	--		surface.DrawText(" ___^___    75")
			
	--		surface.SetTextPos( x - 36, y + 138 )
	--		surface.DrawText(" __^__      125")
			
	--		surface.SetTextPos( x - 24, y + 245 )
	--		surface.DrawText( " _^_        175")

  --          surface.SetTextColor( 0, 0, 0 )
--			surface.SetTextPos( x - 10, y + 312 )
--			surface.DrawText( "-:-     200")


surface.SetTexture( surface.GetTextureID( "ace+/sprites/RPG26REV2" ) )
surface.SetDrawColor( 255, 255, 255, 255 )
surface.DrawTexturedRect( x - ScrH() / 2, y - ScrH() / 1.98, ScrH(), ScrH() )

			return true
		end

	
end