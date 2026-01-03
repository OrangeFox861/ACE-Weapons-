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
--     	surface.DrawRect(x - 500, y + 0, 1000, 2)
--     	surface.DrawRect(x - 0, y - 500, 2, 1000)
--			     
--     	surface.DrawRect(x - 700, y - 3, 470, 8)
--      surface.DrawRect(x + 230, y - 3, 455, 8)
--		
--		--рисочки горизонт
--		surface.DrawRect(x - 21, y - 6, 3, 14)--1маленькая
--		surface.DrawRect(x + 20, y - 6, 3, 14)
--
--		surface.DrawRect(x - 61, y - 8, 3, 19)--2 
--		surface.DrawRect(x + 60, y - 8, 3, 19)
--
--		surface.DrawRect(x - 101, y - 6, 3, 14)--3маленькая
--		surface.DrawRect(x + 100, y - 6, 3, 14)
--		
--		surface.DrawRect(x - 141, y - 8, 3, 19)--4 
--		surface.DrawRect(x + 140, y - 8, 3, 19)	
--		
--		surface.DrawRect(x - 181, y - 6, 3, 14)--5маленькая
--		surface.DrawRect(x + 180, y - 6, 3, 14)		
--		
--		--рисочки вертикаль		
--
--		surface.DrawRect(x - 6, y - 20, 14, 3)--1маленькая
--		surface.DrawRect(x - 6, y + 20, 14, 3)	
--
--		surface.DrawRect(x - 9, y - 60, 20, 3)--2 
--		surface.DrawRect(x - 9, y + 60, 20, 3)
--		
--		surface.DrawRect(x - 6, y - 100, 14, 3)--3маленькая
--		surface.DrawRect(x - 6, y + 100, 14, 3)	
--
--		surface.DrawRect(x - 9, y - 140, 20, 3)--4 
--		surface.DrawRect(x - 14, y + 140, 30, 3)
--		
--		surface.DrawRect(x - 6, y - 180, 14, 3)--5маленькая
--		surface.DrawRect(x - 6, y + 180, 14, 3)	
--
--		surface.DrawRect(x - 9, y - 220, 20, 3)--6 
--		surface.DrawRect(x - 9, y + 220, 20, 3)
		
		
		
		--дальномер
--осн линия
--		surface.DrawRect(x + 60, y + 140, 120, 3)
--150м
--		surface.DrawRect(x + 60, y + 72, 20, 3)
--200м	
--		surface.DrawRect(x + 80, y + 88, 20, 3)	
--250м
--		surface.DrawRect(x + 100, y + 97, 20, 3)	
--300		
--		surface.DrawRect(x + 120, y + 106, 20, 3)
--350
--		surface.DrawRect(x + 140, y + 111, 20, 3)	
--400
--		surface.DrawRect(x + 160, y + 114, 20, 3)	
--
--цифры	
--
--			surface.SetTextPos( x + 58, y + 52 )
--			surface.SetTextColor( 0, 0, 0 )
--			surface.DrawText("15")	
--			
--			surface.SetTextPos( x + 78, y + 68 )
--			surface.SetTextColor( 0, 0, 0 )
--			surface.DrawText("20")
--			
--			surface.SetTextPos( x + 98, y + 77 )
--			surface.SetTextColor( 0, 0, 0 )
--    		surface.DrawText("25")
--		
--			surface.SetTextPos( x + 118, y + 86 )
--			surface.SetTextColor( 0, 0, 0 )
--			surface.DrawText("30")
--			
--			surface.SetTextPos( x + 138, y + 90 )
--			surface.SetTextColor( 0, 0, 0 )
--			surface.DrawText("35")
--			
--			surface.SetTextPos( x + 158, y + 95 )
--			surface.SetTextColor( 0, 0, 0 )
--			surface.DrawText("40")
--			
--			
--другое
--
--			surface.SetTextPos( x - 25, y + 19 )
--			surface.SetTextColor( 0, 0, 0 )
--			surface.DrawText("35")	


surface.SetTexture( surface.GetTextureID( "ace+/sprites/M200" ) )
surface.SetDrawColor( 255, 255, 255, 255 )
surface.DrawTexturedRect( x - ScrH() / 2, y - ScrH() / 1.99, ScrH(), ScrH() )


			return true
		end





end


