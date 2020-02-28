local DGS = exports.dgs
local tDGS = {
	window = {},
	tab = {},
	button = {},
	edit = {},
	gridList = {},
	label = {}
}

local tInfoUserForDelete = {}

local classForUser = {}
function classForUser:new( _Name, _Surname, _Adress )
    local obj = { ["userName"] = _Name, ["userSurName"] = _Surname, ["userAdress"] = _Adress }
    return obj
end

local function initi()
	tDGS.window[1] = DGS:dgsCreateWindow ( 332, 126, 834, 515, "Окно управления данными", false, 0xFFFFFFFF )

	DGS:dgsWindowSetSizable( tDGS.window[1], false )
	DGS:dgsWindowSetMovable( tDGS.window[1], false )
	
	tDGS.tabPanel = DGS:dgsCreateTabPanel( 0, 0, 1, 1, true, tDGS.window[1])
	tDGS.tab[1] = DGS:dgsCreateTab( "Добавление", tDGS.tabPanel )
	tDGS.edit[1] = DGS:dgsCreateEdit( 0.01, 0.16, 0.2, 0.05, "Имя", true, tDGS.tab[1] )
	DGS:dgsCreateLabel( 0.31, 0.16, 0.2, 0.05, "Имя", true, tDGS.tab[1] )
	tDGS.edit[2] = DGS:dgsCreateEdit( 0.01, 0.36, 0.2, 0.05, "Фамилия", true, tDGS.tab[1] )
	DGS:dgsCreateLabel( 0.31, 0.36, 0.2, 0.05, "Фамилия", true, tDGS.tab[1] )
	tDGS.edit[3] = DGS:dgsCreateEdit( 0.01, 0.56, 0.2, 0.05, "Адрес", true, tDGS.tab[1] )
	
	DGS:dgsCreateLabel( 0.31, 0.56, 0.2, 0.05, "Адрес проживания", true, tDGS.tab[1] )
	tDGS.button[1] = DGS:dgsCreateButton( 0.7, 0.9, 0.2, 0.07, "Подтвердить", true, tDGS.tab[1] )
	
	addEventHandler ( "onDgsMouseClickDown", tDGS.button[1], function() -- добавление пользователя
		local tParTable = classForUser:new( DGS:dgsGetText( tDGS.edit[1] ), DGS:dgsGetText( tDGS.edit[2] ), DGS:dgsGetText( tDGS.edit[3] ) )
	
		for _, stringPar in pairs( tParTable ) do
			if stringPar:len() < 4 then
				outputChatBox( "Неверный ввод!" )
				return
			end
		end
		triggerServerEvent ( "testingJSON:onAddingUserToBD", resourceRoot, tParTable )
	end, false )
	
	tDGS.tab[2] = DGS:dgsCreateTab( "Список и изменение", tDGS.tabPanel )
	tDGS.gridList[1] = DGS:dgsCreateGridList( 0, 0, 1, 0.75, true, tDGS.tab[2] )
	DGS:dgsGridListAddColumn( tDGS.gridList[1], "Имя", 0.33 )
	DGS:dgsGridListAddColumn( tDGS.gridList[1], "Фамилия", 0.33 )
	DGS:dgsGridListAddColumn( tDGS.gridList[1], "Адрес", 0.33 )
	
	tDGS.edit[4] = DGS:dgsCreateEdit( 0.01, 0.77, 0.2, 0.05, "NewName", true, tDGS.tab[2] )
	DGS:dgsCreateLabel( 0.31, 0.77, 0.2, 0.05, "Новое Имя", true, tDGS.tab[2] )
	tDGS.edit[5] = DGS:dgsCreateEdit( 0.01, 0.85, 0.2, 0.05, "NewSurName", true, tDGS.tab[2] )
	DGS:dgsCreateLabel( 0.31, 0.85, 0.2, 0.05, "Новая Фамилия", true, tDGS.tab[2] )
	tDGS.edit[6] = DGS:dgsCreateEdit( 0.01, 0.94, 0.2, 0.05, "NewAdress", true, tDGS.tab[2] )
	DGS:dgsCreateLabel( 0.31, 0.94, 0.2, 0.05, "Новый Адрес", true, tDGS.tab[2] )
	tDGS.button[2] = DGS:dgsCreateButton( 0.7, 0.81, 0.2, 0.06, "Изменить", true, tDGS.tab[2] )
	DGS:dgsSetEnabled( tDGS.button[2], false )
	tDGS.button[3] = DGS:dgsCreateButton( 0.7, 0.91, 0.2, 0.06, "Удалить", true, tDGS.tab[2] )
	DGS:dgsSetEnabled( tDGS.button[3], false )
	
	tDGS.window[2] = DGS:dgsCreateWindow ( 0.15, 0.33, 0.7, 0.34, "Окно выбора", true, 0xFFFFFFFF, 25, nil, 0xC8141414, nil,  0x96141414, 5, true ) -- окно для подтверждения удаления
	DGS:dgsCreateLabel( 0.1, 0.1, 0.2, 0.2, 'Действительно удалить?', true, tDGS.window[2] )
	tDGS.button[4] = DGS:dgsCreateButton( 0.1, 0.7, 0.2, 0.2, "Да", true, tDGS.window[2] )
	tDGS.button[5] = DGS:dgsCreateButton( 0.7, 0.7, 0.2, 0.2, "Нет", true, tDGS.window[2] )
	DGS:dgsSetParent( tDGS.window[2], tDGS.tab[2] )
	DGS:dgsWindowSetSizable( tDGS.window[2], false )
	DGS:dgsWindowSetMovable( tDGS.window[2], false )

	addEventHandler ( "onDgsMouseClickDown", tDGS.button[5], function()
		DGS:dgsSetVisible( tDGS.window[2], false )
	end, false )

	addEventHandler ( "onDgsMouseClickDown", tDGS.button[4], function()
		DGS:dgsSetVisible( tDGS.window[2], false )
		triggerServerEvent ( "testingJSON:onDeleteUserInfo", resourceRoot, tInfoUserForDelete )
	end, false )

	for i = 1, 6 do
		DGS:dgsEditSetMaxLength( tDGS.edit[i], 40 )
	end
	
	tDGS.label[1] = DGS:dgsCreateLabel( 0.5, 0.84, 0.15, 0.07, "Меняем строку: нет", true, tDGS.tab[2] ) -- для изменения параметров
	addEventHandler( "onDgsGridListSelect", tDGS.gridList[1], function ( currentItem ) -- изменяем включенность кнопок и состояния label
		DGS:dgsBringToFront( tDGS.window[2], false )
		local labelText = "Меняем строку: "
		local boolShowButton

		if currentItem ~= -1 then
			labelText = labelText .. tostring( currentItem )
			boolShowButton = true
		else
			labelText = labelText .. "нет"
			boolShowButton = false
		end
	
		DGS:dgsSetText( tDGS.label[1], labelText )
		DGS:dgsSetEnabled( tDGS.button[2], boolShowButton )
		DGS:dgsSetEnabled( tDGS.button[3], boolShowButton )
	end, false )
	
	addEventHandler ( "onDgsMouseClickDown", tDGS.button[2], function() -- кнопка для изменения параметров
		local row = DGS:dgsGridListGetSelectedItem( tDGS.gridList[1] )
		local tPrevInfoUser = classForUser:new( DGS:dgsGridListGetItemText( tDGS.gridList[1], row, 1 ), DGS:dgsGridListGetItemText( tDGS.gridList[1], row, 2 ), DGS:dgsGridListGetItemText( tDGS.gridList[1], row, 3 ) )
		local tNewInfoUser = classForUser:new( DGS:dgsGetText( tDGS.edit[4] ), DGS:dgsGetText( tDGS.edit[5] ), DGS:dgsGetText( tDGS.edit[6] ) )
		local checkingCounter = true
		for key, value in pairs( tNewInfoUser ) do
			if value:len() < 4 then
				outputChatBox( "Неверный ввод!" )
				return
			end
	
			if value ~= tPrevInfoUser[key] then
				checkingCounter = false
			end
		end
	
		if checkingCounter then
			outputChatBox( "Хотя бы какие-то значения должны различаться!" )
			return
		end
	
		triggerServerEvent ( "testingJSON:onChangeUserInfo", resourceRoot, tPrevInfoUser, tNewInfoUser )
	end, false )
	
	addEventHandler ( "onDgsMouseClickDown", tDGS.button[3], function() -- кнопка для удаления
		if DGS:dgsGetVisible( tDGS.window[2] ) then
			return
		end
	
		local row = DGS:dgsGridListGetSelectedItem( tDGS.gridList[1] )
		tInfoUserForDelete = classForUser:new( DGS:dgsGridListGetItemText( tDGS.gridList[1], row, 1 ), DGS:dgsGridListGetItemText( tDGS.gridList[1], row, 2 ), DGS:dgsGridListGetItemText( tDGS.gridList[1], row, 3 ) )

		DGS:dgsSetVisible( tDGS.window[2], true )
		DGS:dgsBringToFront( tDGS.window[2], false )
		--triggerServerEvent ( "testingJSON:onDeleteUserInfo", resourceRoot, tInfoUser )
	end, false )
	
	DGS:dgsSetVisible( tDGS.window[1], false )
	addEventHandler( "onDgsWindowClose", tDGS.window[1], function()
		cancelEvent()
		DGS:dgsSetVisible( tDGS.window[1], false )
		showCursor( false )
		triggerServerEvent( "testingJSON:onCloseWindowDGS", resourceRoot )
	end )
