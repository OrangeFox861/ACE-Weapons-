SWEP.PrintName = "M32"
SWEP.Base = "weapon_ace_base"
SWEP.Category = "ACE Weapons+"
SWEP.SubCategory = "Special"
SWEP.Purpose = "Grenade Launcher"
SWEP.Instructions	= "Left click to shoot. Right click while sprinting to scope, Right click to lase"
SWEP.Spawnable = true
SWEP.Slot = 3 --Which inventory column the weapon appears in
SWEP.SlotPos = 1 --Priority in which the weapon appears, 1 tries to put it at the top
SWEP.Author = " "

--Main settings--
SWEP.FireRate = 3 --Rounds per second

SWEP.Primary.ClipSize = 6
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "SMG1_Grenade"
SWEP.Primary.Sound = "ace_weapons/sweps/multi_sound/scout_multi.mp3"
SWEP.Primary.LightScale = 500 --Muzzleflash light radius
SWEP.Primary.BulletCount = 1 --Number of bullets to fire each shot, used for shotguns

SWEP.ReloadSound = "weapons/ar2/npc_ar2_reload.wav" --Sound other players hear when you reload - this is NOT your first-person sound
										--Most models have a built-in first-person reload sound

SWEP.ZoomFOV = 35
SWEP.HasScope = true --True if the weapon has a sniper-style scope


SWEP.ReticuleSize = 10


--Recoil (crosshair movement) settings--
--"Heat" is a number that represents how long you've been firing, affecting how quickly your crosshair moves upwards
SWEP.HeatReductionRate = 30 --Heat loss per second when not firing
SWEP.HeatPerShot = 1 --Heat generated per shot
SWEP.HeatMax = 1 --Maximum heat - determines max rate at which recoil is applied to eye angles
				--Also determines point at which random spread is at its highest intensity
				--HeatMax divided by HeatPerShot gives you how many shots until you reach MaxSpread

SWEP.AngularRecoil = 30	--Amount of angular recoil

--How much the recoil is biased to one side proportional to vertical recoil
--Positive numbers bias to the right, negative to the left
SWEP.RecoilSideBias = 0.3

SWEP.ZoomRecoilBonus = 0.45 --Reduce recoil by this amount when zoomed or scoped
SWEP.CrouchRecoilBonus = 0.5 --Reduce recoil by this amount when crouching
SWEP.ViewPunchAmount = 2 --Degrees to punch the view upwards each shot - does not actually move crosshair, just a visual effect


--Spread (aimcone) settings--
SWEP.BaseSpread = 0 --First-shot random spread, in degrees
SWEP.MaxSpread = 4 --Maximum added random spread from heat value, in degrees
					--If HeatMax is 0 this will be ignored and only BaseSpread will be taken into account (AT4 for example)
SWEP.MovementSpread = 4 --Increase aimcone to this many degrees when sprinting at full speed
SWEP.UnscopedSpread = 1.5 --Spread, in degrees, when unscoped with a scoped weapon

--Model settings--
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/ace+/v_m32.mdl"
SWEP.WorldModel = "models/ace+/w_m32.mdl"
SWEP.HoldType = "ar2"
SWEP.DeployDelay = 4 --Time before you can fire after deploying the weapon
SWEP.CSMuzzleFlashes = true
SWEP.UseHands = true
SWEP.ShotgunReload = true

if CLIENT then
	local WorldModel = ClientsideModel(SWEP.WorldModel)

	-- Settings...
	WorldModel:SetSkin(1)
	WorldModel:SetNoDraw(true)

	function SWEP:DrawWorldModel()
		local _Owner = self:GetOwner()

		if (IsValid(_Owner)) then
            -- Specify a good position
			local offsetVec = Vector(4.5, -1, -1)
			local offsetAng = Angle(190, 0, 90)
			
			local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand") -- Right Hand
			if !boneid then return end

			local matrix = _Owner:GetBoneMatrix(boneid)
			if !matrix then return end

			local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

			WorldModel:SetPos(newPos)
			WorldModel:SetAngles(newAng)

            WorldModel:SetupBones()
		else
			WorldModel:SetPos(self:GetPos())
			WorldModel:SetAngles(self:GetAngles())
		end

		WorldModel:DrawModel()
	end
end

SWEP.CarrySpeedMul = 0.6

DEFINE_BASECLASS("weapon_ace_base")

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)

	self:NetworkVar("Float", 0, "FuseDelay")
	self:NetworkVar("Float", 1, "Distance")
	self:NetworkVar("Float", 2, "Px")
--	self:NetworkVar("Float", 3, "Py") --Unused Var
	self:NetworkVar("Float", 3, "Pg")
end

function SWEP:OnPrimaryAttack()
	self.BulletData.Owner = self:GetOwner()
	self.BulletData.Gun = self
	self.BulletData.FuseLength = self.FuseDelay

end

