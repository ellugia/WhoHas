WhoHasModConfig = WhoHasModConfig or {
   enabled = 1,
   totals = nil,
   stacks = nil,
}

WhoHasMod = {}

WhoHasMod.state = {
   player = "",
   realm = "",
   loaded = nil,
   inventoryChanged = 1,
   playerCache = {},
   altCache = {},
   warnedMissingBackend = nil,
}

WhoHasMod.categories = {
   "Inventory",
   "Bank",
}

WhoHasMod.formats = {
   Inventory = "%u in %s's inventory",
   Bank = "%u in %s's bank",
   total = "%u total",
   stack = "Stack size: %u",
}

WhoHasMod.Poss = {
   Inventory = { 0, 1, 2, 3, 4 },
   Bank = { -1, 5, 6, 7, 8, 9, 10, 11 },
}

function WhoHasMod.Print(msg)
   if DEFAULT_CHAT_FRAME then
      DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99WhoHas [MOD]|r " .. msg);
   end
end

function WhoHasMod.OnLoad()
   SlashCmdList["WHOHASMOD"] = WhoHasMod.SlashCommand;
   SLASH_WHOHASMOD1 = "/whohasmod";
   SLASH_WHOHASMOD2 = "/whm";

   this:RegisterEvent("VARIABLES_LOADED");
   this:RegisterEvent("PLAYER_LOGIN");
   this:RegisterEvent("BAG_UPDATE");
   this:RegisterEvent("UNIT_INVENTORY_CHANGED");
   this:RegisterEvent("PLAYERBANKSLOTS_CHANGED");
   this:RegisterEvent("BANKFRAME_OPENED");

   WhoHasMod.Orig_SetItemRef = SetItemRef;
   SetItemRef = WhoHasMod.SetItemRef;

   if (Possessions_ItemButton_OnEnter) then
      WhoHasMod_Orig_Possessions_ItemButton_OnEnter = Possessions_ItemButton_OnEnter;
      Possessions_ItemButton_OnEnter = WhoHasMod.Possessions_ItemButton_OnEnter;
   end
end

function WhoHasMod.OnEvent()
   if (event == "VARIABLES_LOADED") then
      WhoHasMod.state.loaded = 1;
   elseif (event == "PLAYER_LOGIN") then
      WhoHasMod.state.player = UnitName("player") or "";
      WhoHasMod.state.realm = GetRealmName() or "";
      WhoHasMod.state.inventoryChanged = 1;
      WhoHasMod.MaybeWarnMissingBackend();
   elseif (event == "UNIT_INVENTORY_CHANGED") then
      if (arg1 == "player") then
         WhoHasMod.MarkDirty();
      end
   else
      WhoHasMod.MarkDirty();
   end
end

function WhoHasMod.MarkDirty()
   WhoHasMod.state.inventoryChanged = 1;
end

function WhoHasMod.HasUsableBackend()
   if (not PossessionsData or not WhoHasMod.state.realm or WhoHasMod.state.realm == "") then
      return nil;
   end

   local realmData = PossessionsData[WhoHasMod.state.realm];
   if (type(realmData) ~= "table" or not next(realmData)) then
      return nil;
   end

   return 1;
end

function WhoHasMod.MaybeWarnMissingBackend()
   if (WhoHasMod.state.warnedMissingBackend) then
      return;
   end

   if (not WhoHasMod.HasUsableBackend()) then
      WhoHasMod.state.warnedMissingBackend = 1;
      WhoHasMod.Print("requires Possessions to show item ownership. Install/enable Possessions and log into your characters to build data.");
   end
end

function WhoHasMod.SlashCommand(msg)
   msg = string.lower(msg or "");
   if (msg == "on") then
      WhoHasModConfig.enabled = 1;
      WhoHasMod.Print("enabled");
   elseif (msg == "off") then
      WhoHasModConfig.enabled = nil;
      WhoHasMod.Print("disabled");
   elseif (msg == "totals") then
      WhoHasModConfig.totals = not WhoHasModConfig.totals;
      WhoHasMod.Print("show totals: " .. WhoHasMod.BoolText(WhoHasModConfig.totals));
   elseif (msg == "stacks") then
      WhoHasModConfig.stacks = not WhoHasModConfig.stacks;
      WhoHasMod.Print("show stack size: " .. WhoHasMod.BoolText(WhoHasModConfig.stacks));
   else
      local enabled = WhoHasMod.BoolText(WhoHasModConfig.enabled);
      WhoHasMod.Print("status enabled=" .. enabled .. ", totals=" .. WhoHasMod.BoolText(WhoHasModConfig.totals) .. ", stacks=" .. WhoHasMod.BoolText(WhoHasModConfig.stacks));
      WhoHasMod.Print("backend possessions=" .. WhoHasMod.BoolText(WhoHasMod.HasUsableBackend()));
      WhoHasMod.Print("commands: /whohasmod on, off, totals, stacks");
   end
