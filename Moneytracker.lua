MoneyTracker = LibStub("AceAddon-3.0"):NewAddon("MoneyTracker", "AceConsole-3.0")

function MoneyTracker:OnInitialize()
    
  -- Create the main window frame
  local frame = CreateFrame("Frame", "MoneyTrackerFrame", UIParent, "BasicFrameTemplateWithInset")
  frame:SetSize(300, 200)
  frame:SetPoint("CENTER", UIParent, "CENTER")
  frame:SetFrameStrata("DIALOG")
  frame:SetMovable(true)
  frame:SetUserPlaced(true)
  frame:SetScript("OnMouseDown", function(self, button)
    if button == "LeftButton" then
      self:StartMoving()
    end
  end)
  frame:SetScript("OnMouseUp", function(self, button)
    if button == "LeftButton" then
      self:StopMovingOrSizing()
    end
  end)

  -- Add a title text
  local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  title:SetPoint("TOP", frame, "TOP", 0, -4)
  title:SetText("Money Tracker")

  -- Add a money text display
  local moneyText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  moneyText:SetPoint("TOP", title, "BOTTOM", 0, -20)

  local totalMoneyEarned = 0
  local totalMoneyMinus = 0
  local sessionTotal = 0
  local blance = 0

  -- Add labels for the 'Money Gained' and 'Total Money Lost' displays
  local moneyGainedLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  moneyGainedLabel:SetPoint("TOPLEFT", moneyText, "BOTTOMLEFT", -135, 0)
  moneyGainedLabel:SetText("Money Gained: " .. GetCoinTextureString(0))
  local totalMoneyGained = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  totalMoneyGained:SetPoint("TOPLEFT", moneyGainedLabel, "BOTTOMLEFT", 0, -10)
  totalMoneyGained:SetText("Total Money Gained: " .. GetCoinTextureString(0))

  --Add line break
  local spacePlease = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  spacePlease:SetPoint("TOPLEFT", totalMoneyGained, "BOTTOMLEFT", 0, -10)
  spacePlease:SetText("--------------")

  --Add labels for the 'Money Lost' and 'Total Money Lost' displays
  local moneyLostLabel = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  moneyLostLabel:SetPoint("TOPLEFT", spacePlease, "BOTTOMLEFT", 0, -10)
  moneyLostLabel:SetText("Money Lost: " .. GetCoinTextureString(0))
  local totalMoneyLost = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  totalMoneyLost:SetPoint("TOPLEFT", moneyLostLabel, "BOTTOMLEFT", 0, -10)
  totalMoneyLost:SetText("Total Money Lost: " .. GetCoinTextureString(0))

  --Add label for 'Session Balance'
  local totalBalance = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  totalBalance:SetPoint("TOPLEFT", totalMoneyLost, "BOTTOMLEFT", 0, -20)
  totalBalance:SetText("Session Balance: " .. GetCoinTextureString(blance))


  frame:RegisterEvent("PLAYER_MONEY")
  frame:RegisterEvent("PLAYER_ENTERING_WORLD")
  frame:SetScript("OnEvent", function (self, event, ...)
    local tmpMoney = GetMoney() 
    if self.CurrentMoney then
      self.DiffMoney = tmpMoney - self.CurrentMoney
    else self.DiffMoney = 0
    end
    self.CurrentMoney = tmpMoney
    if self.DiffMoney > 0 then
      moneyGainedLabel:SetText("Money Gained: " .. GetCoinTextureString(self.DiffMoney))
      --update total money earned
      totalMoneyEarned = totalMoneyEarned + self.DiffMoney
        -- update the total money display
      totalMoneyGained:SetText("Total Money Gained: " .. GetCoinTextureString(totalMoneyEarned))
    elseif self.DiffMoney < 0 then
        sessionTotal = self.DiffMoney * -1
        moneyLostLabel:SetText("Money Lost: " .. GetCoinTextureString(sessionTotal))
        --update total money earned
        totalMoneyMinus = totalMoneyMinus + sessionTotal
        -- update the total money display
        totalMoneyLost:SetText("Total Money Lost: " .. GetCoinTextureString(totalMoneyMinus))
    end
    blance = totalMoneyEarned - totalMoneyMinus
    if blance > 0 then
      totalBalance:SetText("Session Balance: " .. GetCoinTextureString(blance))
      elseif blance < 0 then
        totalBalance:SetText("Session Balance: -" .. GetCoinTextureString(blance * -1))
    end
  end
  )

  local addon = LibStub("AceAddon-3.0"):NewAddon("Bunnies", "AceConsole-3.0")
  local bunnyLDB = LibStub("LibDataBroker-1.1"):NewDataObject("Bunnies!", {
  type = "data source",
  text = "Bunnies!",
  icon = "Druid_ability_wildmushroom_b",
  OnClick = function() 
    if frame:IsShown() then
    frame:Hide()
    else frame:Show()
    end
  end,
  })

  local icon = LibStub("LibDBIcon-1.0")
  
  function addon:OnInitialize() -- Obviously you'll need a ## SavedVariables: BunniesDB line in your TOC, duh! 
    self.db = LibStub("AceDB-3.0"):New("MoneyTrackerDB", { profile = { minimap = { hide = false, }, }, }) 
    icon:Register("Bunnies!", bunnyLDB, self.db.profile.minimap) self:RegisterChatCommand("bunnies", "CommandTheBunnies") 
  end
  
  function addon:CommandTheBunnies() self.db.profile.minimap.hide = not self.db.profile.minimap.hide 
    if self.db.profile.minimap.hide then icon:Hide("Bunnies!") else icon:Show("Bunnies!") 
    end 
  end
end



