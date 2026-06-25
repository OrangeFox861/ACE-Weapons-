SWEP.PrintName = "Double barrel"
SWEP.Base = "weapon_ace_base"
SWEP.Category = "ACE Weapons+"
SWEP.SubCategory = "Shotguns"
SWEP.Purpose = "civil shotgun (caliber 3mm because no one wants to catch 12mm pellets)"
SWEP.Spawnable = true
SWEP.Slot = 2 --Which inventory column the weapon appears in
SWEP.SlotPos = 1 --Priority in which the weapon appears, 1 tries to put it at the top
SWEP.Author = " "

--Main settings--
SWEP.FireRate = 5 --Rounds per second

SWEP.Primary.ClipSize = 2
SWEP.Primary.DefaultClip = 20
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "buckshot"
SWEP.Primary.Sound = "ace_weapons/sweps/multi_sound/m3super90_multi.mp3"
SWEP.Primary.LightScale = 200 --Muzzleflash light radius
SWEP.Primary.BulletCount = 15 --Number of bullets to fire each shot, used for shotguns

SWEP.ReloadSound = "Weapon_Pistol.Reload" --Sound other players hear when you reload - this is NOT your first-person sound
										--Most models have a built-in first-person reload sound

SWEP.ZoomFOV = 60
SWEP.HasScope = false --True if the weapon has a sniper-style scope


--Recoil (crosshair movement) settings--
--"Heat" is a number that represents how long you've been firing, affecting how quickly your crosshair moves upwards
--SWEP.HeatReductionRate = 75 --Heat loss per second when not firing
SWEP.HeatReductionDelay = 0 --Delay after firing before beginning to reduce heat
SWEP.HeatPerShot = 60 --Heat generated per shot
SWEP.HeatMax = 60 --Maximum heat - determines max rate at which recoil is applied to eye angles
				--Also determines point at which random spread is at its highest intensity
				--HeatMax divided by HeatPerShot gives you how many shots until you reach MaxSpread
				
SWEP.AngularRecoil = 45	--Amount of angular recoil

SWEP.RecoilSideBias = 0.15 --How much the recoil is biased to one side proportional to vertical recoil
						--Positive numbers bias to the right, negative to the left

SWEP.ZoomRecoilBonus = 0.5 --Reduce recoil by this amount when zoomed or scoped
SWEP.CrouchRecoilBonus = 0.5 --Reduce recoil by this amount when crouching
SWEP.ViewPunchAmount =6--grees to punch the view upwards each shot - does not actually move crosshair, just a visual effect


--Spread (aimcone) settings--
SWEP.BaseSpread = 0.9 --First-shot random spread, in degrees
SWEP.MaxSpread = 0.9 --Maximum added random spread from heat value, in degrees
					--If HeatMax is 0 this will be ignored and only BaseSpread will be taken into account (AT4 for example)
SWEP.MovementSpread = 0 --Increase aimcone to this many degrees when sprinting at full speed
SWEP.UnscopedSpread = 0 --Spread, in degrees, when unscoped with a scoped weapon


--Model settings--
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/ace+/v_long_db.mdl"
SWEP.WorldModel = "models/ace+/w_long_db.mdl"
SWEP.HoldType = "shotgun"
SWEP.DeployDelay = 1 --Time before you can fire after deploying the weapon
SWEP.CSMuzzleFlashes = true
SWEP.UseHands = true
if CLIENT then
	local WorldModel = ClientsideModel(SWEP.WorldModel)

	-- Settings...
	WorldModel:SetSkin(1)
	WorldModel:SetNoDraw(true)

	function SWEP:DrawWorldModel()
		local _Owner = self:GetOwner()

		if (IsValid(_Owner)) then
            -- Specify a good position
			local offsetVec = Vector(4.5, -1, 0.5)
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

sound.Add( {
    name = "CA.LONGDB.shellout",
    channel = CHAN_STATIC,
    volume = 0.5,
    level = 80,
    sound       = "Weapons/sg/db_shotgun/reload1.wav"
} )

