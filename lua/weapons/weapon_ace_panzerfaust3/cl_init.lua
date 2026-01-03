include("shared.lua")

function SWEP:DoDrawCrosshair(x, y)
	local Zoom = self:GetZoomState()
	self:DrawScope(Zoom)

	local owner = self:GetOwner()
	local inaccuracy = math.min(owner:GetVelocity():Length() / owner:GetRunSpeed(), 1)
	inaccuracy = math.max(inaccuracy, self.Heat / self.HeatMax)

		if Zoom then
--			surface.SetDrawColor(Color(0, 0, 0, 255 - inaccuracy * 150))

	--		surface.SetDrawColor(Color(0, 0, 0, 255))
  --          surface.SetTextPos( x - 5, y + 5)
--			
--			surface.SetTextColor( 0, 0, 0 )
  --          surface.DrawText("О")
--			
--			surface.SetFont( "HudDefault" )
--			surface.SetTextColor( 0, 0, 0 )
--			surface.SetTextPos( x - 78, y + 38)
--			surface.DrawText("+   +    +    +   +        125")
--			
--			surface.SetTextPos( x - 84, y + 80 )
--			surface.DrawText("+    +    +    +    +       175")
--			
--			surface.SetTextPos( x - 90, y + 130 )
--			surface.DrawText( "+     +    +    +     +      225")

  --          surface.SetTextColor( 0, 0, 0 )
--			surface.SetTextPos( x - 96, y + 187 )
--			surface.DrawText( "+      +    +    +      +     275")
--			
--		surface.DrawRect(x - 500, y - 10, 450, 2)
--		surface.DrawRect(x + 50, y - 10, 450, 2)
	
----minitanks
--
----100m
--		surface.DrawRect(x - 25, y + 30, 50, 2)
--		
--		surface.DrawRect(x - 25, y + 30, 2, 15)
--		surface.DrawRect(x + 25, y + 30, 2, 15)
--		
--		surface.DrawRect(x - 39, y + 43, 15, 2)
--		surface.DrawRect(x + 26, y + 43, 15, 2)
		
--		surface.DrawRect(x + 39, y + 43, 2, 25)
--		surface.DrawRect(x - 39, y + 43, 2, 25)
		
----150m
--		surface.DrawRect(x - 17, y + 80, 36, 2)
--		
--		surface.DrawRect(x - 17, y + 80, 2, 10)
--		surface.DrawRect(x + 17, y + 80, 2, 10)
--		
--		surface.DrawRect(x - 25, y + 90, 10, 2)
--		surface.DrawRect(x + 17, y + 90, 10, 2)
--		
--		surface.DrawRect(x + 25, y + 90, 2, 20)
--		surface.DrawRect(x - 25, y + 90, 2, 20)
		
		
--200
--      surface.DrawRect(x - 12, y + 132, 26, 2)

  --      surface.DrawRect(x - 12, y + 132, 2, 10)
--		surface.DrawRect(x + 12, y + 132, 2, 10)

--      surface.DrawRect(x - 18, y + 140, 8, 2)
--		surface.DrawRect(x + 12, y + 140, 8, 2)
		
--		surface.DrawRect(x + 19, y + 140, 2, 15)
--		surface.DrawRect(x - 19, y + 140, 2, 15)
--250
--         surface.DrawRect(x - 9, y + 190, 20, 2)

      --  surface.DrawRect(x - 9, y + 190, 2, 7)
	--	surface.DrawRect(x + 9, y + 190, 2, 7)

  --      surface.DrawRect(x - 14, y + 195, 5, 2)
--		surface.DrawRect(x + 11, y + 195, 5, 2)
		
--		surface.DrawRect(x + 15, y + 195, 2, 13)
--		surface.DrawRect(x - 15, y + 195, 2, 13)
		
		
surface.SetTexture( surface.GetTextureID( "ace+/sprites/PNF3" ) )
surface.SetDrawColor( 255, 255, 255, 255 )
surface.DrawTexturedRect( x - ScrH() / 2, y - ScrH() / 1.98, ScrH(), ScrH() )

			return true
		end

	
end