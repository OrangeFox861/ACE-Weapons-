include("shared.lua")

function SWEP:DoDrawCrosshair(x, y)
	local Zoom = self:GetZoomState()
	self:DrawScope(Zoom)

	local owner = self:GetOwner()
	local inaccuracy = math.min(owner:GetVelocity():Length() / owner:GetRunSpeed(), 1)
	inaccuracy = math.max(inaccuracy, self.Heat / self.HeatMax)

		if Zoom then
	--		surface.SetDrawColor(Color(0, 0, 0, 255 - inaccuracy * 150))

	--		surface.SetDrawColor(Color(0, 0, 0, 255))
  --          surface.SetTextPos( x - 5, y + 5)
			
--			surface.SetFont( "HudDefault" )
--			surface.SetTextColor( 0, 0, 0 )
--			surface.SetTextPos( x - 78, y - 0)
--			surface.DrawText("+   +    +    +   +        100")
			
--			surface.SetTextPos( x - 84, y + 45 )
--			surface.DrawText("+    +    +    +    +       200")
			
--			surface.SetTextPos( x - 90, y + 85 )
--			surface.DrawText( "+     +    +    +     +      250")

--          surface.SetTextColor( 0, 0, 0 )
--			surface.SetTextPos( x - 96, y + 145 )
--			surface.DrawText( "+      +    +    +      +     300")
			

--		surface.DrawRect(x - 500, y - 10, 1000, 2)
--		surface.DrawRect(x - 0, y - 17, 2, 15)		

		
surface.SetTexture( surface.GetTextureID( "ace+/sprites/MATADOR" ) )
surface.SetDrawColor( 255, 255, 255, 255 )
surface.DrawTexturedRect( x - ScrH() / 2, y - ScrH() / 1.98, ScrH(), ScrH() )

			return true
		end

	
end