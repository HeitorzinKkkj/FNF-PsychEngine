function onCreate()

	makeLuaSprite('theSky','sky',-70,0)
	addLuaSprite('theSky',false)
	setLuaSpriteScrollFactor('theSky',0.2,0.2)

	makeLuaSprite('theBack','back',-250,250)
	addLuaSprite('theBack',false)
	setLuaSpriteScrollFactor('theBack',0.3,0.3)

	makeLuaSprite('theTrees','trees',-400,-200)
	addLuaSprite('theTrees',false)
	setLuaSpriteScrollFactor('theTrees',0.5,0.5)

	makeLuaSprite('theGround','ground',-410,550)
	addLuaSprite('theGround',false)
	setLuaSpriteScrollFactor('theGround',0.8,0.8)
end