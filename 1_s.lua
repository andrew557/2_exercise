local db_connection = dbConnect( "mysql", "dbname=testBD;host=127.0.0.1;charset=utf8", "testBD", "password" ) -- вместо параметров должны стоять конкретные данные
--local db_connection = dbConnect( "sqlite", "fileData1.db" )
local tDGSOpen = {}

addEventHandler( "onResourceStart", resourceRoot, function()
	--dbExec( db_connection, "DROP table everyData" )
	dbExec( db_connection, "CREATE TABLE IF NOT EXISTS everyData( userInfo TEXT ) " )
end )

local function checkingTheSameRow( jsonUserInfo )
	local query = "SELECT userInfo FROM everyData WHERE userInfo = ?"
	local quentityQuery = #dbPoll( dbQuery( db_connection, query, jsonUserInfo ), -1 )
	if quentityQuery ~= 0 then
		outputChatBox( "Пользователь с такими данными уже есть!", client )
		return true
	end

	return false
end

addEvent( "testingJSON:onChangeUserInfo", true )
addEventHandler( "testingJSON:onChangeUserInfo", resourceRoot, function( tPrevInfoUser, tNewInfoUser )
	local oldJSON = toJSON( tPrevInfoUser )
	local newJSON = toJSON( tNewInfoUser )
	if checkingTheSameRow( newJSON ) then
		return
	end

	dbExec( db_connection, "UPDATE everyData SET userInfo = ? WHERE userInfo = ?", newJSON, oldJSON )

	outputChatBox( "Информация изменена!", client )

	for player, _ in pairs( tDGSOpen ) do -- обновляем информацию у тех, у кого открыто окно в данный момент
		triggerClientEvent( player, "testingJSON:onUpdDGS", resourceRoot, tPrevInfoUser, tNewInfoUser )
	end
end )

addEvent( "testingJSON:onDeleteUserInfo", true )
addEventHandler( "testingJSON:onDeleteUserInfo", resourceRoot, function( tInfoUser )
	dbExec( db_connection, "DELETE FROM everyData WHERE userInfo = ?", toJSON( tInfoUser ) )

	outputChatBox( "Пользователь удален!", client )

	for player, _ in pairs( tDGSOpen ) do -- обновляем информацию у тех, у кого открыто окно в данный момент
		triggerClientEvent( player, "testingJSON:onUpdDGS", resourceRoot, tInfoUser )
	end
end )

addEvent( "testingJSON:onAddingUserToBD", true )
addEventHandler( "testingJSON:onAddingUserToBD", resourceRoot, function( tUserInfo )
	local stringForQuery = toJSON( tUserInfo )
	if checkingTheSameRow( stringForQuery ) then
		return
	end
	
	dbExec( db_connection, "INSERT INTO everyData VALUES( ? )", stringForQuery )
	outputChatBox( "Пользователь с данными " .. stringForQuery .. " добавлен в базу!", client )

	for player, _ in pairs( tDGSOpen ) do -- обновляем информацию у тех, у кого открыто окно в данный момент
		triggerClientEvent( player, "testingJSON:onAddRowDGS", resourceRoot, tUserInfo )
	end
end )

addCommandHandler( "openWindow", function( thePlayer ) -- команда для открытия окна
	if tDGSOpen[thePlayer] then
		return
	end

	local query = "SELECT userInfo FROM everyData"
	local tInfoUsers = dbPoll( dbQuery( db_connection, query ), -1 )
	triggerClientEvent( thePlayer, "testingJSON:OnChangeWindowVisible", resourceRoot, true, tInfoUsers )
	tDGSOpen[thePlayer] = true
end )

addEvent( "testingJSON:onCloseWindowDGS", true ) -- при закрытии окна на клиенте опустошаем ячейку таблицы
addEventHandler( "testingJSON:onCloseWindowDGS", resourceRoot, function()
	tDGSOpen[client] = nil
end )

local function checkingOnExit()
	if not tDGSOpen[source] then
		return
	end

	tDGSOpen[source] = nil
	triggerClientEvent( source, "testingJSON:OnChangeWindowVisible", resourceRoot, false )
end
addEventHandler( "onPlayerLogout", root, checkingOnExit )
addEventHandler( "onPlayerQuit", root, checkingOnExit )

local function checkingDXMotionOnExit()
	triggerClientEvent( source, "testingJSON:OnDestroyDXMotion", resourceRoot, false )
end
addEventHandler( "onPlayerLogout", root, checkingDXMotionOnExit )
addEventHandler( "onPlayerQuit", root, checkingDXMotionOnExit )