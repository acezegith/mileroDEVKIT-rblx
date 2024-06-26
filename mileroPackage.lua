-- DO NOT PLACE THIS FILE IN ANY PLACE ACCESSIBLE BY THE CLIENT
-- DO NOT PLACE THIS FILE IN ANY PLACE ACCESSIBLE BY THE CLIENT
-- DO NOT PLACE THIS FILE IN ANY PLACE ACCESSIBLE BY THE CLIENT
-- DO NOT PLACE THIS FILE IN ANY PLACE ACCESSIBLE BY THE CLIENT
-- DO NOT PLACE THIS FILE IN ANY PLACE ACCESSIBLE BY THE CLIENT

-- EDIT THE VARIABLES BELOW

local accessCode = "PROVIDED WITH SETUP"
local hubId = "PROVIDED WITH SETUP"


-- DO NOT MODIFY ANYTHING BELOW THIS LINE
local HttpService = game:GetService("HttpService")
local API_URL = "http://13.51.43.246:3000"
local DEV_KIT_VERSION = "v0.65"

local module = {}

-- LOWLEVEL FUNCTIONS
----------------------------------------------- USERS & HUBS -----------------------------------------------

-- FETCHING MILERO API TO RETRIEVE USER DATA
module.getUser = function(mainUserId)
	local scucces, res = pcall(function()
		return HttpService:GetAsync(API_URL .. "/api/hubs/" .. hubId .. "/accounts/" .. mainUserId .. "?apiCode=" .. accessCode .. "&userType=roblox")
	end)
	local data = false
	if scucces then
		data = HttpService:JSONDecode(res).info
	end

	return data
end

-- FETCHING MILERO API TO RETRIEVE HUB DATA
module.getHub = function()
	local scucces, res = pcall(function()
		return HttpService:GetAsync(API_URL .. "/api/hubs/" .. hubId .. "?apiCode=" .. accessCode .. "&userType=roblox")
	end)
	local data = false
	if scucces then
		data = HttpService:JSONDecode(res).info
	end

	return data
end

-- PUT REQUEST TO UPDATE USER IN HUB
module.updateUser = function(userId, userData)
	local scucces, res = pcall(function()
		return HttpService:RequestAsync({
			Url = (API_URL .. "/api/hubs/" .. hubId .. "/accounts/" .. userId .. "?apiCode=" .. accessCode .. "&userType=roblox"), -- This website helps debug HTTP requests
			Method = "PUT",
			Headers = {
				["Content-Type"] = "application/json", -- When sending JSON, set this!
			},
			Body = HttpService:JSONEncode(userData),
		})
	end)

	local data = false
	if scucces then
		data = HttpService:JSONDecode(res)
	end

	return data

end

-- GET REQUEST TO OBTAIN USER'S GLOBAL ACCOUNT PUBLIC INFORMATION (USED MAINLY TO OBTAIN DATA LINKED TO DISCORD)
module.getUserAccount = function(userId)
	local scucces, res = pcall(function()
		return HttpService:GetAsync(API_URL .. "/api/users/" .. userId .. "?apiCode=" .. accessCode .. "&reqType=roblox")
	end)
	local data = false
	if scucces then
		data = HttpService:JSONDecode(res).info
	end

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

----------------------------------------------- / ----------------------------------------------- 

-- MEDIUM LEVEL FUNCTIONS

module.getUserCards = function(userId)

	local hub = module.getHub()

	local card_tiers = hub.card_tiers
	local user_cards = hub.accounts[userId].miles_cards

	for i, card in pairs(user_cards) do

		local tier = card_tiers[card.card_tier]

		card.tier_prototype = tier

	end

end

module.getUserCard = function(userId, cardId)

	local hub = module.getHub()

	local card_tiers = hub.card_tiers
	local user_cards = hub.accounts[userId].miles_cards

	local card = user_cards[cardId]

	local tier = card_tiers[card.card_tier]

	card.tier_prototype = tier
	
	return card
end

return module
