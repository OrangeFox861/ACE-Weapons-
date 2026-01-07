include("shared.lua")

function SWEP:DoDrawCrosshair(x, y)
	local Zoom = self:GetZoomState()
	local LaunchAuth = self:GetLaunchAuth()

--	self:DrawScope(Zoom)

	local owner = self:GetOwner()
	local inaccuracy = math.min(owner:GetVelocity():Length() / owner:GetRunSpeed(), 1)
	local VectorPos = Vector(self:GetTarPosX(), self:GetTarPosY(), self:GetTarPosZ())
	inaccuracy = math.max(inaccuracy, self.Heat / self.HeatMax)

	if Zoom then
        surface.SetTexture( surface.GetTextureID( "ace+/sprites/NLAW" ) )
        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.DrawTexturedRect( x - ScrH() / 2, y - ScrH() / 1.99, ScrH(), ScrH() )

		if LaunchAuth then
			tempcolor = Color(150, 0, 0)
			tempcolor2 = Color(255, 0, 0, 255)
			thickness = 3
		end

		--Draw basic crosshair that increases in size with Inaccuracy Accumulation
		local tarpos2d = VectorPos:ToScreen()
		tarpos2d = Vector(math.floor(tarpos2d.x + 0.5), math.floor(tarpos2d.y + 0.5), 0)
		rectSize = 15
		thickness = 2

	return true
end
