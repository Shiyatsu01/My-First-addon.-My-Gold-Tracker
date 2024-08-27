local frame = CreateFrame("Frame", "MyGoldTrackerFrame", UIParent, "BasicFrameTemplateWithInset")
frame:SetSize(300, 300)  -- Aumentei a altura para acomodar o novo layout
frame:SetPoint("CENTER")
frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

-- Título
local title = frame:CreateFontString(nil, "OVERLAY")
title:SetFontObject("GameFontHighlightLarge")
title:SetPoint("TOP", frame, "TOP", 0, -10)
title:SetText("My Gold Tracker")

-- Botão de Fechar
local closeButton = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -5, -5)

-- Texto de Ouro Atual
local goldText = frame:CreateFontString(nil, "OVERLAY")
goldText:SetFontObject("GameFontHighlightLarge")
goldText:SetPoint("TOP", title, "BOTTOM", 0, -20)

-- Texto de Entrada
local incomeText = frame:CreateFontString(nil, "OVERLAY")
incomeText:SetFontObject("GameFontHighlight")
incomeText:SetPoint("TOPLEFT", goldText, "BOTTOMLEFT", 0, -20)

-- Texto de Saída
local expenseText = frame:CreateFontString(nil, "OVERLAY")
expenseText:SetFontObject("GameFontHighlight")
expenseText:SetPoint("TOPLEFT", incomeText, "BOTTOMLEFT", 0, -20)

-- Texto de Lucro
local profitText = frame:CreateFontString(nil, "OVERLAY")
profitText:SetFontObject("GameFontHighlight")
profitText:SetPoint("TOPLEFT", expenseText, "BOTTOMLEFT", 0, -20)

-- Tabela
local tableTitle = frame:CreateFontString(nil, "OVERLAY")
tableTitle:SetFontObject("GameFontHighlight")
tableTitle:SetPoint("TOPLEFT", profitText, "BOTTOMLEFT", 0, -40)
tableTitle:SetText("Fonte - Entrada - Saída")

local merchantText = frame:CreateFontString(nil, "OVERLAY")
merchantText:SetFontObject("GameFontHighlight")
merchantText:SetPoint("TOPLEFT", tableTitle, "BOTTOMLEFT", 0, -20)
merchantText:SetText("Mercadores")

local repairText = frame:CreateFontString(nil, "OVERLAY")
repairText:SetFontObject("GameFontHighlight")
repairText:SetPoint("TOPLEFT", merchantText, "BOTTOMLEFT", 0, -20)
repairText:SetText("Reparo")

local initialGold = 0
local totalIncome = 0
local totalExpense = 0

local function UpdateGold()
    local currentGold = GetMoney()
    local gold = floor(currentGold / (COPPER_PER_SILVER * SILVER_PER_GOLD))
    local silver = floor((currentGold % (COPPER_PER_SILVER * SILVER_PER_GOLD)) / COPPER_PER_SILVER)
    local copper = currentGold % COPPER_PER_SILVER

    goldText:SetText(format("Ouro Atual: %d|TInterface\\MoneyFrame\\UI-GoldIcon:0:0:2:0|t %d|TInterface\\MoneyFrame\\UI-SilverIcon:0:0:2:0|t %d|TInterface\\MoneyFrame\\UI-CopperIcon:0:0:2:0|t", gold, silver, copper))

    local profit = currentGold - initialGold
    local profitGold = floor(math.abs(profit) / (COPPER_PER_SILVER * SILVER_PER_GOLD))
    local profitSilver = floor((math.abs(profit) % (COPPER_PER_SILVER * SILVER_PER_GOLD)) / COPPER_PER_SILVER)
    local profitCopper = math.abs(profit) % COPPER_PER_SILVER

    incomeText:SetText(format("Entrada: %d|TInterface\\MoneyFrame\\UI-GoldIcon:0:0:2:0|t %d|TInterface\\MoneyFrame\\UI-SilverIcon:0:0:2:0|t %d|TInterface\\MoneyFrame\\UI-CopperIcon:0:0:2:0|t", totalIncome / (COPPER_PER_SILVER * SILVER_PER_GOLD), (totalIncome % (COPPER_PER_SILVER * SILVER_PER_GOLD)) / COPPER_PER_SILVER, totalIncome % COPPER_PER_SILVER))

    if totalExpense > 0 then
        expenseText:SetTextColor(1, 0, 0)  -- Vermelho
    else
        expenseText:SetTextColor(1, 1, 1)  -- Cor padrão
    end
    expenseText:SetText(format("Saída: %d|TInterface\\MoneyFrame\\UI-GoldIcon:0:0:2:0|t %d|TInterface\\MoneyFrame\\UI-SilverIcon:0:0:2:0|t %d|TInterface\\MoneyFrame\\UI-CopperIcon:0:0:2:0|t", totalExpense / (COPPER_PER_SILVER * SILVER_PER_GOLD), (totalExpense % (COPPER_PER_SILVER * SILVER_PER_GOLD)) / COPPER_PER_SILVER, totalExpense % COPPER_PER_SILVER))

    if profit >= 0 then
        profitText:SetTextColor(0, 1, 0)  -- Verde
        profitText:SetText(format("Lucro: %d|TInterface\\MoneyFrame\\UI-GoldIcon:0:0:2:0|t %d|TInterface\\MoneyFrame\\UI-SilverIcon:0:0:2:0|t %d|TInterface\\MoneyFrame\\UI-CopperIcon:0:0:2:0|t", profitGold, profitSilver, profitCopper))
    else
        profitText:SetTextColor(1, 0, 0)  -- Vermelho
        profitText:SetText(format("Gasto: %d|TInterface\\MoneyFrame\\UI-GoldIcon:0:0:2:0|t %d|TInterface\\MoneyFrame\\UI-SilverIcon:0:0:2:0|t %d|TInterface\\MoneyFrame\\UI-CopperIcon:0:0:2:0|t", profitGold, profitSilver, profitCopper))
    end
end

frame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_ENTERING_WORLD" then
        initialGold = GetMoney()
    end
    UpdateGold()
end)
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PLAYER_MONEY")