function SWEP:InitBulletData()
	self.BulletData = {}
	---------------------------------------
	self.BulletData.Id = "40mmGL"
	self.BulletData.Type = "HE"
	self.BulletData.Id = 2
	self.BulletData.Caliber = 4
	self.BulletData.PropLength = 0.1 --Volume of the case as a cylinder * Powder density converted from g to kg
	self.BulletData.ProjLength = 7.459 --Volume of the projectile as a cylinder * streamline factor (Data5) * density of steel
	self.BulletData.Data5 = 250 --He Filler or Flechette count
	self.BulletData.Data6 = 30 --HEAT ConeAng or Flechette Spread
	self.BulletData.Data7 = 0
	self.BulletData.Data8 = 0
	self.BulletData.Data9 = 0
	self.BulletData.Data10 = 0 -- Tracer
	self.BulletData.Colour = Color(200, 180, 180)
	--
	self.BulletData.Data13 = 0 --THEAT ConeAng2
	self.BulletData.Data14 = 0 --THEAT HE Allocation
	self.BulletData.Data15 = 0
	self.BulletData.AmmoType = self.BulletData.Type
	self.BulletData.FrArea = 3.1416 * (self.BulletData.Caliber / 2) ^ 2
	self.BulletData.ProjMass = self.BulletData.FrArea * (self.BulletData.ProjLength * 7.9 / 1000)
	self.BulletData.PropMass = self.BulletData.FrArea * (self.BulletData.PropLength * ACF.PDensity / 1000) --Volume of the case as a cylinder * Powder density converted from g to kg
	self.BulletData.FillerVol = self.BulletData.Data5
	self.BulletData.FillerMass = self.BulletData.FillerVol * ACF.HEDensity / 1000
	self.BulletData.BoomFillerMass = self.BulletData.FillerMass / 1
	local ConeArea = 3.1416 * self.BulletData.Caliber / 2 * ((self.BulletData.Caliber / 2) ^ 2 + self.BulletData.ProjLength ^ 2) ^ 0.5
	local ConeThick = self.BulletData.Caliber / 50
	local ConeVol = ConeArea * ConeThick
	self.BulletData.SlugMass = ConeVol * 7.9 / 1000
	local Rad = math.rad(self.BulletData.Data6 / 2)
	self.BulletData.SlugCaliber = self.BulletData.Caliber - self.BulletData.Caliber * (math.sin(Rad) * 0.5 + math.cos(Rad) * 1.5) / 2
	self.BulletData.SlugMV = (self.BulletData.FillerMass / 2 * ACF.HEPower * math.sin(math.rad(10 + self.BulletData.Data6) / 2) / self.BulletData.SlugMass) ^ ACF.HEATMVScale
	--		print("SlugMV: " .. self.BulletData.SlugMV)
	local SlugFrArea = 3.1416 * (self.BulletData.SlugCaliber / 2) ^ 2
	self.BulletData.SlugPenArea = SlugFrArea ^ ACF.PenAreaMod
	self.BulletData.SlugDragCoef = ((SlugFrArea / 10000) / self.BulletData.SlugMass) * 1000
	self.BulletData.SlugRicochet = 999 --Base ricochet angle (The HEAT slug shouldn't ricochet at all)
	self.BulletData.CasingMass = self.BulletData.ProjMass - self.BulletData.FillerMass - ConeVol * 7.9 / 1000
	self.BulletData.Fragments = math.max(math.floor((self.BulletData.BoomFillerMass / self.BulletData.CasingMass) * ACF.HEFrag), 2)
	self.BulletData.FragMass = self.BulletData.CasingMass / self.BulletData.Fragments
	--		self.BulletData.DragCoef  = 0 --Alternatively manually set it
		self.BulletData.DragCoef  = ((self.BulletData.FrArea/10000)/self.BulletData.ProjMass)
	--		print(self.BulletData.SlugDragCoef)
	--Don't touch below here
	self.BulletData.MuzzleVel = ACF_MuzzleVelocity(self.BulletData.PropMass, self.BulletData.ProjMass, self.BulletData.Caliber)
	self.BulletData.ShovePower = 0.25
	self.BulletData.KETransfert = 0.1
	self.BulletData.PenArea = self.BulletData.FrArea ^ ACF.PenAreaMod
	self.BulletData.Pos = Vector(0, 0, 0)
	self.BulletData.LimitVel = 800
	self.BulletData.Ricochet = 999
	self.BulletData.Flight = Vector(0, 0, 0)
	self.BulletData.BoomPower = self.BulletData.PropMass + self.BulletData.FillerMass
	--		local SlugEnergy = ACF_Kinetic( self.BulletData.MuzzleVel * 39.37 + self.BulletData.SlugMV * 39.37 , self.BulletData.SlugMass, 999999 )
	local SlugEnergy = ACF_Kinetic(self.BulletData.MuzzleVel * 39.37 + self.BulletData.SlugMV * 39.37, self.BulletData.SlugMass, 999999)
	self.BulletData.MaxPen = (SlugEnergy.Penetration / self.BulletData.SlugPenArea) * ACF.KEtoRHA
	--		print("SlugPen: " .. self.BulletData.MaxPen)
	--For Fake Crate
	self.BoomFillerMass = self.BulletData.BoomFillerMass
	self.Type = self.BulletData.Type
	self.BulletData.Tracer = self.BulletData.Data10
	self.Tracer = self.BulletData.Data10
	self.Caliber = self.BulletData.Caliber
	self.ProjMass = self.BulletData.ProjMass
	self.FillerMass = self.BulletData.FillerMass
	self.DragCoef = self.BulletData.DragCoef
	self.Colour = self.BulletData.Colour
	self.DetonatorAngle = 85
end
