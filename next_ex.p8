pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
--main functions--
function _init()
	palt(0,false)
	palt(14,true)
	--p_x and p_y are the indexes of the room arrays
	p_x=2
	p_y=3
	--p_dx and p_dy are only -1,0,1
	p_dx=0
	p_dy=0
	p_spr=76
	p_dir=76 --player sprite to be displayed
	p_movecounter=0 --for walking animation
	p_walkanimation=0 --for walking animation (0 or 1)
	p_moving=false
	
	state = 4
	
	curr_key_item=-1 --sprite number for current key item (-1 for no item)
	collected_pieces = {} --sprite numbers for collected puzzle pieces (letters)
	d =false
	j =false
	z= false
	c =false
end

function _update()
	player_move()
	if btnp(4) then
	 state += 1
	 if state == 3 then
	 	state+= 1
	 elseif state == 5 then
	 	state = 1
	 end
	end
	if btnp(5) then
		add_inventory()
	end
end

function _draw()
	if state == 1 then
		main_room_draw()	
	elseif state == 2 then
		lab_room_draw()
	elseif state == 3 then
		serv_room_draw()
	elseif state == 4 then
		mech_room_draw()
	end
	inv_display()
	if btn(5) and puzzle_select() then
		print("this would be a	",55,112,7)
		print("puzzle",55,120,7)
	end
