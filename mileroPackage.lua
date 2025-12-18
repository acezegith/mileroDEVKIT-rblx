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
local API_URL = "https://api.milerorblx.com"
local DEV_KIT_VERSION = "v0.6"

local module = {}

-- LOWLEVEL FUNCTIONS
----------------------------------------------- USERS & HUBS -----------------------------------------------

-- FETCHING MILERO API TO RETRIEVE USER DATA
module.getUser = function(mainUserId)
	local success, res = pcall(function()
		return HttpService:GetAsync(API_URL .. "/api/hubs/" .. hubId .. "/accounts/" .. mainUserId .. "?apiCode=" .. accessCode .. "&userType=roblox")
	end)
	local data = false
	if success then
		data = HttpService:JSONDecode(res).info
	end

	return data
end

-- FETCHING MILERO API TO RETRIEVE HUB DATA
module.getHub = function()
	local success, res = pcall(function()
		return HttpService:GetAsync(API_URL .. "/api/hubs/" .. hubId .. "?apiCode=" .. accessCode .. "&userType=roblox")
	end)
	local data = false
	if success then
		data = HttpService:JSONDecode(res).info
	end
	
	data[`access_code`] = nil
	
	return data
end

module.getFlight = function(flightid)
	local success, res = pcall(function()
		return HttpService:GetAsync(API_URL .. "/api/flights/" .. flightid .. "?apiCode=" .. accessCode .. "&userType=roblox")
	end)
	local data = false
	if success then
		data = HttpService:JSONDecode(res).info
	end

	return data
end


module.getFlights = function()
	local success, res = pcall(function()
		return HttpService:GetAsync(API_URL .. "/api/flights/" .. "?apiCode=" .. accessCode .. "&userType=roblox")
	end)
	local data = false
	if success then
		data = HttpService:JSONDecode(res).info
	end

	return data
end

module.updateUserFlights = function(userId, operationIncrement: number)
	local success, res = pcall(function()
		return HttpService:RequestAsync({
			Url = (API_URL .. "/api/hubs/" .. hubId ..  "/" .. `accounts` .. `/` .. userId .. "/" .. `flights` .. "?apiCode=" .. accessCode .. "&userType=roblox&"), -- This website helps debug HTTP requests
			Method = "PUT",
			Headers = {
				["Content-Type"] = "application/json", -- When sending JSON, set this!
			},
			Body = HttpService:JSONEncode({operation=operationIncrement}),
		})
	end)	

	local data = false
	if success then
		data = HttpService:JSONDecode(res.Body).info
	end

	return data
end

module.updateUserCard = function(userId, cardId, operationIncrement: number)
	local success, res = pcall(function()
		return HttpService:RequestAsync({
			Url = (API_URL .. "/api/cards/" .. hubId ..  "/" .. userId .. "/" .. cardId .. "?apiCode=" .. accessCode .. "&userType=roblox&"), -- This website helps debug HTTP requests
			Method = "PUT",
			Headers = {
				["Content-Type"] = "application/json", -- When sending JSON, set this!
			},
			Body = HttpService:JSONEncode({operation=operationIncrement}),
		})
	end)	

	local data = false
	if success then
		data = HttpService:JSONDecode(res.Body).info
	end

	return data
end

-- GET REQUEST TO OBTAIN USER'S GLOBAL ACCOUNT PUBLIC INFORMATION (USED MAINLY TO OBTAIN DATA LINKED TO DISCORD)
module.getUserAccount = function(userId)
	local success, res = pcall(function()
		return HttpService:GetAsync(API_URL .. "/api/users/" .. userId .. "?apiCode=" .. accessCode .. "&reqType=roblox")
	end)
	local data = false
	if success then
		data = HttpService:JSONDecode(res).info
	end

	return data
end

----------------------------------------------- CLASSES & PURCHASES & BOOKINGS ----------------------------------------------- 

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

