if not SERVER then return end

local ENABLE = CreateConVar( "ace_npc_vehicle_vision", "1", FCVAR_ARCHIVE, "Make occupied ACE contraption parts non-blocking for NPC line of sight." )
local DEBUG = CreateConVar( "ace_npc_vehicle_vision_debug", "0", FCVAR_ARCHIVE, "Print ACE NPC vehicle vision diagnostics." )

local LOS_FLAG = EFL_DONTBLOCKLOS
if not LOS_FLAG then return end

local function GetContraption( ent )
	if not IsValid( ent ) or not ent.CFW_GetContraption then return nil end
	local con = ent:CFW_GetContraption()
	if not con or not con.ents or not next( con.ents ) then return nil end
	return con
end

local function WalkContraption( ent )
	local depth = 0
	while IsValid( ent ) and depth < 16 do
		local con = GetContraption( ent )
		if con then return con end
		ent = ent:GetParent()
		depth = depth + 1
	end
	return nil
end

local function PlayerContraption( ply )
	local vehicle = ply:GetVehicle()

	local con = WalkContraption( vehicle )
	if con then return con end

	if IsValid( vehicle ) then
		con = GetContraption( vehicle )
		if con then return con end
	end

	for _, ent in ipairs( ACE and ACE.critEnts or {} ) do
		if IsValid( ent ) and ent:GetClass() == "prop_vehicle_prisoner_pod" then
			local driver = ent.GetDriver and ent:GetDriver()
			if ent.sittingPly == ply or ( IsValid( driver ) and driver == ply ) then
				con = WalkContraption( ent )
				if con then return con end
			end
		end
	end

	return nil
end

local function ContraptionKey( con )
	local base = con.GetACEBaseplate and con:GetACEBaseplate()
	if IsValid( base ) then return base:EntIndex() end

	local best
	for ent in pairs( con.ents ) do
		if IsValid( ent ) then
			local idx = ent:EntIndex()
			if not best or idx < best then best = idx end
		end
	end
	return best
end

local tracked = {}

local function FlagEntity( ent, key )
	if not IsValid( ent ) then return end

	if not ent:IsEFlagSet( LOS_FLAG ) then
		ent:AddEFlags( LOS_FLAG )
		ent.ACE_NPC_VisionAdded = true
	end

	tracked[ent] = key
end

local function ClearEntity( ent )
	if IsValid( ent ) and ent.ACE_NPC_VisionAdded then
		ent:RemoveEFlags( LOS_FLAG )
		ent.ACE_NPC_VisionAdded = nil
	end
	tracked[ent] = nil
end

local function Think()
	if not ENABLE:GetBool() then
		for ent in pairs( tracked ) do ClearEntity( ent ) end
		return
	end

	local occupied = {}
	for _, ply in ipairs( player.GetAll() ) do
		local con = PlayerContraption( ply )
		if con then
			local key = ContraptionKey( con )
			if key then occupied[key] = con end
		end
	end

	for key, con in pairs( occupied ) do
		for ent in pairs( con.ents ) do
			if IsValid( ent ) then
				FlagEntity( ent, key )
			end
		end
	end

	for ent, key in pairs( tracked ) do
		if not IsValid( ent ) or not occupied[key] then
			ClearEntity( ent )
		end
	end
end

timer.Create( "ACE_NPC_VehicleVision", 0.25, 0, Think )

concommand.Add( "ace_npc_vehicle_vision_report", function()
	local occupied = {}
	for _, ply in ipairs( player.GetAll() ) do
		local con = PlayerContraption( ply )
		if con then
			local key = ContraptionKey( con )
			if key then occupied[key] = con end
		end
	end

	local count = 0
	for key, con in pairs( occupied ) do
		for ent in pairs( con.ents ) do
			if IsValid( ent ) then count = count + 1 end
		end
	end

	print( string.format( "[ACE NPC Vision] %d occupied contraption(s), %d part(s) flagged, %d tracked entity(ies)",
		table.Count( occupied ), count, table.Count( tracked ) ) )
end )

if DEBUG:GetBool() then
	print( "[ACE NPC Vision] loaded (EFL_DONTBLOCKLOS = " .. tostring( LOS_FLAG ) .. ")" )
end
