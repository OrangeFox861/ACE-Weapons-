include("shared.lua")

function SWEP:DoDrawCrosshair(x, y)
	local Zoom = self:GetZoomState()
	self:DrawScope(Zoom)

	local owner = self:GetOwner()
	local inaccuracy = math.min(owner:GetVelocity():Length() / owner:GetRunSpeed(), 1)
	inaccuracy = math.max(inaccuracy, self.Heat / self.HeatMax)

		if Zoom then
--    	surface.SetDrawColor(0, 0, 0, 255)
--		
--		surface.DrawRect(x - 1, y - 14, 3, 30) -- v
--		surface.DrawRect(x - 15, y - 0, 30, 3) -- h
--		
--		surface.DrawRect(x - 1, y + 23, 3, 17) -- v
--		surface.DrawRect(x - 8, y + 30, 17, 3) -- h
--		
--		surface.DrawRect(x - 1, y + 43, 3, 17) -- v
--		surface.DrawRect(x - 8, y + 50, 17, 3) -- h

--       	surface.DrawRect(x - 500, y + 0, 470, 3)
--      surface.DrawRect(x + 30, y + 0, 455, 3)
--		
--		--tolstiy krujok
--       	surface.DrawCircle(x + 0, y + 1, 15)
--     	surface.DrawCircle(x + 0, y + 1, 16)		
--     	surface.DrawCircle(x + 0, y + 1, 17)	     
--		
 	--rangefunder
--		
--		--main line
--				surface.DrawRect(x - 150, y + 20, 80, 3)
--		--100m
--				 surface.DrawRect(x - 85, y + 73, 7, 2)
--			surface.SetTextPos( x - 83, y + 0 )
--			surface.SetTextColor( 0, 0, 0 )
--			surface.DrawText("1")
--			
--			
--		--200m
--
--		         surface.DrawRect(x - 95, y + 49, 7, 2)
--			surface.SetTextPos( x - 99, y + 0 )
--			surface.SetTextColor( 0, 0, 0 )
--			surface.DrawText("2")	
--			
--		--300m
--			     surface.DrawRect(x - 112, y + 39, 7, 2)
--          surface.SetTextPos( x - 115, y + 0 )
--			surface.SetTextColor( 0, 0, 0 )
--			surface.DrawText("3")			
--		--400
--		     surface.DrawRect(x - 126, y + 35, 7, 2)
--        surface.SetTextPos( x - 130, y + 0 )
--		surface.SetTextColor( 0, 0, 0 )
--		surface.DrawText("4")		
--		--500
--		     surface.DrawRect(x - 140, y + 32, 7, 2)
--      surface.SetTextPos( x - 143, y + 0 )
--		surface.SetTextColor( 0, 0, 0 )
--		surface.DrawText("5")		
		
surface.SetTexture( surface.GetTextureID( "ace+/sprites/G36" ) )
surface.SetDrawColor( 255, 255, 255, 255 )
surface.DrawTexturedRect( x - ScrH() / 2, y - ScrH() / 1.98, ScrH(), ScrH() )

		
			return true
		end











	
end

