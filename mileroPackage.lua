-- EDIT THE VARIABLES BELOW

local accessCode = "" -- The accessCode obtained from the /setup command.
local hubId = "" -- The hubId obtained from the /setup command.


-- DO NOT MODIFY ANYTHING BELOW THIS LINE
local HttpService = game:GetService("HttpService")
local API_URL = "" -- The API URL
local DEV_KIT_VERSION = "v0.5" -- Current DEVKIT Version

local module = {}

----------------------------------------------- USERS & HUBS -----------------------------------------------

-- FETCHING MILERO API TO RETRIEVE USER DATA
module.getUser = function(userId)
	local res = HttpService:GetAsync(API_URL .. "/api/hubs/" .. hubId .. "/accounts/" .. userId .. "?apiCode=" .. accessCode .. "&userType=roblox")
	local data = HttpService:JSONDecode(res.Body)
	
	return data
end

-- FETCHING MILERO API TO RETRIEVE HUB DATA
module.getHub = function()
	local res = HttpService:GetAsync(API_URL .. "/api/hubs/" .. hubId .. "?apiCode=" .. accessCode .. "&userType=roblox")
	local data = HttpService:JSONDecode(res.Body)
	
	
	return data
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
	local data = HttpService:JSONDecode(res.Body)

	return data
	
end

-- GET REQUEST TO OBTAIN USER'S GLOBAL ACCOUNT PUBLIC INFORMATION (USED MAINLY TO OBTAIN DATA LINKED TO DISCORD)
module.getUserAccount = function(userId)
	local res = HttpService:GetAsync(API_URL .. "/api/users/" .. userId .. "?apiCode=" .. accessCode .. "&userType=roblox")
	local data = HttpService:JSONDecode(res.Body)

	return data
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

return module
