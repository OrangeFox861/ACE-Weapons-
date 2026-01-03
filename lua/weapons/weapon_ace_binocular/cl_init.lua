include("shared.lua")

function SWEP:DoDrawCrosshair(x, y)
	local Zoom = self:GetZoomState()
	self:DrawScope(Zoom)

	local owner = self:GetOwner()
	local inaccuracy = math.min(owner:GetVelocity():Length() / owner:GetRunSpeed(), 1)
	inaccuracy = math.max(inaccuracy, self.Heat / self.HeatMax)

		if Zoom then
		
		
		local RT = util.QuickTrace(owner:GetShootPos(), owner:GetAimVector() * 50000, {owner})

		local RDist = 9999
		
		if RT.Hit then
		local difpos = RT.HitPos - owner:GetShootPos()
			RDist = ( difpos * Vector(1,1,0) ):Length() / 39.37
		end

		
		surface.DrawRect(x - 1, y - 14, 3,30)
		surface.DrawRect(x - 14, y - 0, 30,3)
		
				surface.DrawRect(x - 30, y - 12, 3,15)
				surface.DrawRect(x + 30, y - 12, 3,15)

				surface.DrawRect(x + 60, y - 27, 3,30)				
				surface.DrawRect(x - 60, y - 27, 3,30)
				
				surface.DrawRect(x - 90, y - 12, 3,15)
				surface.DrawRect(x + 90, y - 12, 3,15)

				surface.DrawRect(x + 120, y - 27, 3,30)				
				surface.DrawRect(x - 120, y - 27, 3,30)
				
				surface.DrawRect(x - 150, y - 12, 3,15)
				surface.DrawRect(x + 150, y - 12, 3,15)

				surface.DrawRect(x + 180, y - 27, 3,30)				
				surface.DrawRect(x - 180, y - 27, 3,30)
				
				surface.DrawRect(x - 210, y - 12, 3,15)
				surface.DrawRect(x + 210, y - 12, 3,15)

				surface.DrawRect(x + 240, y - 27, 3,30)				
				surface.DrawRect(x - 240, y - 27, 3,30)
				
				surface.DrawRect(x - 270, y - 12, 3,15)
				surface.DrawRect(x + 270, y - 12, 3,15)

				surface.DrawRect(x + 300, y - 27, 3,30)				
				surface.DrawRect(x - 300, y - 27, 3,30)
				

				surface.DrawRect(x - 10, y - 30, 20,3)
				surface.DrawRect(x - 15, y - 60, 30,3)
				
				surface.DrawRect(x - 10, y - 90, 20,3)
				surface.DrawRect(x - 15, y - 120, 30,3)
				
				
				
				
				
				
				
		surface.SetDrawColor(Color(0, 0, 0, 255))
		surface.SetTextColor( 0, 0, 0 )

		surface.SetTextPos( x - 45, y + 40 )
		surface.DrawText( "RNG: " .. math.Round(RDist,0) .. "m")
		
			return true
		end

	
end