end

function WhoHasMod.BoolText(value)
   if (value) then
      return "on";
   end
   return "off";
end

function WhoHasMod.OnShow()
   WhoHasMod.ShowTooltip(GameTooltip);
end

function WhoHasMod.SetItemRef(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11)
   WhoHasMod.Orig_SetItemRef(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11);
   WhoHasMod.ShowTooltip(ItemRefTooltip);
end

function WhoHasMod.Possessions_ItemButton_OnEnter()
   WhoHasMod.skip = 1;
   WhoHasMod_Orig_Possessions_ItemButton_OnEnter();
   WhoHasMod.skip = nil;
end

function WhoHasMod.ShowTooltip(tooltip)
   if (not tooltip or not WhoHasModConfig.enabled or WhoHasMod.skip) then
      return;
   end

   local name = WhoHasMod.GetTooltipItemName(tooltip);
   if (not name or name == "") then
      return;
   end

   if (WhoHasMod.state.inventoryChanged) then
      WhoHasMod.ScanPlayerPoss();
      WhoHasMod.state.inventoryChanged = nil;
   end

   local lines = {};
   WhoHasMod.GetText(name, lines);

   if (getn(lines) > 0) then
      tooltip:AddLine(" ");
      for _, line in ipairs(lines) do
         tooltip:AddLine(line);
      end
      tooltip:Show();
   end
end

function WhoHasMod.GetTooltipItemName(tooltip)
   local tooltipName = tooltip:GetName();
   if (not tooltipName) then
      return nil;
   end

   local leftText = getglobal(tooltipName .. "TextLeft1");
   if (leftText) then
      return leftText:GetText();
   end

   return nil;
end

function WhoHasMod.GetText(name, text)
   local total = WhoHasMod.ListOwners(name, text);

   if (WhoHasModConfig.totals and total > 0) then
      table.insert(text, string.format(WhoHasMod.formats.total, total));
   end

   if (WhoHasModConfig.stacks) then
      local _, _, _, _, _, _, _, stackCount = GetItemInfo(name);
      if (stackCount and stackCount > 1) then
         table.insert(text, string.format(WhoHasMod.formats.stack, stackCount));
      end
   end
end

function WhoHasMod.ListOwners(name, text)
   local total = 0;
   local charData = WhoHasMod.state.playerCache[name];

   if (charData) then
      for _, category in ipairs(WhoHasMod.categories) do
         local count = charData[category];
         if (count and count > 0) then
            table.insert(text, string.format(WhoHasMod.formats[category], count, WhoHasMod.state.player));
            total = total + count;
         end
      end
   end

   for charName, altData in pairs(WhoHasMod.state.altCache) do
      local itemData = altData[name];
      if (itemData) then
         for _, category in ipairs(WhoHasMod.categories) do
            local count = itemData[category];
            if (count and count > 0) then
               table.insert(text, string.format(WhoHasMod.formats[category], count, charName));
               total = total + count;
            end
         end
      end
   end

   return total;
end

function WhoHasMod.ScanPlayerPoss()
   WhoHasMod.state.playerCache = {};
   WhoHasMod.state.altCache = {};

   if (not PossessionsData or not WhoHasMod.state.realm or WhoHasMod.state.realm == "") then
      return;
   end

   local realmData = PossessionsData[WhoHasMod.state.realm];
   if (not realmData) then
      return;
   end

   local playerName = string.lower(WhoHasMod.state.player or "");
   if (playerName == "") then
      return;
   end

   for charKey, charData in pairs(realmData) do
      if (charData and charData.items) then
         local cache;
         if (charKey == playerName) then
            cache = WhoHasMod.state.playerCache;
         else
            local displayName = WhoHasMod.GetDisplayName(charKey);
            WhoHasMod.state.altCache[displayName] = WhoHasMod.state.altCache[displayName] or {};
            cache = WhoHasMod.state.altCache[displayName];
         end

         WhoHasMod.ScanBagsPoss("Inventory", charData.items, WhoHasMod.Poss.Inventory, cache);
         WhoHasMod.ScanBagsPoss("Bank", charData.items, WhoHasMod.Poss.Bank, cache);
      end
   end
end

function WhoHasMod.GetDisplayName(charKey)
   return string.gsub(charKey, "(%a)([%w_']*)", function(head, tail)
      return string.upper(head) .. string.lower(tail);
   end);
end

function WhoHasMod.ScanBagsPoss(category, bags, bagIndex, cache)
   for _, index in pairs(bagIndex) do
      local bag = bags[index];
      if (bag) then
         for _, item in pairs(bag) do
            if (item and item[1]) then
               local name = item[1];
               local count = item[3] or 1;

               if (not cache[name]) then
                  cache[name] = {};
               end

               local current = cache[name][category] or 0;
               cache[name][category] = current + count;
            end
         end
      end
   end
end