end 
addEventHandler( "onClientResourceStart", resourceRoot, initi )


addEvent( "testingJSON:OnChangeWindowVisible", true )
addEventHandler( "testingJSON:OnChangeWindowVisible", resourceRoot, function( boolParametr, tInfoUsers )
	DGS:dgsSetInputMode( "no_binds_when_editing" )
	DGS:dgsSetVisible( tDGS.window[2], false )
	DGS:dgsSetVisible( tDGS.window[1], boolParametr )
	DGS:dgsGridListClear( tDGS.gridList[1] )
	showCursor( boolParametr )

	local row
	local tFromJSON = {}

	if boolParametr then
		for i = 1, #tInfoUsers do
			row = DGS:dgsGridListAddRow( tDGS.gridList[1] )
			tFromJSON = fromJSON( tInfoUsers[i]["userInfo"] )
			DGS:dgsGridListSetItemText( tDGS.gridList[1], row, 1, tFromJSON["userName"] )
			DGS:dgsGridListSetItemText( tDGS.gridList[1], row, 2, tFromJSON["userSurName"] )
			DGS:dgsGridListSetItemText( tDGS.gridList[1], row, 3, tFromJSON["userAdress"] )
		end
	end
end )

addEvent( "testingJSON:onAddRowDGS", true )
addEventHandler( "testingJSON:onAddRowDGS", resourceRoot, function( tInfoUser )
	local row = DGS:dgsGridListAddRow( tDGS.gridList[1] )
	DGS:dgsGridListSetItemText( tDGS.gridList[1], row, 1, tInfoUser["userName"] )
	DGS:dgsGridListSetItemText( tDGS.gridList[1], row, 2, tInfoUser["userSurName"] )
	DGS:dgsGridListSetItemText( tDGS.gridList[1], row, 3, tInfoUser["userAdress"] )
end )

