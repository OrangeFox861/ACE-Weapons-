include("shared.lua")

function SWEP:DoDrawCrosshair(x, y)
	local Zoom = self:GetZoomState()
	self:DrawScope(Zoom)

	local owner = self:GetOwner()
	local inaccuracy = math.min(owner:GetVelocity():Length() / owner:GetRunSpeed(), 1)
	inaccuracy = math.max(inaccuracy, self.Heat / self.HeatMax)

		if Zoom then

--			surface.SetTextPos( x - 190, y + 2 )
--			surface.SetTextColor( 180, 0, 0 )
--			surface.DrawText("15  |     |     |   '    ' ^ '    '   |     |     |")	
			
--			surface.SetTextPos( x - 133, y + 16 )
--			surface.SetTextColor( 180, 0, 0 )
--			surface.DrawText("30          '    ' ^ '    '      ")	
			
--			surface.SetTextPos( x - 103, y + 29 )
--			surface.SetTextColor( 180, 0, 0 )
--			surface.DrawText("45     '    ' ^ '    '    ")					
				
--			surface.SetTextPos( x - 79, y + 43 )
--			surface.SetTextColor( 180, 0, 0 )
--			surface.DrawText("     '    ' ^ '    '    ")	
			
--			surface.SetTextPos( x - 50, y + 50 )
--			surface.SetTextColor( 180, 0, 0 )
--			surface.DrawText("60")		
		
		

			
--другое
  --    	surface.SetDrawColor(150, 0, 0, 255)
--       	surface.DrawRect(x - 1, y - 1, 3, 3)

surface.SetTexture( surface.GetTextureID( "ace+/sprites/SV98" ) )
surface.SetDrawColor( 255, 255, 255, 255 )
surface.DrawTexturedRect( x - ScrH() / 2, y - ScrH() / 1.98, ScrH(), ScrH() )
		
			return true
		end





end