if not SERVER then return end

local ENABLE = CreateConVar( "ace_npc_antitank", "1", FCVAR_ARCHIVE, "Redirect NPC anti-tank launcher shots at ACE vehicle components." )
local DEBUG = CreateConVar( "ace_npc_antitank_debug", "0", FCVAR_ARCHIVE, "Print ACE NPC anti-tank targeting decisions." )
local ZOFFSET = CreateConVar( "ace_npc_antitank_zoffset", "0", FCVAR_ARCHIVE, "Vertical offset (units, negative = lower) applied to ACE vehicle component aim point." )
local BALLISTICS = CreateConVar( "ace_npc_antitank_ballistics", "1", FCVAR_ARCHIVE, "Apply vertical ballistic correction to NPC anti-tank launcher shots." )
local LEAD = CreateConVar( "ace_npc_antitank_lead", "1", FCVAR_ARCHIVE, "Apply angular lead to moving targets." )
local LEAD_MINSPEED = CreateConVar( "ace_npc_antitank_lead_minspeed", "20", FCVAR_ARCHIVE, "Minimum target speed (units/s) before lead is applied." )

local LAUNCHERS = {
	"weapon_ace_rpg7",
	"weapon_ace_rpg7v2",
	"weapon_ace_rpg7v2t",
	"weapon_ace_rpg26",
	"weapon_ace_rpg28",
	"weapon_ace_rpg29",
	"weapon_ace_m72law",
	"weapon_ace_matador",
	"weapon_ace_panzerfaust3",
	"weapon_ace_carlgustaf",
	"weapon_ace_carlgustafhe",
	"weapon_ace_shmel",
	"weapon_ace_rshg2",
	"weapon_ace_9k32",
	"weapon_ace_9k38",
	"weapon_ace_at4",
	"weapon_ace_at4t",
}

local LAUNCHER_SET = {}
for _, name in ipairs( LAUNCHERS ) do
	LAUNCHER_SET[name] = true
end

print( "[ACE NPC AntiTank] file loaded" )

local function GetContraption( ent )
	if not IsValid( ent ) or not ent.CFW_GetContraption then return nil end
	local con = ent:CFW_GetContraption()
	if not con or not con.ents or not next( con.ents ) then return nil end
	return con
end

local function PriorityOf( ent )
	local class = ent:GetClass()
	if class == "acf_ammo" then return 1 end
	if class:find( "^ace_crewseat_" ) then return 2 end
	if class == "acf_engine" then return 3 end
	return nil
end

local function AmmoVolume( ent )
	local acf = ent.ACF
	return ( acf and acf.Volume ) or ent.Volume or 0
end

local function IsAlive( ent )
	local acf = ent.ACF
	return not ( acf and acf.Health and acf.Health <= 0 )
end

local function HasPriorityComponent( con )
	for ent in pairs( con.ents ) do
		if IsValid( ent ) and PriorityOf( ent ) then return true end
	end
	return false
end

local function WalkContraption( ent )
	local depth = 0
	while IsValid( ent ) and depth < 16 do
		local con = GetContraption( ent )
		if con and HasPriorityComponent( con ) then return con end
		ent = ent:GetParent()
		depth = depth + 1
	end
	return nil
end

local function GetContraptionOwner( con )
	local base = con and con.GetACEBaseplate and con:GetACEBaseplate()
	if IsValid( base ) and base.CPPIGetOwner then
		local owner = base:CPPIGetOwner()
		if IsValid( owner ) then return owner end
	end
	return nil
end

local function GetContraptionId( con )
	for ent in pairs( con.ents ) do
		if IsValid( ent ) then
			local acf = ent.ACF
			if acf and acf.ContraptionId then return acf.ContraptionId end
		end
	end
end