addEvent( "testingJSON:onUpdDGS", true )
addEventHandler( "testingJSON:onUpdDGS", resourceRoot, function( tPrevInfoUser, tNewInfoUser )
	local rowCount = DGS:dgsGridListGetRowCount( tDGS.gridList[1] )
	local tmpName
	local tmpSurName
	local tmpAdress

	for row = 1, rowCount do
		tmpName = DGS:dgsGridListGetItemText( tDGS.gridList[1], row, 1 )
		tmpSurName = DGS:dgsGridListGetItemText( tDGS.gridList[1], row, 2 )
		tmpAdress = DGS:dgsGridListGetItemText( tDGS.gridList[1], row, 3 )
		if tmpName == tPrevInfoUser["userName"] and tmpSurName == tPrevInfoUser["userSurName"] and tmpAdress == tPrevInfoUser["userAdress"] then
			DGS:dgsGridListRemoveRow( tDGS.gridList[1], row ) -- удаляем в любом случае. Если просто заменяли, потом ее еще раз добавим
			if tNewInfoUser then
				DGS:dgsGridListAddRow( tDGS.gridList[1], rowCount )
				DGS:dgsGridListSetItemText( tDGS.gridList[1], rowCount, 1, tNewInfoUser["userName"] )
				DGS:dgsGridListSetItemText( tDGS.gridList[1], rowCount, 2, tNewInfoUser["userSurName"] )
				DGS:dgsGridListSetItemText( tDGS.gridList[1], rowCount, 3, tNewInfoUser["userAdress"] )
			end

			DGS:dgsGridListSetSelectedItem( tDGS.gridList[1], -1 )
			return
		end
	end
end )









