include("shared.lua")

function SWEP:DrawScope(Zoomed)
	if not (Zoomed and self.HasScope) then return end

	local scrw = ScrW()
	local scrh = ScrH()

	surface.SetDrawColor(0, 0, 0, 255)

	local rectsides = ((scrw - scrh) / 2) * 0.7

	surface.SetMaterial(Material("gmod/scope"))
	surface.DrawTexturedRect(rectsides, 0, scrw - rectsides * 2, scrh)
	surface.DrawRect(0, 0, rectsides + 2, scrh)
	surface.DrawRect(scrw - rectsides - 2, 0, rectsides + 2, scrh)
end


function SWEP:DoDrawCrosshair(x, y)
	local Zoom = self:GetZoomState()
	self:DrawScope(Zoom)

	local owner = self:GetOwner()
	

				if Zoom then
				
	--	surface.DrawRect(x - 1, y - 9, 2, 18) -- v
	--	surface.DrawRect(x - 9, y - 1, 18, 2) -- h
			
			
			
		
		

--200
	--	surface.DrawRect(x - 189, y + 67, 187, 2)
    --    surface.DrawRect(x + 3, y + 67, 190, 2)
		
--240
  --      surface.DrawRect(x - 189, y + 130, 187, 2)
--        surface.DrawRect(x + 3, y + 130, 190, 2)
--290

--vertical line

      --  surface.DrawRect(x - 1, y + 180, 3, 300)

		
		
--tandem sight

      
    --    surface.DrawRect(x + 15, y + 225, 110, 2)


--distance text

  --          surface.SetTextColor( 0, 0, 0 )
--			surface.SetTextPos( x - 229, y + 35 )
--			surface.DrawText( "200 '     '     '     '     '     ^     '     '     '     '     '")

  --          surface.SetTextColor( 0, 0, 0 )
--			surface.SetTextPos( x - 52, y + 35 )
--			surface.DrawText( "|   :      :   |")
			

			
  --          surface.SetTextColor( 0, 0, 0 )
--			surface.SetTextPos( x - 229, y + 64 )
--			surface.DrawText( "250 '     '     '     '     '     ^     '     '     '     '     '")

      --      surface.SetTextColor( 0, 0, 0 )
	--		surface.SetTextPos( x - 40, y + 64 )
	--		surface.DrawText( "|  :    :  |")
			
			
			
  --          surface.SetTextColor( 0, 0, 0 )
--			surface.SetTextPos( x - 229, y + 92 )
--			surface.DrawText( "300 '     '     '     '     '     ^     '     '     '     '     '")

      --      surface.SetTextColor( 0, 0, 0 )
	--		surface.SetTextPos( x - 30, y + 92 )
	--		surface.DrawText( "| :   : |")
			
			

  --          surface.SetTextColor( 0, 0, 0 )
--			surface.SetTextPos( x - 229, y + 128 )
--			surface.DrawText( "350 '     '     '     '     '     ^     '     '     '     '     '")
			
          --  surface.SetTextColor( 0, 0, 0 )
		--	surface.SetTextPos( x - 28, y + 128 )
		--	surface.DrawText( "| :  : |")
			
			
			
      --      surface.SetTextColor( 0, 0, 0 )
	--		surface.SetTextPos( x - 229, y + 158 )
	--		surface.DrawText( "380 '     '     '     '     '     ^     '     '     '     '     '")


			
			
--range finde

--300m
  --          surface.SetTextColor( 0, 0, 0 )
--			surface.SetTextPos( x + 112, y + 194 )
--			surface.DrawText( "3")

    --    surface.DrawRect(x + 110, y + 210, 15, 2)
		
--200m
  --          surface.SetTextColor( 0, 0, 0 )
--			surface.SetTextPos( x + 80, y + 184 )
--			surface.DrawText( "2.5")

    --    surface.DrawRect(x + 80, y + 201, 30, 2)
--150
  --          surface.SetTextColor( 0, 0, 0 )
--			surface.SetTextPos( x + 55, y + 178 )
--			surface.DrawText( "2")

    --    surface.DrawRect(x + 40, y + 194, 45, 2)
--100m

  --          surface.SetTextColor( 0, 0, 0 )
--			surface.SetTextPos( x + 35, y + 164 )
--			surface.DrawText( "1.5")

--        surface.DrawRect(x + 15, y + 180, 65, 2)


surface.SetTexture( surface.GetTextureID( "ace+/sprites/RPG29" ) )
surface.SetDrawColor( 255, 255, 255, 255 )
surface.DrawTexturedRect( x - ScrH() / 2, y - ScrH() / 1.98, ScrH(), ScrH() )

			return true
		end
	
end