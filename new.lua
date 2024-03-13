local gamememe = getrawmetatable(game)
local Closure,Caller = hide_me or newcclosure,checkcaller or is_protosmasher_caller or Cer.isCerus
local writeable = setreadonly(gamememe,false)
local name,index,nindex = gamememe.__namecall,gamememe.__index,gamememe.__newindex

-- HOOK WAIT TIME OF ROLL COOLDOWN AND RETURN OUR OWN SPEED 
-- YOU CAN DO EFFECTS CLIENTS NEW CLOSURE BUT THIS IS EASIER 
--[[
a = hookfunction(wait, function(b)
	if b == 2.3 and getgenv().rollcooldown then 
		return a(getgenv().rollspeed) 
	else
		return a(b)
	end
	return a(b)
end)
--]]
c = hookfunction(print, function(d)
	return c("no")
end)
-- no fall

local call
call = hookmetamethod(game,'__namecall', newcclosure(function(Self,...)
	local args = {...}
	if Caller() then return call(Self,...) end
	local method = getnamecallmethod()
   if method == 'FireServer' and getgenv().nofall and typeof(args[1]) == 'number' then
        return
   elseif method == 'FindFirstChild' and args[1] == "BodyVelocity" then
		return
   end
   return call(Self,...)
end))

-- HOOK WALK SPEED / JUMP SO WE DON'T HAVE TO CHANGE IT EVERY FRAME LIKE HYDRA HUB 
-- USING GETGENV() TO USE VARIABLES ACROSS SCRIPTS
-- USING EXTERNAL PASTEBIN HOOK BECAUSE OBFUSCATION CREATES LAG
-- RETURNING GRAVITY / CAMERA ZOOM PROPERTY IN CASE THEY MAKE A DETECTION METHOD FOR THAT 

wait(1)
gamememe.__newindex = Closure(function(self,Property,b)
	if not Caller() then
		if self:IsA("Humanoid") then
			if Property == "WalkSpeed" and getgenv().speedenabled then
				return nindex(self, Property, getgenv().speedspeed)
			elseif Property == "JumpPower" and getgenv().jumpenabled then
				return nindex(self, Property, getgenv().power)
			elseif Property == "WalkSpeed" and getgenv().noslow and b < 16 then
				return nindex(self, Property, 16)
			end
			nindex(self,Property,b)
		end

		if self.Name == "SlideVel" and tostring(Property) == "Velocity" and getgenv().slidespeed and getgenv().rollcooldown then 
			return nindex(self, Property, b * (1 + getgenv().slidespeed / 6))
		elseif self:IsA("BodyVelocity") and getgenv().slidespeed and tostring(Property) == "Velocity" and getgenv().rollcooldown then
			return nindex(self, Property, b * (1 + getgenv().climbspeed / 6)) 
		end
		
		if self.Name == "Lighting" and getgenv().noblindfold then -- there I optimized it better are u happy now
			if Property == "FogStart" then
				return nindex(self, Property, 1000)
			elseif Property == "Ambient" then
				return nindex(self, Property, Color3.fromRGB(0.17, 0.23, 0.2))
			elseif Property == "OutdoorAmbient" then
				return nindex(self, Property, Color3.fromRGB(200,200,200))
			end
			nindex(self,Property,b)
		end
		
		return nindex(self,Property,b)
	end

	return nindex(self,Property,b)
end)
