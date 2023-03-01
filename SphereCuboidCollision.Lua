--[[
  ROBLOX implementation of a Sphere-Cuboid test using FM vectorey stuff
  This applies the test on all parts in the roblox character rig approximating each body part as a cuboid 
--]]

local RunService = game:GetService("RunService")

local Character = script.Parent
local Sphere = workspace.Part

local function AbsoluteVector(x)
	return Vector3.new(math.abs(x.X), math.abs(x.Y), math.abs(x.Z))
end

local function PartSphereCollisionCheck(Part, Sphere)
	local Radius = Sphere.Size.X/2 
	
	local VectorToSphere = Sphere.Position - Part.Position
	
	if VectorToSphere.Magnitude <= Radius then
		return true -- clearly true 
	end
	
	local RelativeVectorToSphere = Part.CFrame:Inverse() * VectorToSphere -- putting into object space 
	
	local Lambda = Part.Size/RelativeVectorToSphere
	local AbsoluteLambda = AbsoluteVector(Lambda)
	local ChosenLambda = nil
	
	if (AbsoluteLambda.X <= AbsoluteLambda.Y) and (AbsoluteLambda.X <= AbsoluteLambda.Z) then -- X hits first; hits YZ plane
		ChosenLambda = Lambda.X
	elseif (AbsoluteLambda.Y <= AbsoluteLambda.X) and (AbsoluteLambda.Y <= AbsoluteLambda.Z) then -- Y hits first; hits XZ plane
		ChosenLambda = Lambda.Y
	else -- Z hits first 
		ChosenLambda = Lambda.Z
	end

	local CentreToPointOnCuboid = (RelativeVectorToSphere * ChosenLambda/2) -- Vector from centre to point on cuboid that part-sphere line intersects

	return (VectorToSphere.Magnitude - CentreToPointOnCuboid.Magnitude) <= Radius -- Distance from collision point to sphere centre comparison
end

local function ScanRig(Rig, Sphere)
	for _,Part in ipairs(Character:GetChildren()) do
		if Part:IsA("BasePart") then
			if PartSphereCollisionCheck(Part, Sphere) then
				print("collision")
			end
		end
	end
end

RunService.Stepped:Connect(function(tt, dt)
	ScanRig(Character, Sphere)
end)