local parMaxX, parMaxY = guiGetScreenSize()

local tBoundaryParametrs = {
	left = {},
	right = {}
}
tBoundaryParametrs.left.currentX = math.random( 0, parMaxX / 2 - 128 )
tBoundaryParametrs.left.currentY = math.random( 0, parMaxY - 128 )
tBoundaryParametrs.left.MaxX = parMaxX / 2 - 128
tBoundaryParametrs.left.MinX = 0
tBoundaryParametrs.left.r = math.random( 0, 255 )
tBoundaryParametrs.left.g = math.random( 0, 255 )
tBoundaryParametrs.left.b = math.random( 0, 255 )
tBoundaryParametrs.left.changeX = 5
tBoundaryParametrs.left.changeY = 5

tBoundaryParametrs.right.currentX = math.random( parMaxX / 2, parMaxX - 128 )
tBoundaryParametrs.right.currentY = math.random( 0, parMaxY - 128 )
tBoundaryParametrs.right.MaxX = parMaxX - 128
tBoundaryParametrs.right.MinX = parMaxX / 2
tBoundaryParametrs.right.r = math.random( 0, 255 )
tBoundaryParametrs.right.g = math.random( 0, 255 )
tBoundaryParametrs.right.b = math.random( 0, 255 )
tBoundaryParametrs.right.changeX = 5
tBoundaryParametrs.right.changeY = 5

local timerVar

addEventHandler( 'onClientRender', root, function()
	if not timerVar then
		return
	end

	--dxDrawImageSection(400, 200, 64, 64, 0, 0, 64, 64, 'mts.png') -- Draw a certain section
	dxDrawLine( parMaxX / 2, parMaxX, parMaxX / 2, 0, tocolor( 255, 255, 255, 255 ) )
	dxDrawImage( tBoundaryParametrs.right.currentX, tBoundaryParametrs.right.currentY, 128, 128, 'logo.png', 0, 0, 0, tocolor( tBoundaryParametrs.right.r, tBoundaryParametrs.right.g, tBoundaryParametrs.right.b, 255 ) )
	dxDrawImage( tBoundaryParametrs.left.currentX, tBoundaryParametrs.left.currentY, 128, 128, 'logo.png', 0, 0, 0, tocolor( tBoundaryParametrs.left.r, tBoundaryParametrs.left.g, tBoundaryParametrs.left.b, 255 ) )
end )

local function changeColor( parOrientation )
	tBoundaryParametrs[parOrientation].r = math.random( 0, 255 )
	tBoundaryParametrs[parOrientation].g = math.random( 0, 255 )
	tBoundaryParametrs[parOrientation].b = math.random( 0, 255 )
end

local function changeCoordinates( parOrientation )
	if tBoundaryParametrs[parOrientation].currentX >= tBoundaryParametrs[parOrientation].MaxX then
		tBoundaryParametrs[parOrientation].changeX = -5
		changeColor( parOrientation )
	end
	
	if tBoundaryParametrs[parOrientation].currentY >= parMaxY - 128 then
		tBoundaryParametrs[parOrientation].changeY = -5
		changeColor( parOrientation )
	end
	
	if tBoundaryParametrs[parOrientation].currentX <= tBoundaryParametrs[parOrientation].MinX then
		tBoundaryParametrs[parOrientation].changeX = 5
		changeColor( parOrientation )
	end
	
	if tBoundaryParametrs[parOrientation].currentY <= 0 then
		tBoundaryParametrs[parOrientation].changeY = 5
		changeColor( parOrientation )
	end

	tBoundaryParametrs[parOrientation].currentX = tBoundaryParametrs[parOrientation].currentX + tBoundaryParametrs[parOrientation].changeX
	tBoundaryParametrs[parOrientation].currentY = tBoundaryParametrs[parOrientation].currentY + tBoundaryParametrs[parOrientation].changeY
end

addCommandHandler( "changeMotion", function()
	if timerVar then
		killTimer( timerVar )
		timerVar = nil
		return
	end

	timerVar = setTimer( function()
		changeCoordinates( "left" )

		changeCoordinates( "right" )
	end, 5, 0 )
end )

addEvent( "testingJSON:OnDestroyDXMotion", true )
addEventHandler( "testingJSON:OnDestroyDXMotion", resourceRoot, function()
	if timerVar then
		killTimer( timerVar )
		timerVar = nil
	end
end )

