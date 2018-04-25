-----------------------------------------------------------------------------------------
--
-- Unit5.1
--這章會將整個結構幾乎大改,我們先將需要的函式庫以及自字型檔之類的直接放到最前端
-----------------------------------------------------------------------------------------

--呼叫composer函式庫

local composer = require( "composer" )
local BFont = require("BitmapFont")
local menuFont = BFont.new("Menu.png")
--創建新場景
local scene = composer.newScene()
 local menu=display.newGroup()
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
-- 然後將一些公共參數先打出來
-- -----------------------------------------------------------------------------------
--設定Ｘ中心點
local centerX = display.contentCenterX
--設定Ｙ中心點
local centerY = display.contentCenterY
--建立background群組
local backgroundGroup = display.newGroup()
--建立layer群組
local layerGroup = display.newGroup()
--定義計時器
local tPrevious = system.getTimer()
local slimeGroup = display.newGroup()
--新增重力
local physics = require ("physics")
physics.start()
---------

---------
--玩家
	local playerSheetOptions =
    {   
        width = 56,
        height =50,
        numFrames = 16, --張數
        sheetContentWidth = 224,  
        sheetContentHeight = 200 ,
    }
	local playerPosition =
	{
		x=centerX*0.4,y=centerY*1.6
	}
    local playerSheet = graphics.newImageSheet( "texture/Player_Sheet.png", playerSheetOptions )
    local player = display.newSprite( playerSheet, {
	{ name="playerMove", start = 10, count = 3, time = 500 },
	{ name="playerAttack", start = 1, count = 3, time = 500 }})
	--史萊姆
    local slimeSheepOptions =
    {   
        width = 50,
        height =44,
        numFrames = 6, --張數
        sheetContentWidth = 300,  
        sheetContentHeight = 44,
		life = 2
    }
	local slimePosition =
	{
		x=centerX*2,y=centerY*1.6
	}
    local slimeSheet = graphics.newImageSheet( "texture/Slime_Move.png", slimeSheepOptions )
    local slime = display.newSprite( slimeSheet, { name="slime", start=1, count=6, time=800 } )
	--重力區---------------------------------
	physics.addBody(player,"dynamic",{density=0.1,bounce=0.1,friction=0.2,raddius=12})
	physics.addBody(slime,"dynamic_2",{density=0.1,bounce=0.1,friction=0.2,raddius=0})

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
-- create()
-- -----------------------------------------------------------------------------------
-- 這里以下才是場景開始時要出現的畫面
-- -----------------------------------------------------------------------------------
local bg = display.newImageRect( "texture/NewMap-01.png", 480, 320 )
    local bg1 = display.newImageRect( "texture/NewMap-01.png", 480, 320 )
       bg.anchorX = 0
       bg.x = 0
       bg.y = centerY
       bg.speed = 1 --新增速度
       bg1.anchorX = 0
       bg1.x = 480
       bg1.y=centerY
       bg1.speed = 1 --新增速度
       backgroundGroup:insert(display.newGroup(bg,bg1))
function scene:create( event )
 
    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
    
       sceneGroup:insert(backgroundGroup)
    local layer1 = display.newImageRect( "spaceLayer1.png", 480, 320 )
    local layer2 = display.newImageRect( "spaceLayer2.png", 480, 320 )
       layer1.anchorX = 0
       layer1.x = 0
       layer1.y = centerY
       layer1.speed = 1.5
       layer2.anchorX = 0
       layer2.x = 480
       layer2.y=centerY
       layer2.speed = 10
       layerGroup:insert(display.newGroup(layer1,layer2))
       sceneGroup:insert(layerGroup)  
	       --標題Ｘ位置,Ｙ位置,內容
	sceneGroup:insert(player)

    
	slimeGroup:insert(display.newGroup(slime))
    slime:play ( )
    sceneGroup:insert(slimeGroup)
    --Score
	
    --Menu
    local menuPlay= menuFont:newBitmapString(centerX*0.7,centerY*0.2, "Menu" )
    menuPlay.name="menu"

    menu:insert(menuPlay)--menu群組加入menuExit
    sceneGroup:insert(menu)
end 


--這個end是scene:create的
-- -----------------------------------------------------------------------------------
-- 然後將移動function寫在場景以外的部分
-- -----------------------------------------------------------------------------------
--設置移動功能


