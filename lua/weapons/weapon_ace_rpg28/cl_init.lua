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
      --      surface.SetTextPos( x - 5, y + 5)
			
	--		surface.SetTextColor( 0, 0, 0 )
  --          surface.DrawText("")
			
--			surface.SetFont( "HudDefault" )
--			surface.SetTextColor( 0, 0, 0 )
--			surface.SetTextPos( x - 7, y - 1)
--			surface.DrawText("+")
			
--			surface.SetTextPos( x - 49, y + 40 )
--			surface.DrawText("|  |  ^  |  |  200")
			
--			surface.SetTextPos( x - 49, y + 100 )
--			surface.DrawText( "|  |  ^  |  |  300")

  --          surface.SetTextColor( 0, 0, 0 )
--			surface.SetTextPos( x - 7, y + 187 )
--			surface.DrawText( "")


 --       surface.DrawRect(x - 1, y + 120, 3, 30)

 --       surface.DrawRect(x + 16, y + 225, 110, 2)



--range finde

--300m
  --          surface.SetTextColor( 0, 0, 0 )
--			surface.SetTextPos( x + 112, y + 194 )
--			surface.DrawText( "3")
--
--        surface.DrawRect(x + 110, y + 210, 15, 2)
		
--200m
      --      surface.SetTextColor( 0, 0, 0 )
	--		surface.SetTextPos( x + 89, y + 184 )
	--		surface.DrawText( "2")

 --       surface.DrawRect(x + 80, y + 201, 30, 2)
--150
  --          surface.SetTextColor( 0, 0, 0 )
--			surface.SetTextPos( x + 46, y + 178 )
--			surface.DrawText( "1.5")

--        surface.DrawRect(x + 40, y + 194, 45, 2)
--100m

  --          surface.SetTextColor( 0, 0, 0 )
--			surface.SetTextPos( x + 40, y + 164 )
--			surface.DrawText( "1")

--        surface.DrawRect(x + 15, y + 180, 65, 2)

surface.SetTexture( surface.GetTextureID( "ace+/sprites/RPG28" ) )
surface.SetDrawColor( 255, 255, 255, 255 )
surface.DrawTexturedRect( x - ScrH() / 2, y - ScrH() / 1.98, ScrH(), ScrH() )		
			return true
		end

	
end