sound.Add( {
    name = "CA.LONGDB.shellin",
    channel = CHAN_STATIC,
    volume = 0.5,
    level = 80,
    sound       = "Weapons/sg/db_shotgun/reload2.wav"
} )
sound.Add( {
    name = "CA.LONGDB.Handle",
    channel = CHAN_STATIC,
    volume = 0.5,
    level = 80,
    sound       = "Weapons/sg/db_shotgun/select.wav"
} )
sound.Add( {
    name = "CA.LONGDB.Select",
    channel = CHAN_STATIC,
    volume = 0.5,
    level = 80,
    sound       = "Weapons/sg/db_shotgun/select.wav"
} )

function SWEP:Reload()
if (self:Clip1() <= 0) then
	self:DefaultReload( ACT_VM_RELOAD_EMPTY )
	else
	self:DefaultReload( ACT_VM_RELOAD )
	end
end


function SWEP:InitBulletData()
	self.BulletData = {}
	self.BulletData.Id = "7.62mmMG"
	self.BulletData.Type = "AP"
	self.BulletData.Id = 1
	self.BulletData.Caliber = 0.35
	self.BulletData.PropLength = 6 --Volume of the case as a cylinder * Powder density converted from g to kg
	self.BulletData.ProjLength = 7 --Volume of the projectile as a cylinder * streamline factor (Data5) * density of steel
	self.BulletData.Data5 = 0 --He Filler or Flechette count
	self.BulletData.Data6 = 0 --HEAT ConeAng or Flechette Spread
	self.BulletData.Data7 = 0
	self.BulletData.Data8 = 0
	self.BulletData.Data9 = 0
	self.BulletData.Data10 = 1 -- Tracer
	self.BulletData.Colour = Color(0, 0, 0)
	--
	self.BulletData.Data13 = 0 --THEAT ConeAng2
	self.BulletData.Data14 = 0 --THEAT HE Allocation
	self.BulletData.Data15 = 0
	self.BulletData.AmmoType = self.BulletData.Type
	self.BulletData.FrArea = 3.1416 * (self.BulletData.Caliber / 2) ^ 2
	self.BulletData.ProjMass = self.BulletData.FrArea * (self.BulletData.ProjLength * 7.9 / 1000)
	self.BulletData.PropMass = self.BulletData.FrArea * (self.BulletData.PropLength * ACF.PDensity / 1000) --Volume of the case as a cylinder * Powder density converted from g to kg
	--self.BulletData.DragCoef = 0.000001 --Alternatively manually set it
			self.BulletData.DragCoef  = ((self.BulletData.FrArea/10000)/self.BulletData.ProjMass)
	--		print( self.BulletData.DragCoef	)
	--Don't touch below here
	self.BulletData.MuzzleVel = ACF_MuzzleVelocity(self.BulletData.PropMass, self.BulletData.ProjMass, self.BulletData.Caliber)
	self.BulletData.ShovePower = 0.2
	self.BulletData.KETransfert = 0.3
	self.BulletData.PenArea = self.BulletData.FrArea ^ ACF.PenAreaMod * 1.5
	self.BulletData.Pos = Vector(0, 0, 0)
	self.BulletData.LimitVel = 800
	self.BulletData.Ricochet = 60
	self.BulletData.Flight = Vector(0, 0, 0)
	self.BulletData.BoomPower = self.BulletData.PropMass
	--For Fake Crate
	self.Type = self.BulletData.Type
	self.BulletData.Tracer = self.BulletData.Data10
	self.Tracer = self.BulletData.Tracer
	self.Caliber = self.BulletData.Caliber
	self.ProjMass = self.BulletData.ProjMass
	self.FillerMass = self.BulletData.Data5
	self.DragCoef = self.BulletData.DragCoef
	self.Colour = self.BulletData.Colour
end