local function move(event)
	
    local tDelta = event.time - tPrevious
    tPrevious = event.time
	if slimeSheepOptions.life>0 then
	slime.x=slimePosition.x
	slime.y=slimePosition.y
	end
	
    player.x=playerPosition.x
    player.y=playerPosition.y
	player:play ( )
	local i
	--背景的移動功能,並檢測背景是否完全超出左側螢幕,如果是擇立即移動到畫面右側螢幕

    slimePosition.x = slimePosition.x - 0.15*tDelta
       
        if (slimePosition.x ) < 0 then
			slimePosition.x = centerX*2
        end

    for i = 1, backgroundGroup.numChildren do
	    
        backgroundGroup[i][1].x = backgroundGroup[i][1].x - backgroundGroup[i][1].speed / 10*tDelta
        backgroundGroup[i][2].x = backgroundGroup[i][2].x - backgroundGroup[i][2].speed / 10*tDelta
        if (backgroundGroup[i][1].x +backgroundGroup[i][1].contentWidth) < 0 then
            backgroundGroup[i][1]:translate( 480 * 2, 0)
        end
         if (backgroundGroup[i][2].x +backgroundGroup[i][2].contentWidth) < 0 then
            backgroundGroup[i][2]:translate( 480 * 2, 0)
        end     
    end
    for i = 1, layerGroup.numChildren do
        layerGroup[i][1].x =layerGroup[i][1].x-layerGroup[i][1].speed /10*tDelta
        layerGroup[i][2].x =layerGroup[i][2].x-layerGroup[i][2].speed /10*tDelta
        if (layerGroup[i][1].x +layerGroup[i][1].contentWidth) < 0 then
            layerGroup[i][1]:translate( 480 * 2, 0)

        end
        if (layerGroup[i][2].x +layerGroup[i][2].contentWidth) < 0 then
            layerGroup[i][2]:translate( 480 * 2, 0)

        end
    end
 end
 --換場景的功能
 local function changeScene()
  print("changeScene")
   composer.gotoScene("game_menu",{effect ="fade",time=400}) --變換場景至game
end

--觸碰事件
local function menuTouch(event)
  if event.phase=="began" then
    print("touch_"..event.target.name)
    if event.target.name == "menu" then
      --追加下列這行會在點擊play後,將play移走然後呼叫換場景的功能
      transition.to(menu,  {time = 400, x = 480+event.target.contentWidth/2,onComplete = changeScene})
      print("play pressed")
    else
      os.exit ( )
    end
    for i = 1, menu.numChildren do
          --新增這條以避免重複點擊
          menu[i]:removeEventListener("touch",menuTouch)
        end
  end
end

--將menu群組中的兩個圖(menuPlay,menuExit)加上touch監聽事件
local function addTouch( )

  for i = 1, menu.numChildren do
          menu[i]:addEventListener("touch",menuTouch)
    end
end


-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)
        Runtime:addEventListener( "enterFrame", move )
		transition.to(title,  {time = 400, y = centerY*0.6})
        --將menu群組的x座標移往centerX,移動完成呼叫addTouch函式
        transition.to(menu,  {time = 400, x = centerX,onComplete = addTouch})
    elseif ( phase == "did" ) then

        -- Code here runs when the scene is entirely on screen
        --記得移除上個場景
         composer.removeScene("menu")
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
      
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
    print("destroy_menu")
end

local function cantAttack()
		player:setSequence( "playerMove" )
		bg.speed=1
		bg1.speed=1
end
function slimeSpawn()
	
	slimePosition.x = centerX*2
	slimeSheepOptions.life=2
end
function onMouseEvent( event )
    if event.isPrimaryButtonDown then
	
		player:setSequence( "playerAttack" )
		bg.speed=0.1
		bg1.speed=0.1
		timer.performWithDelay( 500,cantAttack)
		 else
		
        -- The mouse's secondary/right button is not being pressed.
		 end
end

local function onKeyEvent( event )
 
    -- Print which key was pressed down/up
    local message = "Key '" .. event.keyName .. "' was pressed " .. event.phase
    print( message )
 
    -- If the "back" key was pressed on Android, prevent it from backing out of the app
    if ( event.keyName == "a" ) then
		if(playerPosition.x>=40) then
		playerPosition.x=playerPosition.x-10
		end
	end
	if ( event.keyName == "d" ) then
		if(playerPosition.x<=400) then
		playerPosition.x=playerPosition.x+10
		end
    end
    return false
end
local function  onCollision(event)
	if event.phase == "began" then
		if player.sequence == "playerAttack" then
		    slimePosition.x=slimePosition.x+100
			slimeSheepOptions.life=slimeSheepOptions.life-1
			if slimeSheepOptions.life<=0 then
			timer.performWithDelay( 500,slimeSpawn)
			end
	end
end



	




end
Runtime:addEventListener( "collision",onCollision )
Runtime:addEventListener( "key", onKeyEvent )
Runtime:addEventListener( "mouse", onMouseEvent )
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene