include("shared.lua")

function SWEP:DoDrawCrosshair(x, y)
    local Zoom = self:GetZoomState()
    self:DrawScope(Zoom)

    local owner = self:GetOwner()
    local inaccuracy = math.min(owner:GetVelocity():Length() / owner:GetRunSpeed(), 1)
    inaccuracy = math.max(inaccuracy, self.Heat / self.HeatMax)

        if Zoom then

--           surface.DrawRect(x - 300, y - 3, 200, 2)
  --      surface.DrawRect(x + 100, y - 3, 200, 2)

--           surface.DrawRect(x - 1, y + 50, 2, 200)



    --        surface.SetTextPos( x - 85, y - 6 )
  --          surface.SetTextColor( 0, 0, 0 )
--            surface.DrawText("|'''''|'''''^'''''|'''''|")

    --        surface.SetTextPos( x - 7, y + 8 )
  --          surface.SetTextColor( 0, 0, 0 )
--            surface.DrawText("^")

    --        surface.SetTextPos( x - 7, y + 20 )
  --          surface.SetTextColor( 0, 0, 0 )
--            surface.DrawText("^")

    --        surface.SetTextPos( x - 7, y + 33 )
  --          surface.SetTextColor( 0, 0, 0 )
--            surface.DrawText("^")

    --        surface.SetTextPos( x - 35, y + 6 )
  --          surface.SetTextColor( 0, 0, 0 )
--            surface.DrawText("35")

    --        surface.SetTextPos( x - 90, y + 15 )
  --          surface.SetTextColor( 0, 0, 0 )
--            surface.DrawText("10                      10")
--дальномер
--осн линия
--        surface.DrawRect(x - 160, y + 140, 120, 3)
--100м
--        surface.DrawRect(x - 60, y + 82, 20, 3)
--150м
--        surface.DrawRect(x - 80, y + 98, 20, 3)
--200м
--        surface.DrawRect(x - 100, y + 111, 20, 3)
--250
--        surface.DrawRect(x - 120, y + 116, 20, 3)
--300
--        surface.DrawRect(x - 140, y + 121, 20, 3)
--350
--        surface.DrawRect(x - 160, y + 124, 20, 3)

--цифры

    --        surface.SetTextPos( x - 58, y + 52 )
  --          surface.SetTextColor( 0, 0, 0 )
--            surface.DrawText("10")

    --        surface.SetTextPos( x - 78, y + 68 )
  --          surface.SetTextColor( 0, 0, 0 )
--            surface.DrawText("15")

--            surface.SetTextPos( x - 98, y + 77 )
--            surface.SetTextColor( 0, 0, 0 )
--            surface.DrawText("20")
			
--          surface.SetTextPos( x - 118, y + 86 )
--          surface.SetTextColor( 0, 0, 0 )
--            surface.DrawText("25")

--          surface.SetTextPos( x - 138, y + 90 )
--          surface.SetTextColor( 0, 0, 0 )
--            surface.DrawText("30")

--          surface.SetTextPos( x - 158, y + 95 )
--            surface.SetTextColor( 0, 0, 0 )
--            surface.DrawText("35")


surface.SetTexture( surface.GetTextureID( "ace+/sprites/PSO_1" ) )
surface.SetDrawColor( 255, 255, 255, 255 )
surface.DrawTexturedRect( x - ScrH() / 2, y - ScrH() / 1.98, ScrH(), ScrH() )



            return true
        end





end