module.shopPurchase = function(productId, mainUserId, paymentCard)

	local success, res = pcall(function()
		return HttpService:RequestAsync({
			Url = (API_URL .. "/api/purchases/shop/" .. hubId ..  "/" .. productId .. "?apiCode=" .. accessCode .. "&userType=roblox&paymentCard=" .. paymentCard), -- This website helps debug HTTP requests
			Method = "PUT",
			Headers = {
				["Content-Type"] = "application/json", -- When sending JSON, set this!
			},
			Body = HttpService:JSONEncode({discord_id=mainUserId}),
		})
	end)	

	local data = false
	if success then
		data = HttpService:JSONDecode(res.Body).info
	end

	return data

end

module.getBooking = function(bookingref : string)
	local success, res = pcall(function()
		return HttpService:GetAsync(API_URL .. "/api/bookings/" .. bookingref .. "?apiCode=" .. accessCode .. "&userType=roblox")
	end)

	local data = false
	if success then
		data = HttpService:JSONDecode(res).info
	end

	return data
end

-- FETCHING MILERO API TO RETRIEVE BOOKING DATA
module.getFlightBookings = function(id)
	local success, res = pcall(function()
		return HttpService:GetAsync(API_URL .. "/api/flights/" .. id .. `/bookings` .. "?apiCode=" .. accessCode .. "&userType=roblox")
	end)
	local data = false
	if success then
		data = HttpService:JSONDecode(res).info
	end

	return data
end

----------------------------------------------- CHECK-IN ----------------------------------------------- 

module.checkInUser = function(userId, flightId, data)
	
	local success, res = pcall(function()
		return HttpService:RequestAsync({
			Url = (API_URL .. "/api/checkin/" .. flightId ..  "/" .. userId .. "?apiCode=" .. accessCode .. "&userType=roblox"), -- This website helps debug HTTP requests
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json", -- When sending JSON, set this!
			},
			Body = HttpService:JSONEncode(data),
		})
	end)	
	print(res)

	local data = false
	if success then
		data = HttpService:JSONDecode(res.Body).info
	end

	return data
	
end

module.getUserCheckins = function(userId)
	
	local success, res = pcall(function()
		return HttpService:GetAsync(API_URL .. "/api/checkin/user/" .. userId .. "?apiCode=" .. accessCode .. "&userType=roblox")
	end)
	local data = false
	if success then
		data = HttpService:JSONDecode(res).info
	end

	return data
	
end

module.getFlightCheckins = function(flightId)
	
	local success, res = pcall(function()
		return HttpService:GetAsync(API_URL .. "/api/checkin/flight/" .. flightId .. "?apiCode=" .. accessCode .. "&userType=roblox")
	end)
	local data = false
	if success then
		data = HttpService:JSONDecode(res).info
	end

	return data
	
end


module.cancelCheckin = function(userId, flightId)

	local success, res = pcall(function()
		return HttpService:RequestAsync({
			Url = (API_URL .. "/api/checkin/" .. flightId ..  "/" .. userId .. "?apiCode=" .. accessCode .. "&userType=roblox"), -- This website helps debug HTTP requests
			Method = "DELETE",
		})
	end)	

	local data = false
	if success then
		data = HttpService:JSONDecode(res.Body).info
	end

	return data

end

----------------------------------------------- / ----------------------------------------------- 

-- MIDDLE LEVEL FUNCTIONS

module.getShop = function()

	local hub = module.getHub()

	return hub.shop

end

module.getUserCards = function(userId)

	local hub = module.getHub()

	local card_tiers = hub.card_tiers
	if(not card_tiers) then
		return false
	end

	local user_cards = hub.accounts[userId].miles_cards
	if(not user_cards) then
		return false
	end

	for i, card in pairs(user_cards) do

		local tier = card_tiers[card.card_tier]
		if(not tier) then
			return false
		end

		card.tier_prototype = tier

	end

	return user_cards

end

module.getUserCard = function(userId, cardId)

	local hub = module.getHub()


	local card_tiers = hub.card_tiers
	if(not card_tiers) then
		return false
	end

	local user_cards = hub.accounts[userId].miles_cards
	if(not user_cards) then
		return false
	end

	local card = user_cards[cardId]
	if(not card) then
		return false
	end

	local tier = card_tiers[card.card_tier]
	if(not tier) then
		return false
	end

	card.tier_prototype = tier


	return card
end

return module
