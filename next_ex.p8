pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
--main functions--
function _init()
	palt(0,false)
	palt(14,true)
	state = 4
end

function _update()

end

function _draw()
	if state == 4 then
		main_room_draw()
	end
end
-->8
--destiny--
--main entryway, 16x16--
mainroom = {
	{1,2,1,2,1,2,1,4,5,2,1,2,1,2,1,2},
	{17,18,17,18,17,18,17,20,21,18,17,18,17,18,17,18},
	{3,3,3,3,3,3,3,36,37,3,3,3,3,3,3,3},
	{19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19},
	{19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19},
	{19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19},
	{19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19},
	{19,19,19,19,19,19,6,7,7,8,19,19,19,19,19,19},
	{19,19,19,19,19,19,22,23,23,24,19,19,19,19,19,19},
	{19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19},
	{19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19},
	{19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19},
	{19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19},
	{19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19},
	{19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19},
	{19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19}
}
function main_room_draw()
cls(0)
x =64-((#mainroom[1]/2)*8)
y = 0
for i=1,#mainroom do
	for j=1,#mainroom[1] do
		spr(mainroom[i][j],x,y)
		x+= 8
	end
	x =64-((#mainroom[1]/2)*8)
	y+= 8
end
end


-->8
--jimbob--
-->8
--carly--
-->8
--zoe--
room2 = {
{1,1,3,3,3},
{1,1,1,4,3},
{1,1,1,1,3},
{1,1,1,1,3},
{1,1,1,1,3},
{2,1,1,1,3},
{1,1,1,1,3},
{1,1,1,1,3}}

function mech_room_draw()
cls(1)
	x =64-((#room2[1]/2)*8)
 y = 0
 for i=1,#room2 do
 	for j=1,#room2[1] do
			spr(room2[i][j],x,y)
 		x+= 8
 	end
 	x =64-((#room2[1]/2)*8)
 	y+= 8
 end
end

__gfx__
000000001111111dd111111122222222222222222222222255599999999999999999955500000000000000000000000000000000000000000000000000000000
0000000011dd11111111dd1124442444244444444444444255922222222222222222295500000000000000000555555555555550000000000000000000000000
007007001d11d111111d11d124442444245225444452254259244444444444444444429500000000000000000111155555555550000000000000000000000000
0007700011dd111dd111dd1124442444242552444425524292444444444444444444442900000000000000000111111111111110000000000000000000000000
00077000111111d11d11111124442444242552444425524292444444444444444444442900000000000000000000000000000000000000000000000000000000
007007001111111dd111111124442444245225444452254292444444444444444444442900000000000000000011555555555500000000000000000000000000
0000000011dd11111111dd1124442444244444444444444292444444444444444444442900000000000000000011111115555500000000000000000000000000
000000001d11d111111d11d122222222244444444444444292444444444444444444442900000000000000000011111111111500000000000000000000000000
0000000011dd11111111dd1155555555244444444444444292444444444444444444442900000000000000000000000000000000000000000000000000000000
000000001111111dd111111155555555244444444444444292444444444444444444442900000000000000000101115555555010000000000000000000000000
00000000111111d11d11111155555555244444944944444292244444444444444444422900000000000000000101111155555010000000000000000000000000
0000000011dd111dd111dd1155555555244449444494444259924444444444444444299500000000000000000100000000000010000000000000000000000000
000000001d11d111111d11d155555555244449444494444255599999999999999999955500000000000000000100111111110010000000000000000000000000
0000000011dd11111111dd1155555555244449444494444255552222222222222222555500000000000000000010000001110100000000000000000000000000
000000001111111dd111111155555555244444944944444255552244444444444422555500000000000000000000000000000000000000000000000000000000
00000000111111d11d11111155555555244444444444444255522244455555544422255500000000000000000000000000000000000000000000000000000000
0000000000000000eeeeeeeeeeeeeeee244444444444444200000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000eeeeeeeeeeeeeeee244444444444444200000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000eeee88eee88eeeee245225444452254200000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000eee828eee828eeee242552444425524200000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000eee888eee888eeee242552444425524200000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000eeeeee3ee3eeeeee245225444452254200000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000eeeeeee3e3eeeeee244444444444444200000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000eeeee666666eeeee222222222222222200000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000eeeee663676eeeee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000eeeee663676eeeee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000eeeee633676eeeee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000eeeee676376eeeee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000eeeee676366eeeee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000eeeee666666eeeee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000eeeeeeddddeeeeee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000eeeeeeeeeeeeeeee000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