end
-->8
--destiny--
--main entryway, 16x16--
mainroom = {
	{1,2,1,2,1,2,4,5,6,7,1,2,1,2,1,2},
	{17,18,17,18,17,18,20,21,22,23,17,18,17,18,17,18},
	{1,2,1,2,1,2,36,37,38,39,1,2,1,2,1,2},
	{3,3,3,3,3,3,52,53,54,55,3,3,3,3,3,3},
	{19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19},
	{19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19},
	{19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19},
	{19,19,19,19,19,19,8,9,10,19,19,19,19,19,19,19},
	{19,19,19,19,19,19,24,25,26,19,19,19,19,19,19,19},
	{19,19,19,19,19,19,40,41,42,19,19,19,19,19,19,19},
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
labroom={
{100,100,100,100,100,100,100,100,100,100,100,100},
{100,100,100,100,100,68,69,70,100,100,100,100},
{19,19,19,19,19,84,85,86,19,19,19,19},
{19,19,19,19,19,19,19,19,19,19,19,19},
{19,19,19,112,113,114,115,116,117,19,19,19},
{19,19,19,19,19,19,19,19,19,19,19,19},
{102,19,19,19,19,19,19,19,19,19,19,19},
{19,19,19,64,65,19,19,82,83,19,19,19},
{19,19,19,19,19,19,19,19,19,19,19,19},
{19,19,19,66,67,19,19,80,81,19,19,19},
{19,19,19,19,19,19,19,19,19,19,19,19},
{19,19,19,96,97,19,19,98,99,19,19,19},
{19,19,19,19,19,19,19,19,19,19,19,19},
{19,19,19,19,19,19,19,19,19,19,19,19}}
function lab_room_draw()
	cls(0)
	draw_room(labroom)
end
-->8
--carly--
-->8
--zoe--
mechroom = {
{192,193,192,194,195},
{192,209,192,210,211},
{208,208,208,224,225},
{208,208,208,208,208},
{208,208,208,208,101},
{208,208,208,208,208},
{208,208,208,208,208},
{208,208,208,208,208}}

function mech_room_draw()
	cls()
	draw_room(mechroom)
end

-->8
--other stuff--
--generic draw room function that displays 2-d array of sprites
function draw_room(room)
 x =64-((#room[1]/2)*8)
 y = 0
 for i=1,#room do
 	for j=1,#room[1] do
			spr(room[i][j],x,y)
 		x+= 8
 	end
 	x =64-((#room[1]/2)*8)
 	y+= 8
 end
 spr(p_spr,64-((#room[1]/2)*8)+flr(8*(p_x-1)),flr(8*(p_y-1))-4)
end

--returns sprite number of tile player is facing, if player is facing boundary, return -1
function tile_facing()
	local room 
	
	if state == 1 then
		room = mainroom
	elseif(state==2) then 
	 room=labroom
	elseif state == 4 then 
		room=mechroom
	end
	
	if p_dir==76 then
		if(p_y+1>#room) return -1
		return room[p_y+1][p_x]
	elseif p_dir==77 then
		if(p_y-1<1) return -1
		return room[p_y-1][p_x]
	elseif p_dir==78 then
		if(p_x-1<1) return -1
		return room[p_y][p_x-1]
	elseif p_dir==79 then
		if(p_x+1>#room[1]) return -1
		return room[p_y][p_x+1]
	end
end

--returns sprite number of tile player is standing on
function tile_standing()
	local room
	if state == 1 then
		room = mainroom
	elseif(state==2) then 
		room=labroom
	elseif state == 4 then 
		room=mechroom
	end
	return room[p_y][p_x]
end

--update player moving
function player_move()
    if not p_moving then
        p_spr=p_dir
        local dx,dy = 0,0
        if(btn(0)) dx-=1
        if(btn(1)) dx+=1
        if(btn(2)) dy-=1
        if(btn(3)) dy+=1
        if(dx~=0) dy=0
        if dx~=0 or dy~=0 then
            if(dx==-1) p_dir=78
            if(dx==1) p_dir=79
            if(dy==-1) p_dir=77
            if(dy==1) p_dir=76
            p_spr=p_dir
            p_dx=dx
            p_dy=dy
            p_movecounter=0
            p_walkanimation=1-p_walkanimation
            p_moving=true
            if(tile_facing()==-1 or fget(tile_facing(),0)) then --collision
				door_check()
                p_dx=0
                p_dy=0
            end
        end
    end
	if p_moving then
		p_movecounter+=1
		p_x+=0.125*p_dx
		p_y+=0.125*p_dy
		if(p_movecounter==2) then
			p_spr=16*(p_walkanimation+1)+p_dir
		end
		if(p_movecounter==8) then
			p_spr=p_dir
			p_moving=false
			p_dx=0
			p_dy=0
		end
	end
end

function inv_display()
	--key item
	rect(2,116,11,125,10)
	if(curr_key_item~=-1) spr(curr_key_item,3,117)
	--puzzle pieces
	local x = 14
	for p,n in pairs(collected_pieces) do
		rect(x,116,x+9,125,7)
		spr(n,x+1,117)
		x+=9
	end
end

--move between different rooms via door
function door_check()
	if(tile_standing()>=101 and tile_standing()<=103) then
		if state==2 then
			state=4
			p_x=5
			p_y=5
		elseif state==4 then
			state=2
			p_x=1
			p_y=7
		end
	end
end

--temp function--
function puzzle_select()
	local til = tile_facing()
	
	if state == 1 then
		if (til >= 6 and til <= 8) or (til >= 22 and til <= 24) then
			return true
		end
	elseif state == 2 then
		if til >= 112 and til <= 117 then
			return true
		end
	elseif state == 3 then
		if til == 153 then
			return true
		end
	elseif state == 4 then
		if til == 209 then
			return true
		end
	end
end

--end temp function---

function add_inventory()
	if state == 1 and d == false then
		if (tile_facing() >= 10 and tile_facing() <= 10) or (tile_facing() >= 24 and tile_facing() <= 26) or (tile_facing() >= 40 and tile_facing() <= 42) then
			add(collected_pieces,124)
			d = true
		end
	elseif state == 2 and j== false then
		if tile_facing() >= 84 and tile_facing() <= 86  then
			add(collected_pieces,127)
			j = true
		end
	elseif state == 3 and c == false then
		if tile_facing() == 136 then
			add(collected_pieces,126)
			c = true
		end
	elseif state == 4 and z==false then
		if tile_facing() == 210 or tile_facing() == 211 then
			add(collected_pieces,125)
			z= true	
		end
	end 
end

--returns sprite number of tile player is facing, if player is facing boundary, return -1
function tile_facing()
	local room 
	
	if state == 1 then
		room = mainroom
	elseif(state==2) then 
	 room=labroom
	elseif state == 4 then 
		room=mechroom
	end
	
	if p_dir==76 then
		if(p_y+1>#room) return -1
		return room[p_y+1][p_x]
	elseif p_dir==77 then
		if(p_y-1<1) return -1
		return room[p_y-1][p_x]
	elseif p_dir==78 then
		if(p_x-1<1) return -1
		return room[p_y][p_x-1]
	elseif p_dir==79 then
		if(p_x+1>#room[1]) return -1
		return room[p_y][p_x+1]
	end
end

__gfx__
000000001111111dd111111122222222222222222222222222222222222222225555555555555885555555550000000000000000000000000000000000000000
0000000011dd11111111dd1124442444244444444444444224444444444444425555555555885885555555550000000000000000000000000000000000000000
007007001d11d111111d11d124442444244444444444444224444444444444425559999999889399999995550000000000000000000000000000000000000000
0007700011dd111dd111dd1124442444244444444444444224444444444444425592222222232232222229550000000000000000000000000000000000000000
00077000111111d11d11111124442444244422222224444224444222222244425944444444466667444442950000000000000000000000000000000000000000
007007001111111dd111111124442444244424444224444224444244444244429244444444466666444444290000000000000000000000000000000000000000
0000000011dd11111111dd1124442444244424222424444224444222242244429244444444466667444444490000000000000000000000000000000000000000
000000001d11d111111d11d122222222244424222424444224444222242244429244444444466667444444490000000000000000000000000000000000000000
0000000011dd11111111dd1155555555244424222424444224444242242244429244444444467667444444490000000000000000000000000000000000000000
000000001111111dd111111155555555244424444224444224444244442244429244444444467667444444490000000000000000000000000000000000000000
00000000111111d11d1111115555555524442222222444422444422222224442924444444444ddd4444444490000000000000000000000000000000000000000
0000000011dd111dd111dd1155555555244444444444444224444444444444429244444444444444444444490000000000000000000000000000000000000000
000000001d11d111111d11d155555555244444444444444224444444444444429244444444444444444444490000000000000000000000000000000000000000
0000000011dd11111111dd1155555555244444444444494224944444444444425924444444444444444444490000000000000000000000000000000000000000
000000001111111dd111111155555555244444444444944224494444444444425592222222222222222222950000000000000000000000000000000000000000
00000000111111d11d11111155555555244444444444944224494444444444425522222222222222222229550000000000000000000000000000000000000000
00000000000000000000000000000000244444444444944224494444444444425524444255555552444442550000000000000000000000000000000000000000
00000000000000000000000000000000244444444444944224494444444444425524442255555552244442550000000000000000000000000000000000000000
00000000000000000000000000000000244444444444494224944444444444425552222555555555222225550000000000000000000000000000000000000000
00000000000000000000000000000000244444444444444224444444444444425552222555555555222225550000000000000000000000000000000000000000
00000000000000000000000000000000244444444444444224444444444444425552222555555555222225550000000000000000000000000000000000000000
00000000000000000000000000000000244444444444444224444444444444425554422555555555442225550000000000000000000000000000000000000000
00000000000000000000000000000000244422222224444224444222222244425554444555555555444425550000000000000000000000000000000000000000
00000000000000000000000000000000244422444224444224444224442244425555555555555555555555550000000000000000000000000000000000000000
00000000000000000000000000000000244424222224444224444222242244420000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000244424222224444224444222422244420000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000244424222224444224444224222244420000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000244422444224444224444224442244420000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000244422222224444224444222222244420000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000244444444444444224444444444444420000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000244444444444444224444444444444420000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000222222222222222222222222222222220000000000000000000000000000000000000000000000000000000000000000
555555555555555555555555555555559999999999999999999999990000000000000000000000000000000000000000ee4444eeee4444eee44444eeee44444e
555777555577755555557555555755559999999999999999999999990000000000000000000000000000000000000000e444444ee444444ee444444ee444444e
555777555577755555557555555755559900000000000000000000990000000000000000000000000000000000000000e4ffff4ee4ffff4eeffff44ee44ffffe
5551115555111555555bbb5555bbb5559900000000000000000000990000000000000000000000000000000000000000ef0ff0feeffffffeef0ffffeeffff0fe
5551115555111555555bbb5555bbb5559900070700000700077000990000000000000000000000000000000000000000effffffeeffffffeefff888ee888fffe
550000000000005555000000000000559900007070007070000700990000000000000000000000000000000000000000ed8878deed8888deeee8788ee8878eee
559999999999995555999999999999559900000000000000000000990000000000000000000000000000000000000000ee8888eeee8888eeeee8d88ee88d8eee
559555555555595555955555555559559900000000000000000000990000000000000000000000000000000000000000ee6ee6eeee6ee6eeee666eeeeee666ee
555555555555555555555555555555559900070700007000077000990000000000000000000000000000000000000000ee4444eeee4444eee44444eeee44444e
555777555577755555557555555755559900007000700700700000990000000000000000000000000000000000000000e444444ee444444ee444444ee444444e
555777555577755555557555555755559900000000000000000000990000000000000000000000000000000000000000e4ffff4ee4ffff4eeffff44ee44ffffe
5558885555888555555ccc5555ccc5559999999999999999999999990000000000000000000000000000000000000000ef0ff0feeffffffeef0ffffeeffff0fe
5558885555888555555ccc5555ccc5559999999999999999999999990000000000000000000000000000000000000000effffffeeffffffeefff888ee888fffe
550000000000005555000000000000559955555555555555555555990000000000000000000000000000000000000000eed878deed888deeeee8788ee8878eee
559999999999995555999999999999559955555555555555555555990000000000000000000000000000000000000000ee8888eeee8888eeeed8d88ee88d8dee
559555555555595555955555555559559955555555555555555555990000000000000000000000000000000000000000eeeee6eeeeeee6eeee66eeeeeeee66ee
555555555555555555555555555555550000000055666666666666556777777600000000000000000000000000000000ee4444eeee4444eee44444eeee44444e
555777555577755555557555555755550077770056777777777777656777777600000000000000000000000000000000e444444ee444444ee444444ee444444e
555777555577755555557555555755550777777067777777777777766777777600000000000000000000000000000000e4ffff4ee4ffff4eeffff44ee44ffffe
555ddd5555ddd555555aaa5555aaa5550777777067777777777777766777777600000000000000000000000000000000ef0ff0feeffffffeef0ffffeeffff0fe
555ddd5555ddd555555aaa5555aaa5550777777067777777777777766777777600000000000000000000000000000000effffffeeffffffeefff888ee888fffe
550000000000005555000000000000550777777067777777777777766777777600000000000000000000000000000000ed887deeeed888deeed8d88ee88d8dee
559999999999995555999999999999550077770056777777777777655677776500000000000000000000000000000000ee8888eeee8888eeeee8788ee8878eee
559555555555595555955555555559550000000055666666666666555566665500000000000000000000000000000000ee6eeeeeee6eeeeeeeee66eeee66eeee
555555555555555555555555555555555555555555555555000000000000000000000000000000000000000000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
557775577755575555755577755575555555777555555555000000000000000000000000000000000000000000000000ee666eeeee6666eeee6666eeee6666ee
557775577755575555755577755575557575766555566555000000000000000000000000000000000000000000000000ee6ee6eeeeeee6eeee6eeeeeeeee6eee
551115588855ccc55aaa55ddd55bbb557575777555565555000000000000000000000000000000000000000000000000ee6ee6eeeeee6eeeee6eeeeeeeee6eee
551115588855ccc55aaa55ddd55bbb557575777556565655000000000000000000000000000000000000000000000000ee6ee6eeeee6eeeeee6eeeeeeeee6eee
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ee6ee6eeee6eeeeeee6eeeeeee6e6eee
999999999999999999999999999999999999999999999999000000000000000000000000000000000000000000000000ee666eeeee6666eeee6666eeee666eee
999999999999999999999999999999999999999999999999000000000000000000000000000000000000000000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1dd1dd1d1dd1dd1dd1552d2dd2dd2011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111111111155222222220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d1dd1dd1d1dd1dd1dd55d2d2dd211010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111111111155222222000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1d1dd1dd1555555d1d55dd2d2d101011000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111155533511155555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d1d1dd1dd533555dd255550000550110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111155588511222550000550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
555555551588555dd2dd555555551101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
555555551555cc512225555555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555d5cc5551dd25508888055010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555155555512225588998855555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
555555551d1dd1dd2dd5589999855555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555111111112225555555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555d1d1dd1dd2d5511010155110000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55555555111111112225500000055000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
555229aaaa9222550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
555229aaa99222550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
25229aaa992222550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
52999999922225550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
52299929222555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22292222255555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55222222555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55255525555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010101010101000000000000000000010101010101010000000000000000000101010101000000000000000000000001010101010100000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001010101000000000000000000000000000101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
