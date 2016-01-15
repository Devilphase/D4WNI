https://raw.githubusercontent.com/Devilphase/D4WNI/56bbc580b5be5926379462933c4a4e8baad8b2fa/Fiddlesticks.lua
if GetObjectName(GetMyHero()) ~= "Fiddlesticks" then return end

require('Inspired')
require('DeftLib')
require('DamageLib')


local FiddlesticksMenu = MenuConfig("Fiddlesticks", "Fiddlesticks")
FiddlesticksMenu:Menu("Combo", "Combo")
FiddlesticksMenu.Combo:Boolean("Q", "Use Q", true)
FiddlesticksMenu.Combo:Slider("QMana", "Q if Mana % >", 30, 0, 80, 1)
FiddlesticksMenu.Combo:Boolean("W", "Use W", true)
FiddlesticksMenu.Combo:Boolean("R", "Use R", true)
FiddlesticksMenu.Combo:Slider("Rmin", "Minimum Enemies in Range", 2, 1, 5, 1)
FiddlesticksMenu.Combo:Slider("RMana", "R if Mana % >", 30, 0, 80, 1)
FiddlesticksMenu.Combo:Boolean("Items", "Use Items", true)
FiddlesticksMenu.Combo:Slider("myHP", "if HP % <", 50, 0, 100, 1)
FiddlesticksMenu.Combo:Slider("targetHP", "if Target HP % >", 20, 0, 100, 1)
FiddlesticksMenu.Combo:Boolean("QSS", "Use QSS", true)
FiddlesticksMenu.Combo:Slider("QSSHP", "if My Health % <", 75, 0, 100, 1)

FiddlesticksMenu:Menu("Harass", "Harass")
FiddlesticksMenu.Harass:Boolean("Q", "Use Q", true)
FiddlesticksMenu.Harass:Boolean("W", "Use W", true)
FiddlesticksMenu.Harass:Slider("Mana", "if Mana % is More than", 30, 0, 80, 1)

FiddlesticksMenu:Menu("Killsteal", "Killsteal")
FiddlesticksMenu.Killsteal:Boolean("Q", "Killsteal with Q", true)

if Ignite ~= nil then
FiddlesticksMenu:Menu("Misc", "Misc")
FiddlesticksMenu.Misc:Boolean("AutoIgnite", "Auto Ignite", true)
end
	
FiddlesticksMenu:Menu("LaneClear", "LaneClear")
FiddlesticksMenu.LaneClear:Boolean("Q", "Use Q", true)
--FiddlesticksMenu.LaneClear:Boolean("W", "Use W", false)
FiddlesticksMenu.LaneClear:Slider("Mana", "if Mana % >", 30, 0, 80, 1)

FiddlesticksMenu:Menu("JungleClear", "JungleClear")
FiddlesticksMenu.JungleClear:Boolean("Q", "Use Q", true)
--FiddlesticksMenu.JungleClear:Boolean("W", "Use W", true)
FiddlesticksMenu.JungleClear:Slider("Mana", "if Mana % >", 30, 0, 80, 1)

FiddlesticksMenu:Menu("Drawings", "Drawings")
FiddlesticksMenu.Drawings:Boolean("Q", "Draw Q Range", true)

OnDraw(function(myHero)
if FiddlesticksMenu.Drawings.Q:Value() then DrawCircle(GetOrigin(myHero),1075,1,25,GoS.Pink) end
end)

IOW:AddCallback(AFTER_ATTACK, function(target, mode)
  if IsReady(_W) then 
    if mode == "Combo" and target ~= nil and FiddlesticksMenu.Combo.W:Value() then
    CastSpell(_W)
    end
    
    if mode == "Combo" and target ~= nil and FiddlesticksMenu.Harass.W:Value() and GetPercentMP(myHero) >= FiddlesticksMenu.Harass.Mana:Value() then
    CastSpell(_W)
    end
  end
end)

local target1 = TargetSelector(1125,TARGET_LESS_CAST_PRIORITY,DAMAGE_PHYSICAL,true,false)

