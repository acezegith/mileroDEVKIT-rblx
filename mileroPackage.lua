-- EDIT THE VARIABLES BELOW

local accessCode = "PROVIDED WITH SETUP"
local hubId = "PROVIDED WITH SETUP"


-- DO NOT MODIFY ANYTHING BELOW THIS LINE
local HttpService = game:GetService("HttpService")
local API_URL = "http://13.51.43.246:3000"
local DEV_KIT_VERSION = "v0.6"

local module = {}

-- LOWLEVEL FUNCTIONS
----------------------------------------------- USERS & HUBS -----------------------------------------------

-- FETCHING MILERO API TO RETRIEVE USER DATA
module.getUser = function(mainUserId)
	local res = HttpService:GetAsync(API_URL .. "/api/hubs/" .. hubId .. "/accounts/" .. mainUserId .. "?apiCode=" .. accessCode .. "&userType=roblox")
	local data = HttpService:JSONDecode(res)
	
	return data.info
end

-- FETCHING MILERO API TO RETRIEVE HUB DATA
module.getHub = function()
	local res = HttpService:GetAsync(API_URL .. "/api/hubs/" .. hubId .. "?apiCode=" .. accessCode .. "&userType=roblox")
	local data = HttpService:JSONDecode(res)
	
	
	return data.info
end

-- PUT REQUEST TO UPDATE USER IN HUB
module.updateUser = function(userId, userData)
	local res = HttpService:RequestAsync({
		Url = (API_URL .. "/api/hubs/" .. hubId .. "/accounts/" .. userId .. "?apiCode=" .. accessCode .. "&userType=roblox"), -- This website helps debug HTTP requests
		Method = "PUT",
		Headers = {
			["Content-Type"] = "application/json", -- When sending JSON, set this!
		},
		Body = HttpService:JSONEncode(userData),
	})
	local data = HttpService:JSONDecode(res)

	return data
	
end

-- GET REQUEST TO OBTAIN USER'S GLOBAL ACCOUNT PUBLIC INFORMATION (USED MAINLY TO OBTAIN DATA LINKED TO DISCORD)
module.getUserAccount = function(userId)
	local res = HttpService:GetAsync(API_URL .. "/api/users/" .. userId .. "?apiCode=" .. accessCode .. "&reqType=roblox")
	local data = HttpService:JSONDecode(res)

	return data.info
end

----------------------------------------------- CLASSES & PURCHASES ----------------------------------------------- 

-- GET ALL CLASSES PROVIDED BY AIRLINE/HUB
module.getHubClasses = function()
	local hub = module.getHub()
	return hub.shop
end


-- CHECK IF USER OWNS A CLASS
module.confirmClassOwnership = function(classId, robloxUserId)
	local shop = module.getHubClasses()
	local user = module.getUserAccount(robloxUserId)
	user = user.discord_id
	
	local owners = shop[classId].owners
	owners = HttpService:JSONDecode(owners)
	
	for i, owner in pairs(owners) do
		if owner == user then
			return true
		end
	end
	
	return false
end

----------------------------------------------- / ----------------------------------------------- 

-- MEDIUM LEVEL FUNCTIONS

module.incrementMiles = function(userid, amount)
	local success, user = pcall(function()
		return module.getUser(userid)
	end)

	if(not success) then
		return module.updateUser(userid, {miles = tostring(amount), flights = 0})
	end

	user.miles = user.miles + amount
	module.updateUser(userid, user)
end

module.incrementFlights = function(userid, amount)
	local success, user = pcall(function()
		return module.getUser(userid)
	end)

	if(not success) then
		return module.updateUser(userid, {flights = tostring(amount), miles = 0})
	end

	user.flights = user.flights + amount
	module.updateUser(userid, user)
end

return module
