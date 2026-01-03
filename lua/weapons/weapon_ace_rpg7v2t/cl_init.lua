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
	local inaccuracy = math.min(owner:GetVelocity():Length() / owner:GetRunSpeed(), 1)
	inaccuracy = math.max(inaccuracy, self.Heat / self.HeatMax)

				if Zoom then
--			surface.SetDrawColor(Color(0, 0, 0, 255 - inaccuracy * 150))

          --  surface.SetDrawColor(Color(0, 0, 0, 255 - inaccuracy * 150))

		--    surface.SetDrawColor(Color(0, 0, 0, 255))
      --      surface.SetTextPos( x - 7, y + 30)
	--		surface.SetTextColor( 0, 0, 0 )
    --        surface.DrawText("+")
  -- 
--		surface.DrawRect(x - 1, y - 9, 2, 18) -- v
--		surface.DrawRect(x - 9, y - 1, 18, 2) -- h
			
			
			
		
		
--150
  --      surface.DrawRect(x - 189, y + 65, 187, 2)
--        surface.DrawRect(x + 3, y + 65, 190, 2)
--200
	--	surface.DrawRect(x - 189, y + 87, 187, 2)
  --      surface.DrawRect(x + 3, y + 87, 190, 2)
		
--		surface.DrawRect(x - 189, y + 90, 187, 2)
--        surface.DrawRect(x + 3, y + 90, 190, 2)
--240
  --      surface.DrawRect(x - 189, y + 115, 187, 2)
--        surface.DrawRect(x + 3, y + 115, 190, 2)
--290
  --      surface.DrawRect(x - 189, y + 143, 187, 2)
--        surface.DrawRect(x + 3, y + 143, 190, 2)
--vertical line
    --    surface.DrawRect(x - 2, y + 65, 2, 300)
  --      surface.DrawRect(x + 2, y + 65, 2, 300)

--        surface.DrawRect(x - 40, y + 65, 2, 80)
    --    surface.DrawRect(x + 40, y + 65, 2, 80)
  --      surface.DrawRect(x - 80, y + 65, 2, 80)
--        surface.DrawRect(x + 80, y + 65, 2, 80)
    --    surface.DrawRect(x - 120, y + 65, 2, 80)
  --      surface.DrawRect(x + 120, y + 65, 2, 80)
--        surface.DrawRect(x - 160, y + 65, 2, 80)
      --  surface.DrawRect(x + 160, y + 65, 2, 80)
    --    surface.DrawRect(x - 190, y + 65, 2, 80)
  --      surface.DrawRect(x + 190, y + 65, 2, 80)
		
		
--tandem sight
--		surface.DrawRect(x - 189, y + 155, 187, 2)
--        surface.DrawRect(x + 3, y + 155, 190, 2)

    --    surface.DrawRect(x - 189, y + 225, 187, 2)
  --      surface.DrawRect(x + 3, y + 225, 190, 2)
--
  --      surface.DrawRect(x - 189, y + 312, 187, 2)
--        surface.DrawRect(x + 3, y + 312, 190, 2)


--distance text

            surface.SetTextColor( 0, 0, 0 )
	--		surface.SetTextPos( x - 226, y + 55 )
	--		surface.DrawText( "150")
	--		
  --          surface.SetTextColor( 0, 0, 0 )
--			surface.SetTextPos( x - 226, y + 78 )
--			surface.DrawText( "200")
--
  --          surface.SetTextColor( 0, 0, 0 )
--			surface.SetTextPos( x - 226, y + 104 )
--			surface.DrawText( "240")
--
  ---          surface.SetTextColor( 0, 0, 0 )
--			surface.SetTextPos( x - 226, y + 132 )
--			surface.DrawText( "290")

--tandem distance text

      --      surface.SetTextColor( 0, 0, 0 )
	--		surface.SetTextPos( x - 28, y + 88 )
	--		surface.DrawText( "70")

  --          surface.SetTextColor( 0, 0, 0 )
--			surface.SetTextPos( x - 40, y + 153 )
--			surface.DrawText( "100")
			
--			surface.SetTextColor( 0, 0, 0 )
--			surface.SetTextPos( x - 40, y + 203 )
--			surface.DrawText( "125")
--
	--		surface.SetTextColor( 0, 0, 0 )
	--		surface.SetTextPos( x - 40, y + 313 )
	--		surface.DrawText( "155")			
			
			
			
--range finde

--300m
  --          surface.SetTextColor( 0, 0, 0 )
--			surface.SetTextPos( x + 112, y + 194 )
--			surface.DrawText( "3")

--        surface.DrawRect(x + 110, y + 210, 15, 2)
		
--200m
  --          surface.SetTextColor( 0, 0, 0 )
--			surface.SetTextPos( x + 89, y + 184 )
--			surface.DrawText( "2")

--        surface.DrawRect(x + 80, y + 201, 30, 2)
--150
  --          surface.SetTextColor( 0, 0, 0 )
--			surface.SetTextPos( x + 46, y + 178 )
--			surface.DrawText( "1.5")

--        surface.DrawRect(x + 40, y + 194, 45, 2)
--100m

  --          surface.SetTextColor( 0, 0, 0 )
--			surface.SetTextPos( x + 40, y + 164 )
--			surface.DrawText( "1")
--
--        surface.DrawRect(x + 15, y + 180, 65, 2)


surface.SetTexture( surface.GetTextureID( "ace+/sprites/RPG7V2" ) )
surface.SetDrawColor( 255, 255, 255, 255 )
surface.DrawTexturedRect( x - ScrH() / 2, y - ScrH() / 1.98, ScrH(), ScrH() )

			return true
		end
	
end