OnTick(function(myHero)
    local target = GetCurrentTarget()
    local QSS = GetItemSlot(myHero,3140) > 0 and GetItemSlot(myHero,3140) or GetItemSlot(myHero,3139) > 0 and GetItemSlot(myHero,3139) or nil
    local BRK = GetItemSlot(myHero,3153) > 0 and GetItemSlot(myHero,3153) or GetItemSlot(myHero,3144) > 0 and GetItemSlot(myHero,3144) or nil
    local YMG = GetItemSlot(myHero,3142) > 0 and GetItemSlot(myHero,3142) or nil
    local Qtarget = target1:GetTarget()
    
    if IOW:Mode() == "Combo" then

	if IsReady(_Q) and FiddlesticksMenu.Combo.Q:Value() and GetPercentMP(myHero) >= FiddlesticksMenu.Combo.QMana:Value() and not IOW.isWindingUp then
        Cast(_Q,target)
        end
		
	if IsReady(_R) and ValidTarget(target, 600) and SivirMenu.Combo.R:Value() and GetPercentMP(myHero) >= FiddlesticksMenu.Combo.RMana:Value() and EnemiesAround(GetOrigin(myHero), 600) >= FiddlesticksMenu.Combo.Rmin:Value() then
	CastSpell(_R)
        end

        if QSS and IsReady(QSS) and FiddlesticksMenu.Combo.QSS:Value() and IsImmobile(myHero) or IsSlowed(myHero) or toQSS and GetPercentHP(myHero) < FiddlesticksMenu.Combo.QSSHP:Value() then
        CastSpell(QSS)
        end

    end

    if IOW:Mode() == "Harass" and GetPercentMP(myHero) >= FiddlesticksMenu.Harass.Mana:Value() then

	if IsReady(_Q) and FiddlesticksMenu.Harass.Q:Value() then
        Cast(_Q,target)
        end

    end
 
    for i,enemy in pairs(GetEnemyHeroes()) do
	
      if IOW:Mode() == "Combo" then	
	if BRK and IsReady(BRK) and  FiddlesticksMenu.Combo.Items:Value() and ValidTarget(enemy, 550) and GetPercentHP(myHero) <  FiddlesticksMenu.Combo.myHP:Value() and GetPercentHP(enemy) >  FiddlesticksMenu.Combo.targetHP:Value() then
        CastTargetSpell(enemy, BRK)
        end

        if YMG and IsReady(YMG) and  FiddlesticksMenu.Combo.Items:Value() and ValidTarget(enemy, 600) then
        CastSpell(YMG)
        end	
      end
        
      if Ignite and  FiddlesticksMenu.Misc.AutoIgnite:Value() then
        if IsReady(Ignite) and 20*GetLevel(myHero)+50 > GetHP(enemy)+GetHPRegen(enemy)*3 and ValidTarget(enemy, 600) then
        CastTargetSpell(enemy, Ignite)
        end
      end
	
      if IsReady(_Q) and ValidTarget(enemy, 1125) and  FiddlesticksMenu.Killsteal.Q:Value() and GetHP(enemy) < getdmg("Q",enemy) then 
      Cast(_Q,enemy)
      end
		
    end

    if IOW:Mode() == "LaneClear" then
 
      if GetPercentMP(myHero) >=  FiddlesticksMenu.LaneClear.Mana:Value() then
        if IsReady(_Q) and  FiddlesticksMenu.LaneClear.Q:Value() then
          local BestPos, BestHit = GetLineFarmPosition(1075, 85, MINION_ENEMY)
          if BestPos and BestHit > 2 then 
          CastSkillShot(_Q, BestPos)
          end
	end
      end

    end
         
    for i,mobs in pairs(minionManager.objects) do
      if IOW:Mode() == "LaneClear" and GetTeam(mobs) == 300 and GetPercentMP(myHero) >=  FiddlesticksMenu.JungleClear.Mana:Value() then
        if IsReady(_Q) and  FiddlesticksMenu.JungleClear.Q:Value() and ValidTarget(mobs, 1075) then
        CastSkillShot(_Q,GetOrigin(mobs))
	end
      end
    end

end)

PrintChat(string.format("<font color='#1244EA'> Fiddlesticks:</font> <font color='#FFFFFF'> By Dawn Loaded, Have A Good Game ! </font>"))
PrintChat("Have Fun Using D4WN Scripts: " ..GetObjectBaseName(myHero)) 