local function CollectComponents( con )
	local list = {}
	local seen = {}
	local conId = GetContraptionId( con )

	local function add( ent )
		if IsValid( ent ) and not seen[ent] then
			seen[ent] = true
			list[#list + 1] = ent
		end
	end

	for ent in pairs( con.ents ) do
		add( ent )
	end

	if conId and ACE then
		for _, ent in ipairs( ACE.critEnts or {} ) do
			if IsValid( ent ) and ent.ACF and ent.ACF.ContraptionId == conId then
				add( ent )
			end
		end
	end

	return list
end

local function HasLineOfSight( npc, target, filter )
	local tr = util.TraceLine( {
		start = npc:GetShootPos(),
		endpos = target:WorldSpaceCenter(),
		filter = filter,
		mask = MASK_SOLID,
	} )
	return ( not tr.Hit ) or tr.Fraction >= 0.99 or tr.Entity == target
end

local function PickComponent( npc, con )
	local origin = npc:GetShootPos()
	local components = CollectComponents( con )
	local filter = { npc }
	for _, ent in ipairs( components ) do
		filter[#filter + 1] = ent
	end

	local best, bestPriority, bestDistance, bestWeight

	for _, ent in ipairs( components ) do
		if IsAlive( ent ) then
			local priority = PriorityOf( ent )
			if priority then
				local distance = origin:DistToSqr( ent:WorldSpaceCenter() )
				local weight = priority == 1 and AmmoVolume( ent ) or 0
				if HasLineOfSight( npc, ent, filter ) then
					if not bestPriority
						or priority < bestPriority
						or ( priority == bestPriority and ( weight > bestWeight
							or ( weight == bestWeight and distance < bestDistance ) ) ) then
						best, bestPriority, bestDistance, bestWeight = ent, priority, distance, weight
					end
				end
			end
		end
	end

	return best
end

local function CriticalParts()
	local parts = {}
	if not ACE then return parts end

	for _, list in ipairs( { ACE.Explosives or {}, ACE.Crewseats or {} } ) do
		for _, ent in ipairs( list ) do
			parts[#parts + 1] = ent
		end
	end

	for _, ent in ipairs( ACE.critEnts or {} ) do
		if IsValid( ent ) and ent:GetClass() == "acf_engine" then
			parts[#parts + 1] = ent
		end
	end

	return parts
end

local function FindNearbyContraption( origin, requiredOwner, maxDistanceSqr )
	if not IsValid( origin ) then return nil end

	local best, bestDistance
	for _, ent in ipairs( CriticalParts() ) do
		if IsValid( ent ) then
			local con = GetContraption( ent )
			if con then
				local ownerOk = true
				if requiredOwner then
					local conOwner = GetContraptionOwner( con )
					if conOwner and conOwner ~= requiredOwner then ownerOk = false end
				end

				if ownerOk then
					local distance = origin:DistToSqr( ent:WorldSpaceCenter() )
					if distance <= maxDistanceSqr and ( not bestDistance or distance < bestDistance ) then
						best, bestDistance = con, distance
					end
				end
			end
		end
	end

	return best
end

local function FindSeatContraption( enemy )
	for _, ent in ipairs( ACE and ACE.critEnts or {} ) do
		if IsValid( ent ) and ent:GetClass() == "prop_vehicle_prisoner_pod" then
			local driver = ent.GetDriver and ent:GetDriver()
			if ent.sittingPly == enemy or ( IsValid( driver ) and driver == enemy ) then
				local con = WalkContraption( ent )
				if con then return con end
			end
		end
	end
	return nil
end

local function FindEnemyContraption( enemy )
	local vehicle
	if enemy.GetVehicle then
		vehicle = enemy:GetVehicle()
	end

	local con = WalkContraption( vehicle )
	if con then return con end

	con = WalkContraption( enemy )
	if con then return con end

	con = FindSeatContraption( enemy )
	if con then return con end

	if IsValid( vehicle ) then
		con = FindNearbyContraption( vehicle:WorldSpaceCenter(), nil, 400 * 400 )
		if con then return con end
	end

	return nil
end

local BALLISTIC_GRAVITY = 9.8
local METERS_TO_UNITS = 39.37
local BALLISTIC_STEP = 1 / 60
local BALLISTIC_MAX_STEPS = 1200
local BALLISTIC_TOLERANCE = 0.5
local BALLISTIC_MAX_ITERATIONS = 5
local BALLISTIC_SCAN_ITERATIONS = 14
local BALLISTIC_MIN_PITCH = math.rad( -30 )
local BALLISTIC_MAX_PITCH = math.rad( 50 )
local LEAD_MAX_ITERATIONS = 4
local LEAD_TIME_EPSILON = 0.02

-- The missile only needs the distance travelled along the aim direction and the
-- height, so simulate those two scalars instead of full 3D vectors.
local function SimulateAtHorizontalDistance( pitch, speed, drag, targetDistance )
	local horizontalSpeed = math.cos( pitch ) * speed
	local verticalSpeed = math.sin( pitch ) * speed
	local distance = 0
	local height = 0
	local stepDistance = METERS_TO_UNITS * BALLISTIC_STEP
	local gravityStep = BALLISTIC_GRAVITY * BALLISTIC_STEP

	for i = 1, BALLISTIC_MAX_STEPS do
		verticalSpeed = verticalSpeed - gravityStep

		local prevDistance = distance
		local prevHeight = height
		distance = distance + horizontalSpeed * stepDistance
		height = height + verticalSpeed * stepDistance

		if drag > 0 then
			local speedNow = math.sqrt( horizontalSpeed * horizontalSpeed + verticalSpeed * verticalSpeed )
			if speedNow > 0 then
				local factor = drag * speedNow * BALLISTIC_STEP
				horizontalSpeed = horizontalSpeed - horizontalSpeed * factor
				verticalSpeed = verticalSpeed - verticalSpeed * factor
			end
		end

		if distance >= targetDistance then
			local span = distance - prevDistance
			local frac = span > 0.000001 and ( targetDistance - prevDistance ) / span or 1
			return prevHeight + ( height - prevHeight ) * frac, ( i - 1 + frac ) * BALLISTIC_STEP
		end
	end

	return nil
end

local function BallisticError( targetZ, horizDistance, spawnDistance, speed, drag, pitch )
	local cosPitch = math.cos( pitch )
	local sinPitch = math.sin( pitch )
	local spawnHorizontal = spawnDistance * cosPitch
	local remaining = horizDistance - spawnHorizontal
	if remaining <= 1 then return nil end

	local hitZ, flightTime = SimulateAtHorizontalDistance( pitch, speed, drag, remaining )
	if not hitZ then return nil end

	return ( spawnDistance * sinPitch + hitZ ) - targetZ, flightTime
end

local function SolveBallisticScan( targetZ, horizDistance, spawnDistance, speed, drag, horizDir )
	local prevPitch, prevError

	for degrees = -30, 50, 10 do
		local pitch = math.rad( degrees )
		local err = BallisticError( targetZ, horizDistance, spawnDistance, speed, drag, pitch )
		if err then
			if prevError and ( ( prevError <= 0 and err >= 0 ) or ( prevError >= 0 and err <= 0 ) ) then
				local lowPitch, highPitch = prevPitch, pitch
				local lowError = prevError

				for _ = 1, BALLISTIC_SCAN_ITERATIONS do
					local midPitch = ( lowPitch + highPitch ) * 0.5
					local midError, midTime = BallisticError( targetZ, horizDistance, spawnDistance, speed, drag, midPitch )
					if not midError then return nil end

					if math.abs( midError ) < BALLISTIC_TOLERANCE then
						local cosPitch = math.cos( midPitch )
						return Vector( horizDir.x * cosPitch, horizDir.y * cosPitch, math.sin( midPitch ) ), midPitch, midTime
					end

					if ( lowError <= 0 and midError >= 0 ) or ( lowError >= 0 and midError <= 0 ) then
						highPitch = midPitch
					else
						lowPitch, lowError = midPitch, midError
					end
				end

				local midPitch = ( lowPitch + highPitch ) * 0.5
				local midError, midTime = BallisticError( targetZ, horizDistance, spawnDistance, speed, drag, midPitch )
				if midError and math.abs( midError ) < BALLISTIC_TOLERANCE then
					local cosPitch = math.cos( midPitch )
					return Vector( horizDir.x * cosPitch, horizDir.y * cosPitch, math.sin( midPitch ) ), midPitch, midTime
				end

				return nil
			end

			prevPitch, prevError = pitch, err
		end
	end

	return nil
end

local function SolveBallisticAim( shootPos, targetPos, speed, drag, spawnDistance, allowFallback )
	local dx = targetPos.x - shootPos.x
	local dy = targetPos.y - shootPos.y
	local horizDistance = math.sqrt( dx * dx + dy * dy )
	if horizDistance < 1 then return nil end

	local horizDir = Vector( dx / horizDistance, dy / horizDistance, 0 )
	local targetZ = targetPos.z - shootPos.z

	local flatDistance = ( horizDistance - spawnDistance ) / METERS_TO_UNITS
	if flatDistance < 0 then flatDistance = 0 end

	local guessTime
	if drag > 0 then
		guessTime = ( math.exp( drag * flatDistance ) - 1 ) / ( drag * speed )
	else
		guessTime = flatDistance / speed
	end

	local drop = 0.5 * BALLISTIC_GRAVITY * guessTime * guessTime * METERS_TO_UNITS
	local lowPitch = math.atan2( targetZ + drop, horizDistance )
	local highPitch = lowPitch + math.rad( 0.5 )

	local lowError = BallisticError( targetZ, horizDistance, spawnDistance, speed, drag, lowPitch )
	local highError, highTime
	if lowError then
		highError, highTime = BallisticError( targetZ, horizDistance, spawnDistance, speed, drag, highPitch )
	end

	if lowError and highError then
		for _ = 1, BALLISTIC_MAX_ITERATIONS do
			if math.abs( highError ) < BALLISTIC_TOLERANCE then
				local cosPitch = math.cos( highPitch )
				return Vector( horizDir.x * cosPitch, horizDir.y * cosPitch, math.sin( highPitch ) ), highPitch, highTime
			end

			local denominator = highError - lowError
			if math.abs( denominator ) < 0.000000001 then break end

			local nextPitch = highPitch - highError * ( highPitch - lowPitch ) / denominator
			if nextPitch < BALLISTIC_MIN_PITCH or nextPitch > BALLISTIC_MAX_PITCH then break end

			lowPitch, lowError = highPitch, highError
			highPitch = nextPitch
			highError, highTime = BallisticError( targetZ, horizDistance, spawnDistance, speed, drag, highPitch )
			if not highError then break end
		end

		if highError and math.abs( highError ) < BALLISTIC_TOLERANCE then
			local cosPitch = math.cos( highPitch )
			return Vector( horizDir.x * cosPitch, horizDir.y * cosPitch, math.sin( highPitch ) ), highPitch, highTime
		end
	end

	if allowFallback == false then return nil end
	return SolveBallisticScan( targetZ, horizDistance, spawnDistance, speed, drag, horizDir )
end

local function VelocityAtPoint( ent, point )
	if not IsValid( ent ) then return nil end

	local phys = ent:GetPhysicsObject()
	if phys and phys:IsValid() and phys.GetVelocityAtPoint then
		local velocity = phys:GetVelocityAtPoint( point )
		if velocity and velocity:LengthSqr() > 1 then
			return velocity
		end
	end

	return ent:GetVelocity()
end

local function GetTargetVelocity( target, enemy, con )
	local velocity
	local targetPoint = IsValid( target ) and target:WorldSpaceCenter() or nil

	if IsValid( target ) then
		-- Welded/parented vehicle parts often report zero velocity themselves.
		-- ACE_GetPhysicalParent returns the physics root (usually the baseplate).
		local physEnt = ACE_GetPhysicalParent and ACE_GetPhysicalParent( target ) or target
		if IsValid( physEnt ) then
			velocity = VelocityAtPoint( physEnt, targetPoint )
			if velocity and velocity:LengthSqr() > 1 then
				return velocity, "component"
			end
		end
	end

	if con and con.GetACEBaseplate then
		local baseplate = con:GetACEBaseplate()
		if IsValid( baseplate ) then
			local point = targetPoint or baseplate:WorldSpaceCenter()
			velocity = VelocityAtPoint( baseplate, point )
			if velocity and velocity:LengthSqr() > 1 then
				return velocity, "baseplate"
			end
		end
	end

	if IsValid( enemy ) then
		local enemyPoint = enemy:WorldSpaceCenter()
		local vehicle = enemy.GetVehicle and enemy:GetVehicle()
		if IsValid( vehicle ) then
			local physVehicle = ACE_GetPhysicalParent and ACE_GetPhysicalParent( vehicle ) or vehicle
			if IsValid( physVehicle ) then
				velocity = VelocityAtPoint( physVehicle, enemyPoint )
				if velocity and velocity:LengthSqr() > 1 then
					return velocity, "vehicle"
				end
			end
		end

		local physEnemy = ACE_GetPhysicalParent and ACE_GetPhysicalParent( enemy ) or enemy
		if IsValid( physEnemy ) then
			velocity = VelocityAtPoint( physEnemy, enemyPoint )
			if velocity and velocity:LengthSqr() > 1 then
				return velocity, "enemyphys"
			end
		end

		velocity = enemy:GetVelocity()
		if velocity then
			return velocity, "enemy"
		end
	end

	return nil
end

local function ApproximateLeadDirection( shootPos, targetPos, targetVelocity, spawnDistance, speed )
	local targetDistance = ( targetPos - shootPos ):Length()
	local remaining = targetDistance - spawnDistance
	if remaining <= 1 then return nil end

	local flightTime = remaining / ( speed * METERS_TO_UNITS )
	local predictedPos = targetPos + targetVelocity * flightTime
	local dir = predictedPos - shootPos
	if dir:LengthSqr() < 0.01 then return nil end
	dir:Normalize()

	return dir, math.asin( math.Clamp( dir.z, -1, 1 ) ), flightTime
end

local function AimMissile( npc, data, weapon )
	local enemy = npc:GetEnemy()
	if not IsValid( enemy ) or enemy == npc then return end

	local con = FindEnemyContraption( enemy )
	local target
	if con then
		target = PickComponent( npc, con )
	end

	local targetPos
	if target then
		targetPos = target:WorldSpaceCenter() + Vector( 0, 0, ZOFFSET:GetFloat() )
	else
		targetPos = enemy:WorldSpaceCenter()
	end

	local targetClass = target and target:GetClass() or enemy:GetClass()
	local enemyName = enemy:GetClass()
	if enemy:IsPlayer() then
		enemyName = enemy:Nick()
	end

	if DEBUG:GetBool() and not target then
		print( string.format( "[ACE NPC AntiTank] %s for %s, aiming at enemy",
			con and "no visible component" or "no contraption", enemyName ) )
	end

	local shootPos = npc:GetShootPos()
	local dir = targetPos - shootPos
	if dir:LengthSqr() < 0.01 then return end
	dir:Normalize()

	npc.ACE_AntiTankAim = targetPos
	npc.ACE_AntiTankAimTime = CurTime() + 5

	if npc.SetEyeTarget then
		pcall( npc.SetEyeTarget, npc, targetPos )
	end

	local distance = isvector( data.Pos ) and ( data.Pos - shootPos ):Length() or 800
	if distance < 1 then distance = 800 end

	local aimDir = dir
	local speed = tonumber( data.InitialVelocity ) or 0
	local drag = tonumber( data.Drag ) or 0
	local ballistic = false
	local pitch = 0
	local flightTime = 0
	local leadSpeed = 0
	local leadIters = 0
	local velocitySource = "none"

	local guidance = string.lower( tostring( data.GuidanceName or "dumb" ) )
	local powered = ( tonumber( data.Thrust ) or 0 ) > 0 or ( tonumber( data.BoostThrust ) or 0 ) > 0

	if BALLISTICS:GetBool() and speed > 0 and guidance == "dumb" and not powered then
		local solvedDir, solvedPitch, solvedTime = SolveBallisticAim( shootPos, targetPos, speed, drag, distance )
		if solvedDir then
			aimDir = solvedDir
			pitch = solvedPitch
			flightTime = solvedTime or 0
			ballistic = true
		end
	end

	if LEAD:GetBool() and speed > 0 and guidance == "dumb" and not powered then
		local targetVelocity, source = GetTargetVelocity( target, enemy, con )
		velocitySource = source or "none"
		if targetVelocity then
			local minSpeed = LEAD_MINSPEED:GetFloat()
			local speedSqr = targetVelocity:LengthSqr()
			leadSpeed = math.sqrt( speedSqr )
			if speedSqr >= minSpeed * minSpeed then
				if ballistic and flightTime > 0 then
					local predictedTime = flightTime
					for i = 1, LEAD_MAX_ITERATIONS do
						leadIters = i
						local predictedPos = targetPos + targetVelocity * predictedTime
						local leadDir, leadPitch, leadTime = SolveBallisticAim( shootPos, predictedPos, speed, drag, distance, false )
						if not leadDir then
							local approxDir, approxPitch, approxTime = ApproximateLeadDirection( shootPos, targetPos, targetVelocity, distance, speed )
							if approxDir then
								aimDir = approxDir
								pitch = approxPitch
								flightTime = approxTime
							end
							break
						end

						aimDir = leadDir
						pitch = leadPitch
						flightTime = leadTime or predictedTime

						if math.abs( flightTime - predictedTime ) < LEAD_TIME_EPSILON then break end
						predictedTime = flightTime
					end
				else
					local approxDir, approxPitch, approxTime = ApproximateLeadDirection( shootPos, targetPos, targetVelocity, distance, speed )
					if approxDir then
						aimDir = approxDir
						pitch = approxPitch
						flightTime = approxTime
						leadIters = 1
					end
				end
			end
		end
	end

	data.Pos = shootPos + aimDir * distance
	data.Ang = aimDir:Angle()

	if DEBUG:GetBool() then
		print( string.format( "[ACE NPC AntiTank] %s [%s] -> %s at %.0f units (aim z %.1f, zoff %.1f, vol %.2f, ballistic %s, elev %.2f, v0 %.0f, drag %.4f, lead %.1f, vsrc %s, leadit %d, tof %.2f)",
			npc:GetClass(), weapon:GetClass(), targetClass, distance, targetPos.z, ZOFFSET:GetFloat(), target and AmmoVolume( target ) or 0,
			ballistic and "on" or "off", math.deg( pitch ), speed, drag, leadSpeed, velocitySource, leadIters, flightTime ) )

		if not ballistic and BALLISTICS:GetBool() and speed > 0 and guidance == "dumb" and not powered then
			print( string.format( "[ACE NPC AntiTank] ballistic solve failed for %s at %.0f units (target z %.1f)",
				targetClass, distance, targetPos.z ) )
		end
	end
end

local installed = false
local originalGenerate
local pendingOwner

local function OnGenerateMissile( data, crate, bdata )
	if ENABLE:GetBool() and istable( data ) then
		local npc = data.Owner
		if IsValid( npc ) and npc:IsNPC() then
			local weapon = npc:GetActiveWeapon()
			if IsValid( weapon ) and LAUNCHER_SET[string.lower( weapon:GetClass() )] then
				local ok, err = pcall( AimMissile, npc, data, weapon )
				if not ok and DEBUG:GetBool() then
					print( "[ACE NPC AntiTank] targeting error: " .. tostring( err ) )
				end

				-- ACE credits bullets to the NPC's owner/creator, not the NPC
				-- itself (see weapon_ace_base:ACEFireBullet). Missiles instead use
				-- the raw NPC, which prop protection often drops, so the shell ends
				-- up owned by worldspawn and neither damages nor credits players.
				local resolved = ( npc.CPPIGetOwner and npc:CPPIGetOwner() ) or npc:GetOwner() or npc
				if IsValid( resolved ) then
					data.Owner = resolved
					pendingOwner = resolved
				end
			end
		end
	end

	local result = originalGenerate( data, crate, bdata )
	pendingOwner = nil
	return result
end
ACE_NPC_AntiTank_Wrapper = OnGenerateMissile

-- Safety net: if prop protection still rejects/loses the owner, force it onto
-- the freshly spawned missile so Detonate credits a real entity, not worldspawn.
hook.Add( "OnEntityCreated", "ACE_NPC_AntiTank_Owner", function( ent )
	if not pendingOwner then return end
	if not IsValid( ent ) or ent:GetClass() ~= "ace_missile" then return end

	local resolved = pendingOwner
	pendingOwner = nil

	timer.Simple( 0, function()
		if not IsValid( ent ) then return end
		local owner = ent.CPPIGetOwner and ent:CPPIGetOwner()
		if not IsValid( owner ) or ( owner:IsWorld() ) then
			ent.CPPIOwner = resolved
			if ent.SetNWEntity then ent:SetNWEntity( "CPPIOwner", resolved ) end
			ent.DamageOwner = resolved
		end
	end )
end )

local function Install()
	if type( ACE_GenerateMissile ) ~= "function" then return end
	if ACE_GenerateMissile == ACE_NPC_AntiTank_Wrapper then return end

	originalGenerate = ACE_GenerateMissile
	ACE_GenerateMissile = OnGenerateMissile

	if not installed then
		installed = true
		print( "[ACE NPC AntiTank] missile hook installed" )
	end
end

timer.Simple( 0.5, Install )
timer.Simple( 2, Install )
timer.Create( "ACE_NPC_AntiTank_Guard", 5, 0, Install )

hook.Add( "InitPostEntity", "ACE_NPC_AntiTank_Patch", function()
	Install()
	timer.Simple( 2, Install )
	timer.Simple( 10, Install )
end )

concommand.Add( "ace_npc_antitank_status", function()
	print( string.format( "[ACE NPC AntiTank] enable=%s debug=%s ballistics=%s lead=%s lead_minspeed=%.0f installed=%s wrapped=%s",
		tostring( ENABLE:GetBool() ), tostring( DEBUG:GetBool() ), tostring( BALLISTICS:GetBool() ),
		tostring( LEAD:GetBool() ), LEAD_MINSPEED:GetFloat(),
		tostring( installed ), tostring( ACE_GenerateMissile == ACE_NPC_AntiTank_Wrapper ) ) )
end )
