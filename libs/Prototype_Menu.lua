Prototype_Menu =
{
   OnLoad = nil,
}

function Prototype_Menu:NewContextMenu(name, o)
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   o.menu = L_Create_UIDropDownMenu(name, UIParent)
   o.menu.isOpen = false

   L_UIDropDownMenu_Initialize(o.menu, o.OnLoad, "MENU", 1)

   return o
end

function Prototype_Menu:NewDropDownMenu(name, parent, o)
   o = o or {}
   setmetatable(o, self)
   self.__index = self
   o.menu = L_Create_UIDropDownMenu(name, parent)
   o.menu.isOpen = false

   L_UIDropDownMenu_Initialize(o.menu, o.OnLoad)

   return o
end

function Prototype_Menu:AddOption(text, level, func)
   info = {}
   info.text = text
   info.notCheckable = 1
   info.func = func
   L_UIDropDownMenu_AddButton(info, level)
end

function Prototype_Menu:AddDescriptor(text, level, isTitle)
   info = {}
   info.text = text
   if isTitle then
      info.isTitle = true
   else
      info.notClickable = 1
   end
   info.notCheckable = 1
   L_UIDropDownMenu_AddButton(info, level)
end

function Prototype_Menu:AddRadioOption(text, checkFunc, level, func)
   info = {}
   info.text = text
   info.checked = checkFunc
   info.func = func
   info.keepShownOnClick = true
   L_UIDropDownMenu_AddButton(info, level)
end

function Prototype_Menu:AddCheckOption(text, checkFunc, level, func)
   info = {}
   info.text = text
   info.checked = checkFunc
   info.func = func
   info.keepShownOnClick = true
   info.isNotRadio = true
   L_UIDropDownMenu_AddButton(info, level)
end

function Prototype_Menu:AddMenu(text, level, menuList)
   info = {}
   info.text = text
   info.menuList = menuList
   info.hasArrow = true
   info.notCheckable = 1

   L_UIDropDownMenu_AddButton(info, level)
end

function Prototype_Menu:ToggleMenu(anchor)
   self.menu.isOpen = not self.menu.isOpen

   local sw = GetScreenWidth()
   local sh = GetScreenHeight()
   local ax = anchor:GetLeft()
   local ay = anchor:GetBottom()

   if ax < (sw / 2) then
      if ay < (sh / 2) then
         self.menu.point = "BOTTOMLEFT"
         self.menu.relativePoint = "TOPLEFT"
      else
         self.menu.point = "TOPLEFT"
         self.menu.relativePoint = "BOTTOMLEFT"
      end
   else
      if ay < (sh / 2) then
         self.menu.point = "BOTTOMRIGHT"
         self.menu.relativePoint = "TOPRIGHT"
      else
         self.menu.point = "TOPRIGHT"
         self.menu.relativePoint = "BOTTOMRIGHT"
      end
   end

   L_ToggleDropDownMenu(1, nil, self.menu, anchor, 0, 0)
end

function Prototype_Menu:OpenMenu(anchor)
   if self:IsMenuOpen() then
      return
   end

   self:ToggleMenu(anchor)
end

function Prototype_Menu:CloseMenu()
   --if not self:IsMenuOpen() then
      --return
   --end
   --self:ToggleMenu()
   self.menu.isOpen = false
   L_CloseDropDownMenus()
end

function Prototype_Menu:Refresh()
   L_UIDropDownMenu_RefreshAll(self.menu, nil)
end

function Prototype_Menu:IsMenuOpen()
   return self.menu.isOpen
end

function Prototype_Menu:SetWidth(w)
   L_UIDropDownMenu_SetWidth(self.menu, w)
end

function Prototype_Menu:SetText(text)
   L_UIDropDownMenu_SetText(self.menu, text)
end

function Prototype_Menu:SetPoint(point, relativeFrame, relativePoint, ofsx, ofsy)
   if ofsx and ofsy then
      self.menu:SetPoint(point, relativeFrame, relativePoint, ofsx, ofsy)
   elseif relativePoint then
      self.menu:SetPoint(point, relativeFrame, relativePoint)
   else
      self.menu:SetPoint(point)
   end
end
------------------------------------------------------------------------------------------------------
-- Hooks
------------------------------------------------------------------------------------------------------
-- This is needed to update my counter when a dropdown hides.  Without this, MenuOpen becomes outdated
-- when a menu times out and auto-hides.
local onHide = L_UIDropDownMenu_OnHide
function L_UIDropDownMenu_OnHide(self)
   if self:GetID() == 1 and self.dropdown.isOpen == true then
      self.dropdown.isOpen = false
   end
   onHide(self)
end
