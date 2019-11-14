pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
--main functions--
--music from: https://youtu.be/7umg6zrieh8--
function _init()
	final = false
	music(0,2000)
	palt(0,false)
	palt(14,true)
	--p_x and p_y are the indexes of the room arrays
	p_x=2
	p_y=5
	--p_dx and p_dy are only -1,0,1
	p_dx=0
	p_dy=0
	p_spr=76
	p_dir=76 --player sprite to be displayed
	p_movecounter=0 --for walking animation
	p_walkanimation=0 --for walking animation (0 or 1)
	p_moving=false

	state = 6

	timer_mins = 6
	timer_secs = 0
	timer_ticks = 0

	curr_key_item=-1 --sprite number for current key item (-1 for no item)
	collected_pieces = {} --sprite numbers for collected puzzle pieces (letters)
	d =false
	j =false
	z= false
	c =false

	controls = false

	lights = true

	fail = false

	--dialog stuff--
	dialog_state=0 --0 is not currently in dialog
	dialog_messages={} --dialog to show (manipulated through different functions)
	dialog_curr_char=1 --animating dialog
	dialog_counter=0 --animating dialog
	print_x=0
	print_y=0

	mech_room_init()
	lab_room_init()
	main_room_init()
	serv_room_init()
	explo = false
end

function _update()
	if timer_mins <= 0 and timer_secs <= 0 then
		fail = true
		state= 5
	end

	if dialog_state==0 then
		if state == 7 then
			laser_con()
		elseif state == 8 then
			chem_con()
		elseif state == 9 then
			lock_con()
		elseif btnp(5) then
			if not controls and state < 5 then
				controls =true
			end
			if state == 5 and time() - set > 6 then
				state = 6
				_init()
			elseif state == 6 then
				state = 1
				start_time = time()
			end
		end
	end

	if(state < 5 and dialog_state==0) then
		player_move()
		if btnp(5) then
			puzzle_select()
			add_inventory()
			win_check()

		end
	end
	if(dialog_state>0) dialog_update()
	exp_update()
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
	elseif state == 5 then
		win_draw()
	elseif state == 6 then
		intro_draw()
	elseif state == 7 then
		laser_draw()
	elseif state == 8 then
		chem_draw()
	elseif state == 9 then
		lock_draw()
	end

	if state < 5 or state>=7 then
		if state < 5 then
			inv_display()
			if(not controls) print("⬅️⬇️⬆️➡️:move\n❎:interact",75,112,7)
			if(dialog_state>0) dialog_draw()
		end
		runtime = game_timer()
		if timer_mins <= 1 then
			print(runtime,2,2,8)
		else
			print(runtime,2,2,7)
		end
	end
	exp_draw()
end
-->8\
--destiny--
--main entryway, 16x16--
function main_room_init()
	mainroom = {
		{1,2,1,2,1,2,1,4,5,2,1,2,1,2,1,2},
		{17,18,17,18,17,18,17,20,21,18,17,18,17,18,17,18},
		{3,3,3,3,3,3,3,36,37,3,3,3,3,3,3,3},
		{19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19},
		{19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19},
		{19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19},
		{102,19,19,19,19,19,19,19,19,19,19,19,19,19,19,101},
		{19,19,19,19,19,19,19,6,7,8,19,19,19,19,19,19},
		{19,19,19,19,19,19,19,22,23,24,19,19,19,19,19,19},
		{19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19},
		{35,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19},
		{51,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19},
		{19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19},
		{19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19},
		{19,19,19,19,19,19,19,33,34,19,19,19,19,19,19,19},
		{19,19,19,19,19,19,19,49,50,19,19,19,19,19,19,19}
	}
	flowers_solved = false
	flower_draw = true
	flower_spr = 38
	dilay=10
end

function main_room_update()
	local t = tile_facing()
	x = 0
	if(f_spr > 40) then f_spr = 38 end
	-- TO DO: add condition that pitcher is in inventory
	if (t >= 6 and t <= 8) or (t >= 22 and t <= 24) then
		while x < 2 do
			if(time() - flower_anim_time > 1) then
				f_spr+=1
				spr(f_spr,64-((#mainroom[1]/2)*8)+flr(8*(9-1)),flr(8*(8-1)))
				flower_anim_time = time()
			end
			x+=1
		end
	end
end

function main_room_draw()
	cls(0)
	draw_room(mainroom)
	if not lights then
		for i=2,15 do
			pal(i,1)
		end
		pal(1,0)
		pal(5,0)
		pal(2,0)
	end
	spr(flower_spr,64-((#mainroom[1]/2)*8)+flr(8*(9-1)),flr(8*(8-1)))
	pal()
	palt(0,false)
	palt(14,true)
end
=======
>>>>>>> master
-->8
--jimbob--
function lab_room_init()
	labroom={
	{100,100,100,71,72,100,100,100,100,100,100,100},
	{100,100,100,87,88,68,69,70,100,100,100,100},
	{19,19,19,19,19,84,85,86,19,19,19,19},
	{19,19,19,19,19,19,19,19,19,19,19,19},
	{19,19,19,112,113,114,115,116,117,19,19,19},
	{19,19,19,19,19,19,19,19,19,19,19,19},
	{19,19,19,19,19,19,19,19,19,19,19,19},
	{19,19,19,64,65,19,19,82,83,19,19,19},
	{19,19,19,19,19,19,19,19,19,19,19,19},
	{19,19,19,66,67,19,19,80,81,19,19,19},
	{19,19,19,19,19,19,19,19,19,19,19,19},
	{19,19,19,96,97,19,19,98,99,19,19,19},
	{19,19,19,19,19,19,19,19,19,19,19,19},
	{19,19,19,19,19,19,19,19,19,19,19,19}}

	chem_colors={1,8,12,10,13,11}
	chem_sol={1,8,11,12,13,10} --numbers represent colors of chemicals (dark blue,red,green,light blue,light indigo,yellow)
	chem_mix={}
	chem_anim=0 --for animating chemical puzzle
	sel_color=0 --selected color for animating
end

function lab_room_draw()
	cls(0)
	draw_room(labroom)
end

--returns true if chemical is already added to the mix
function chem_mix_contains(color)
	if #chem_mix>0 then
		for k,v in pairs(chem_mix) do
			if(v==color) return true
		end
	end
	return false
end

function chem_con()
	if sel_color==0 then
		if #chem_sol==#chem_mix then
			chem_anim+=1
			if chem_anim==30 then
				state=2
				if chem_solved() then
					curr_key_item=120 --correct chemical
				else
					curr_key_item=104 --incorrect chemical
				end
				show_dialog({"you received\nMYSTERIOUS\nCHEMICAL!"},55,105)
				chem_anim=0
				chem_mix={}
			end
		end
		if btnp(5,1) and #chem_mix < #chem_sol then
			state=2
		elseif btn(0,1) and #chem_mix < #chem_sol then
			chem_mix={}
		elseif btnp(0,0) then sel_color=12
		elseif btnp(1,0) then sel_color=10
		elseif btnp(2,0) then sel_color=1
		elseif btnp(3,0) then sel_color=8
		elseif btnp(4,0) then sel_color=13
		elseif btnp(5,0) then sel_color=11
		end
		if sel_color~=0 and not chem_mix_contains(sel_color) then
			add(chem_mix,sel_color)
		else
			sel_color=0
		end
	end
end

function chem_draw()
	cls(0)
	chem_con_draw()
	local spr_x=0
	local spr_y=0
	if sel_color==0 then
		if #chem_mix==0 then
			spr_x=72
			spr_y=56
		else
			spr_x=80
			spr_y=56
		end
	else
		if chem_anim%12<4 then
			spr_x=72
		elseif chem_anim%12<8 then
			spr_x=80
		else
			spr_x=88
		end
		if chem_anim<24 then
			spr_y=32
		elseif chem_anim<48 then
			spr_y=40
		else
			spr_y=48
		end
		chem_anim+=1
		pal(1,sel_color)
		if chem_anim==72 then
			sel_color=0
			chem_anim=0
		end
	end
	if(#chem_mix==1) pal(15,chem_mix[1])
	if(sel_color==0 and chem_solved()) pal(15,2)
	sspr(spr_x,spr_y,8,8,28,16,84,84)
	if #chem_mix>1 and chem_anim>0 and sel_color~=0 then
		if(#chem_mix==2) pal(15,chem_mix[1])
		if chem_anim<24 then
			sspr(80,56,8,8,28,16,84,84)
		elseif chem_anim<48 then
			sspr(88,56,8,8,28,16,84,84)
		end
	end
	pal(15,15)
	pal(1,1)
	chem_order_draw()
end

function chem_con_draw()
	rect(14,104,114,127,7)
	print("try to mix the chemicals\nin the correct order",17,107,7)
	print("⬆️\n\n⬇️\n\n⬅️\n\n➡️\n\nz\n\nx",3,33,7)
	for i=1,6 do
		pal(15,chem_colors[i])
		spr(118,12,12*i+21)
	end
	pal(15,15)
	print("s:reset",3,9,7)
	print("a:quit",3,21,7)
end

function chem_order_draw()
	if #chem_mix>0 then
		local y = 33
		local sp
		for k,v in pairs(chem_mix) do
			pal(15,v)
			print(k,107,y,7)
			spr(118,116,y)
			y+=12
		end
	end
end

function chem_solved()
	if(#chem_mix~=#chem_sol) return false
	for i=1,#chem_sol do
		if(chem_mix[i]~=chem_sol[i])return false
	end
	return true
end
-->8
--carly--
--sprite sheet 2
--state 9 for puzzle
function serv_room_init()
	num={0,0,0}
	pad_sel=1

servroom= {
	{152,152,152,152,152,152,152,152,152,152,152},
	{132,133,153,153,153,131,135,131,140,131,137},
	{129,130,147,147,147,148,151,148,136,148,134},
	{138,139,147,147,147,147,147,147,147,147,150},
	{147,147,147,147,147,147,147,147,147,147,147},
	{128,147,147,147,143,144,147,147,147,147,147},
	{141,147,147,147,145,146,142,147,147,147,147},
	{102,147,147,147,147,147,147,147,147,147,147}}

	jug_taken=false

end

function serv_room_draw()
	cls()
	draw_room(servroom)
	if(not jug_taken) spr(149,52,40)
end


function lock_draw()
	cls()

 sspr(80,72,8,8,36,0,54,17)
 sspr(80,72,8,8,36,15,54,17)
 sspr(80,72,8,8,36,30,54,17)

	print(num[1],62,6,0)
	print(num[2],62,21,0)
	print(num[3],62,36,0)

	if pad_sel==1 then
		sspr(88,72,8,8,40,0,45,17)
	elseif pad_sel==2 then
		sspr(88,72,8,8,40,15,45,17)
	elseif pad_sel==3 then
		sspr(88,72,8,8,40,30,45,17)
	end

	palt(14,true)

	cons()
end

function lock_con()
	if btnp(2) then
		pad_sel-=1
		if pad_sel==0 then
			pad_sel=3
		end
	elseif btnp(3) then
		pad_sel+=1
		if pad_sel==4 then
			pad_sel=1
		end
	elseif btnp(0) then
		num[pad_sel]-=1
		if num[pad_sel]==-1 then
			num[pad_sel]=9
		end
	elseif btnp(1) then
		num[pad_sel]+=1
		if num[pad_sel]==10  then
			num[pad_sel]=0
		end
	elseif btnp(4) then
		state=3
	end
	if lock_solve() then
		state=3
		add(collected_pieces,126)
		c = true
		sfx(1)
	end
end

function lock_solve()
	if num[1]==4 and num[2]==3 and num[3]==8 then
	 return true
	else
		return false
	end
end

function cons()
	rect(2,85,127,127,7)
	print(
	"⬅️⬇️⬆️➡️: change numbers\n\n"..
	"enter the correct number\n"..
	"to unlock the fridge.\n\n"..
	"z: exit",4,88,7)
end
-->8
--zoe--
function mech_room_init()
	sel = {}
	sel.color = 213
	sel.x = 3
	sel.y = 5
	sel.dir = "none"

	exp= {}
	for i = 1, 100 do
	add(exp,{x=0,y=0,dx=0,dy=0,r=0,m=0,a=false})
	end

	mechroom = {
	{192,192,193,192,194,195},
	{192,192,209,192,210,211},
	{208,208,208,208,224,225},
	{208,208,208,208,208,208},
	{208,208,208,208,208,101},
	{208,208,208,208,208,208},
	{208,208,208,208,208,208},
	{212,208,208,208,196,197}}

	laser_puz = {
	{208,208,208,208,208},
	{208,230,208,208,208},
	{208,208,208,208,208},
	{208,208,208,208,208},
	{208,208,208,208,208},
	{208,208,208,198,208},
	{208,208,208,208,208},
	{208,208,198,208,246},
	{208,208,214,208,208},
	{214,230,246,208,208}}

	puz_ans = {
	{218,215,215,215,217},
	{216,230,202,201,216},
	{216,232,200,200,216},
	{216,232,200,200,216},
	{216,232,200,200,216},
	{216,232,200,198,216},
	{216,232,200,218,220},
	{216,232,198,216,246},
	{216,232,214,220,248},
	{214,230,246,247,252}}
end

function mech_room_draw()
	cls()
	draw_room(mechroom)
	if (explo and not j) spr(127,(64-((#mechroom[1]/2)*8)+36),4)
end

function laser_draw()
	cls()
	x =64-((#laser_puz[1]/2)*8)
 y = 0
 for i=1,#laser_puz do
 	for j=1,#laser_puz[1] do
			spr(laser_puz[i][j],x,y)
 		x+= 8
 	end
 	x =64-((#laser_puz[1]/2)*8)
 	y+= 8
 end
 palt(0,false)
	palt(14,true)
	rectfill(0,0,18,8,1)
	rect(0,0,18,8,0)
	spr(sel.color,64-((#laser_puz[1]/2)*8)+flr(8*(sel.x-1)),(8*(sel.y-1)))
	draw_cons()
end

function draw_cons()
	rect(2,85,127,127,7)
	print(
	"❎: select / deselect\n"..
	"⬅️⬇️⬆️➡️: move\n\n"..
	"connect wires "..
	"to restore power\n\n"..
	"z: exit",4,88,7)
end

function laser_con()
	--layout controls for laser puzzle--
	if btnp(0) then
		if sel.color != 213 then
			laser_map("left",laser_puz)
			sel.dir = "left"
		end
		sel.x -= 1
		if wall_check(sel.x,sel.y,laser_puz) then
		 sel.x+= 1
		end
		if puz_win() then
			state = 4
		else
			lights = false
		end
	end
	if btnp(1) then
		if sel.color != 213 then
			laser_map("right",laser_puz)
			sel.dir = "right"
		end
		sel.x += 1
		if wall_check(sel.x,sel.y,laser_puz) then
		 sel.x -= 1
		end
		if puz_win() then
			state = 4
		else
			lights = false
		end
	end
	if btnp(2) then
		if sel.color != 213 then
			laser_map("up",laser_puz)
			sel.dir = "up"
		end
		sel.y -= 1
		if wall_check(sel.x,sel.y,laser_puz) then
		 sel.y+= 1
		end
		if puz_win() then
			state = 4
		else
			lights = false
		end
	end
	if btnp(3)	then
		if sel.color != 213 then
			laser_map("down",laser_puz)
			sel.dir = "down"
		end
		sel.y += 1
		if wall_check(sel.x,sel.y,laser_puz) then
		 sel.y-= 1
		end
		if puz_win() then
			state = 4
		else
			lights = false
		end
	end
	if btnp(4) then
		state = 4
	end
	if btnp(5) then
		if sel.color != 213 then
			sel.color = 213
		elseif laser_puz[sel.y][sel.x]== 214 then
			if sel.color != 221 then
				sel.color = 221
			end
		elseif laser_puz[sel.y][sel.x]== 246 then
			if sel.color != 253 then
				sel.color = 253
			end
		elseif laser_puz[sel.y][sel.x]== 198 then
			if sel.color != 205 then
				sel.color = 205
			end
		elseif laser_puz[sel.y][sel.x]== 230 then
			if sel.color != 237 then
				sel.color = 237
			end
		end
	end
end

function wall_check(x,y,l)
	if (x<1 or x>#l[1]) return true
	if (y<1 or y>#l) return true
	return false
end

function laser_map(d,l)
	if sel.color == 221 then
		lr = 215
	elseif sel.color == 237 then
		lr = 231
	elseif sel.color == 205 then
		lr = 199
	elseif sel.color == 253 then
		lr = 247
	end
	ud = lr+1
	ld = lr+2
	rd = lr+3
	ru = lr+4
	lu = lr+5

	if l[sel.y][sel.x]!= 214 and l[sel.y][sel.x]!= 198 and l[sel.y][sel.x]!= 246 and  l[sel.y][sel.x]!= 230  then
		if d == "up" then
			if sel.dir == "left" then
				l[sel.y][sel.x] = ru
			elseif sel.dir == "right" then
				l[sel.y][sel.x] = lu
			else
				l[sel.y][sel.x] = ud
			end
		elseif d == "down" then
			if sel.dir == "left" then
				l[sel.y][sel.x] = rd
			elseif sel.dir == "right" then
				l[sel.y][sel.x] = ld
			else
				l[sel.y][sel.x] = ud
			end
		elseif d == "left" then
			if sel.dir == "up" then
				l[sel.y][sel.x] = ld
			elseif sel.dir == "down" then
				l[sel.y][sel.x] = lu
			else
				l[sel.y][sel.x] = lr
			end
		elseif d=="right" then
			if sel.dir == "up" then
				l[sel.y][sel.x] = rd
			elseif sel.dir == "down" then
				l[sel.y][sel.x] = ru
			else
				l[sel.y][sel.x] = lr
			end
		end
	end
end

function puz_win()
	x =64-((#laser_puz[1]/2)*8)
 y = 0
 num_cor = 0
 for i=1,#laser_puz do
 	for j=1,#laser_puz[1] do
			if laser_puz[i][j] == puz_ans[i][j] then
				num_cor +=1
			end
 	end
 	x =64-((#laser_puz[1]/2)*8)
 	y+= 8
 end
 if num_cor == 50 then
 	lights = true
		add(collected_pieces,125)
		z= true
		sfx(1)
 	return true
 else
 	return false
 end
end

function explode(x,y,r,p)
	local final=0
	for i=1,#exp do
		if not exp[i].a then
			exp[i].x = x
			exp[i].y = y
			exp[i].dx = -1+rnd(2)
			exp[i].dx = -1+rnd(2)
			exp[i].m = 0.5+rnd(2)
			exp[i].r= 0.5+rnd(r)
			exp[i].a = true
			final += 1
		end
		if (final == p) break
	end
end


function exp_update()
	for i=1,#exp do
		if exp[i].a then
			exp[i].x += exp[i].dx / exp[i].m
			exp[i].y += exp[i].dy / exp[i].m
			exp[i].r -= 0.35
			if (exp[i].r < 0.1) exp[i].a = false
		end
	end
end

function exp_draw()
	for i=1,#exp do
		if(exp[i].a) circfill(exp[i].x,exp[i].y,	exp[i].r,(rnd(2)+8))
	end
end
-->8
--other stuff--
--generic draw room function that displays 2-d array of sprites
function draw_room(room)
 x =64-((#room[1]/2)*8)
 y = 0
 for i=1,#room do
 	for j=1,#room[1] do
 	if not lights and state<5 then
 		if state !=4 then
 			for i=2,15 do
					pal(i,1)
				end
			else
					pal(8,1)
					pal(7,1)
					pal(3,1)
					pal(6,1)
					pal(11,1)
					pal(12,1)
					pal(13,1)
			end
			pal(1,0)
			pal(5,0)
			pal(2,0)
		else
			pal()
			palt(0,false)
			palt(14,true)
		end
			spr(room[i][j],x,y)
 		x+= 8
 	end
 	x =64-((#room[1]/2)*8)
 	y+= 8
 end
 pal()
 palt(0,false)
	palt(14,true)
	rectfill(0,0,18,8,1)
	rect(0,0,18,8,0)
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
	elseif state ==3 then
		room= servroom
	elseif state >= 5 then
		return -1
	end
	local p_x = flr(p_x+0.5)
	local p_y = flr(p_y+0.5)
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
	elseif state == 3 then
		room= servroom
	elseif state >=5 then
		return -1
	end
	local p_x = flr(p_x+0.5)
	local p_y = flr(p_y+0.5)
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
	local t = tile_standing()
	if (t>=101 and t<=103) or t == 33 or t == 34 or t == 87 or t == 88 then
		if state== 1 then
			if	t == 101 then
				state = 3
				p_x=1
				p_y=8
			elseif t == 102 then
				state = 4
				p_x=5
				p_y=5
			elseif t == 33 and lights then
				state = 2
				p_x=4
				p_y=2
			elseif t == 34 and lights then
				state = 2
				p_x=5
				p_y=2
			end
		elseif state==2 then
			state = 1
			p_y=15
			if t == 87 then
				p_x=8
			elseif t == 88 then
				p_x=9
			end
		elseif state==4 then
			state=1
			p_x=1
			p_y=7
		elseif state==3 then
			state=1
			p_x=16
			p_y=7
		end
	end
end

function puzzle_select()
	local til = tile_facing()
	local stan = tile_standing()
	if state == 1 then
		if (til >= 6 and til <= 8) or (til >= 22 and til <= 24) then
			if(d == true) then
				show_dialog({"The flowers are\nblooming."}, 55, 107)
			elseif(d == false) then
				show_dialog({"There's a vase of\nflowers on the\ntable.", "They look like\nthey could use\nsome water."},55,107)
			end
			if(curr_key_item == 147) then
				show_dialog({"You poured the\nwater into the\nvase.", "the flowers are\nblooming..!"},55,107)
			end
		elseif(stan == 35 or stan == 51) then
			--show_dialog({"this would be a\n"..
			--"puzzle"},55,115)
			show_dialog({"it's an old\nmirror.", "on your reflection\nyou see a nametag.",
			"'exp: 438'.", "what could that\nmean..?"}, 55, 110)
		end
	elseif state == 2 then
		if til >= 112 and til <= 117 then
			state = 8
		end
		if til >= 84 and til <= 86 then
			show_dialog({"there's something\nwritten on the\nchalkboard",
			"\"I HAVE CRAFTED AN\nEXPLOSIVE CHEMICAL\nLIKE NO OTHER!\"",
			"\"IT EXPLODES WHEN\nEXPOSED TO JUST\nA LITLE HEAT!\"",
			"\"IT'S definitely\nnot DARK PURPLE!\"\n",
			"\"I'VE DECIDED TO\nCALL IT 'friend.'\"\n",
			"\"I'M THE ONLY ONE\nTHAT KNOWS HOW TO\nMAKE friend!\""},55,107)
		--chalkboard
		end
		if til==64 or til==65 then
		--dark blue
			show_dialog({"there are beakers\nlabeled 'Freedom'\non the table"},55,107)
		end
		if til==80 or til==81 then
			show_dialog({"there are beakers\nlabeled 'Renegade'\non the table"},55,107)
		--red
		end
		if til==66 or til==67 then
			show_dialog({"there are flasks\nlabeled 'Illusion'\non the table"},55,107)
		--green
		end
		if til==82 or til==83 then
			show_dialog({"there are flasks\nlabeled 'Entropy'\non the table"},55,107)
		--light blue
		end
		if til==96 or til==97 then
			show_dialog({"there are beakers\nlabeled 'Nature'\non the table"},55,107)
		--indigo
		end
		if til==98 or til==99 then
			show_dialog({"there are flasks\nlabeled 'Death'\non the table"},55,107)
		--yellow
		end
	elseif state == 3 then
		if til == 153 then
			show_dialog({"this would be a\n"..
			"puzzle"},55,110)
		elseif til==136 or til==140 then
			if c then
				show_dialog({"you have already\nsolved this puzzle\n"},55,110)
			else
				state = 9
			end
		end
	elseif state == 4 then
		if til == 209 then
			if not lights then
				state = 7
			else
				show_dialog({"power is already\nrestored."},55,110)
			end
		elseif til == 210 or til== 211 then
			if curr_key_item==120 then
				show_dialog({"you toss the\nchemical into\nthe stove","causing the stove\nto explode!"},55,105)
				explode(80,12,3,80)
				sfx(0)
				mechroom[1][5] =206
				mechroom[1][6] =207
				mechroom[2][5] =222
				mechroom[2][6] =223
				mechroom[3][5] =238
				mechroom[3][6] =239
				explo =true
				curr_key_item=-1
			elseif curr_key_item==104 then
				show_dialog({"you toss the\nchemical into\nthe stove","nothing happens."},55,105)
				curr_key_item=-1
			end
		end
	end
end

function add_inventory()
	if state == 1 and d == false then
		if (tile_facing() >= 6 and tile_facing() <= 8) or (tile_facing() >= 22 and tile_facing() <= 24) then
			main_room_update()
			add(collected_pieces,124)
			--curr_key_item = -1
			d = true
			sfx(1)
		end
	elseif state == 3 and (tile_facing()==143 or tile_facing()==145) and not jug_taken and curr_key_item==-1 then
			curr_key_item=149
			jug_taken=true
	elseif state == 4 and explo and not j then
		if tile_facing() == 222 or tile_facing() == 223  then
			add(collected_pieces,127)
			j = true
			sfx(1)
		end
	end
end

function win_check()
	if tile_facing() == 36 or tile_facing() == 37 then
		if z and j and d and c then
			set = time()
			state = 5
		elseif z or j or d or c then
			show_dialog({"you do not yet\nhave all of the\npieces."},55,107)
		else
			show_dialog({"it's locked.", "you can see four\nimprints where\npanels are missing",
			"you'll need to\nfind all of them\nto escape."},55,107)
		end
	end
end

function game_timer()
	if timer_ticks == 30 then
		if timer_secs == 0 then
			timer_mins -= 1
		timer_secs = 59
		else
			timer_secs -= 1
		end
		timer_ticks = 0
	else
		timer_ticks +=1
	end

	if timer_secs <10 then
	 game_time = timer_mins..":0"..timer_secs
	else
		game_time = timer_mins..":"..timer_secs
	end

	return game_time
end

--use this function to show dialog messages to the player (make sure messages is a non-empty table of strings)
function show_dialog(messages,x,y)
	dialog_messages=messages
	print_x=x
	print_y=y
	dialog_counter=0
	dialog_curr_char=1
	dialog_state=1
end

function dialog_update()
	if dialog_curr_char<#dialog_messages[dialog_state] then
		if dialog_counter==1 then
			dialog_counter=0
			dialog_curr_char+=1
			sfx(10)
		end
	elseif btnp(5) then
		dialog_counter=0
		if dialog_state<#dialog_messages then
			dialog_state+=1
			dialog_curr_char=1
		else
			dialog_state=0
		end
	end
	dialog_counter+=1
end

function dialog_draw()
	local button=""
	if dialog_curr_char==#dialog_messages[dialog_state] then
	 if(dialog_counter>10) button=" ❎"
	 if(dialog_counter>20) dialog_counter=0
	end
	print(sub(dialog_messages[dialog_state],1,dialog_curr_char)..button,print_x,print_y,7)
end

function small_font(x)
	lowered =""

	for i = 1, #x do
		local a = sub(x,i,i)
			if a>="a" and a<="z" then
    for j=1,26 do
      if a==sub("abcdefghijklmnopqrstuvwxyz",j,j) then
        a=sub("\65\66\67\68\69\70\71\72\73\74\75\76\77\78\79\80\81\82\83\84\85\86\87\88\89\90\91\92",j,j)
        break
      end
    end
   end
  lowered = lowered..a
	end
	return lowered
end

-->8
--intro/outtro code--
function intro_draw()
	cls()
	print("the next experiment",hcenter("the next experiment"),10,8)
	print("you have been taken and are now ",hcenter("you have been taken and are now"),30,6)
	print("trapped inside a dark castle",hcenter("trapped	inside a dark castle"),40,6)
	print("figure out how to escape",hcenter("figure out how to escape"),50,6)
	print("press ❎ to begin",hcenter("press ❎ to begin"),100,6)
	pal(5,0)
	pal(0,5)
	i = 112
	a = 1
	x = 0
	while a <= 18 do
		spr(i,x,120)
		x+= 8
		i += 1
		if i > 116 then
			i = 112
		end
		a+= 1
	end
	pal(5,5)
	pal(0,0)
end

winroom = {
	{1,2,1,2,1,2,1,4,5,2,1,2,1,2,1,2},
	{17,18,17,18,17,18,17,20,21,18,17,18,17,18,17,18},
	{3,3,3,3,3,3,3,36,37,3,3,3,3,3,3,3},
	{19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19},
	{19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19},
	{19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19},
	{102,19,19,19,19,19,19,19,19,19,19,19,19,19,19,101},
	{19,19,19,19,19,19,19,6,7,8,19,19,19,19,19,19},
	{19,19,19,19,19,19,19,22,23,24,19,19,19,19,19,19},
	{19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19},
	{35,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19},
	{51,19,19,19,19,19,19,19,19,19,19,19,19,19,19,25},
	{19,19,19,19,19,19,19,19,19,19,19,19,38,39,40,41},
	{19,19,19,19,19,19,19,19,19,19,19,19,54,55,56,41},
	{19,19,19,19,19,19,19,33,34,19,19,19,19,19,19,57},
	{19,19,19,19,19,19,19,49,50,19,19,19,19,19,19,19}
}
function win_draw()
	if not fail then
		if time()-set <= 6 then
			win_animation()
			draw_room(winroom)
			print(runtime,2,2,7)
		else
			cls(5)
			if final then
				--final--
				con_animation()
			end
			if (time()-set >= 12) music(-1,2000)
			print("time left: "..runtime,hcenter("time left: "..runtime),70,6)
			print("you have escaped",hcenter("you have escaped"),80,6)
			print("press ❎ to play again",hcenter("press ❎ to play again"),90,6)

			i = 112
			a = 1
			x = 0
			while a <= 18 do
				spr(i,x,120)
				x+= 8
				i += 1
				if i > 116 then
					i = 112
				end
				a+= 1
			end
		end
	else
		cls(0)
		print("you have failed",hcenter("you have failed"),60,8)
		print("press ❎ to try again",hcenter("press ❎ to try again"),70,8)

		for i=2,15 do
			pal(i,1)
		end
		pal(1,0)
		pal(5,0)
		pal(2,0)

		i = 112
		a = 1
		x = 0
		while a <= 18 do
			spr(i,x,120)
			x+= 8
			i += 1
			if i > 116 then
				i = 112
			end
			a+= 1
		end
		pal()
		palt(0,false)
		palt(14,true)
	end
end

function win_animation()
	if time()-set >= 1 then
		winroom[1][8] = 240
	end
	if time()-set >= 2 then
		winroom[1][9] = 241
	end
	if time()-set >= 3 then
		winroom[3][8] = 242
	end
	if time()-set >= 4 then
		winroom[3][9] = 243
	end

	if time()-set >= 5 then
		winroom[1][8] = 226
		winroom[1][9] = 227
		winroom[2][8] = 228
		winroom[2][9] = 229
		winroom[3][8] = 244
		winroom[3][9] = 245
	end
end

function con_animation()
	if (time()-set >= 6) print(small_font("you escaped my lab!\nthis is fantastic!"),55,5,3)
	if (time()-set >= 7) print(".",1,20,12)
	if (time()-set >= 7.4) print(".",5,20,12)
	if (time()-set >= 7.8) print(".",9,20,12)
	if (time()-set >= 8) print(small_font("this means you are\nsmart enough to be\nmy friend and stay\nhere forever!"), 55,30,3)

end


function hcenter(s)
  return 64-#s*2
end
__gfx__
000000001111111dd111111122222222222222222222222255599999999999999999955500000000000000000000000000000000000000000000000000000000
0000000011dd11111111dd1124442444244444444444444255922222222222222222295500000000000000000000000000000000000000000000000000000000
007007001d11d111111d11d124442444245225444452254259244444444444444444429500000000000000000000000000000000000000000000000000000000
0007700011dd11111111dd1124442444242552444425524292444444444444444444442900000000000000000000000000000000000000000000000000000000
000770001111111dd111111124442444242552444425524292444444444444444444442900000000000000000000000000000000000000000000000000000000
00700700111111d11d11111124442444245225444452254292444444444444444444442900000000000000000000000000000000000000000000000000000000
0000000011dd111dd111dd1124442444244444444444444292444444444444444444442900000000000000000000000000000000000000000000000000000000
000000001d11d111111d11d122222222244444444444444292444444444444444444442900000000000000000000000000000000000000000000000000000000
0000000011dd11111111dd1155555555244444444444444292444444444444444444442900000000000000000000000000000000000000000000000000000000
000000001111111dd111111155555555244444444444444292444444444444444444442900000000000000000000000000000000000000000000000000000000
00000000111111d11d11111155555555244444944944444292244444444444444444422900000000000000000000000000000000000000000000000000000000
0000000011dd111dd111dd1155555555244449444494444259924444444444444444299500000000000000000000000000000000000000000000000000000000
000000001d11d111111d11d155555555244449444494444255599999999999999999955500000000000000000000000000000000000000000000000000000000
0000000011dd11111111dd1155555555244449444494444255552222222222222222555500000000000000000000000000000000000000000000000000000000
000000001111111dd111111155555555244444944944444255552244444444444422555500000000000000000000000000000000000000000000000000000000
00000000111111d11d11111155555555244444444444444255522244455555544422255500000000000000000000000000000000000000000000000000000000
000000000000000000000000555555552444444444444442eeeeeeeeee8eee8eee8eee8e00000000000000000000000000000000000000000000000000000000
000000000555555555555550555555552444444444444442ee8eee8ee88eee88e828e88800000000000000000000000000000000000000000000000000000000
000000000555555555555550455555552452254444522542eee3e3eeeee3e3eeee83e38e00000000000000000000000000000000000000000000000000000000
000000000555555555555550465555552425524444255242ee6637eeee6637eeee6637ee00000000000000000000000000000000000000000000000000000000
000000000000000000000000465555552425524444255242ee6367eeee6367eeee6367ee00000000000000000000000000000000000000000000000000000000
000000000011111111111100475555552452254444522542ee3666eeeecccceeeeccccee00000000000000000000000000000000000000000000000000000000
000000000055555555555500465555552444444444444442ee7666eeee7ccceeee7cccee00000000000000000000000000000000000000000000000000000000
0000000000555555555555004655555522222222222222228eeddee88eeddee88eeddee800000000000000000000000000000000000000000000000000000000
00000000000000000000000047555555eeeeeeee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000010111111111101047555555eeee87ee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000010555555555501046555555ee88887e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000010000000000001046555555ee8888870000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000010011111111001045555555ee88887e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000001011111111010055555555eeee87ee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000055555555eeeeeeee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000055555555eeeeeeee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
5555555555555555555555555555555599999999999999999999999900000000000000001177eeee1177eeee1177eeeeee4444eeee4444eee44444eeee44444e
5557775555777555555575555557555599999999999999999999999900000000000000001177eeee11771eee11771eeee444444ee444444ee444444ee444444e
5557775555777555555575555557555599000000000000000000009900000000000000001177eeee1177eeee1177e1eee4ffff4ee4ffff4eeffff44ee44ffffe
5551115555111555555bbb5555bbb5559900000000000000000000990010111111110100eeeeeeeeeeeeeeeeeeeee1eeef0ff0feeffffffeef0ffffeeffff0fe
5551115555111555555bbb5555bbb5559900070700000700077000990100111111110010eeee777eeeee777eeeee777eeffffffeeffffffeefff888ee888fffe
550000000000005555000000000000559900007070007070000700990100000000000010eeee766eeeee766eeeee766eed8878deed8888deeee8788ee8878eee
559999999999995555999999999999559900000000000000000000990105555555555010eeee777eeeee777eeeee777eee8888eeee8888eeeee8d88ee88d8eee
559555555555595555955555555559559900000000000000000000990101111111111010eeee777eeeee777eeeee777eee6ee6eeee6ee6eeee666eeeeee666ee
5555555555555555555555555555555599000707000070000770009900000000000000001177eeee1177eeee1177eeeeee4444eeee4444eee44444eeee44444e
5557775555777555555575555557555599000070007007007000009900555555555555001177eeee11771eee11771eeee444444ee444444ee444444ee444444e
5557775555777555555575555557555599000000000000000000009900555555555555001177eeee1177eeee1177e1eee4ffff4ee4ffff4eeffff44ee44ffffe
5558885555888555555ccc5555ccc5559999999999999999999999990011111111111100eeeeeeeeeeeeeeeeeeeee1eeef0ff0feeffffffeef0ffffeeffff0fe
5558885555888555555ccc5555ccc5559999999999999999999999990000000000000000eeee777eeeee777eeeee777eeffffffeeffffffeefff888ee888fffe
550000000000005555000000000000559955555555555555555555990555555555555550eeee766eeeee766eeeee766eeed878deed888deeeee8788ee8878eee
559999999999995555999999999999559955555555555555555555990555555555555550eeee777eeeee777eeeee777eee8888eeee8888eeeed8d88ee88d8dee
559555555555595555955555555559559955555555555555555555990555555555555550eeee111eeeee111eeeee111eeeeee6eeeeeee6eeee66eeeeeeee66ee
5555555555555555555555555555555500000000556666666666665567777776eeeeeeee1177eeee1177eeee1177eeeeee4444eeee4444eee44444eeee44444e
5557775555777555555575555557555500777700567777777777776567777776ee7777ee1177eeee11771eee11771eeee444444ee444444ee444444ee444444e
5557775555777555555575555557555507777770677777777777777667777776ee7766ee1177eeee1177eeee1177e1eee4ffff4ee4ffff4eeffff44ee44ffffe
555ddd5555ddd555555aaa5555aaa55507777770677777777777777667777776ee7777eeeeeeeeeeeeeeeeeeeeeee1eeef0ff0feeffffffeef0ffffeeffff0fe
555ddd5555ddd555555aaa5555aaa55507777770677777777777777667777776eeffffeeeeee777eeeee777eeeee777eeffffffeeffffffeefff888ee888fffe
5500000000000055550000000000005507777770677777777777777667777776eeffffeeeeee766eeeee766eeeee766eed887deeeed888deeed8d88ee88d8dee
5599999999999955559999999999995500777700567777777777776556777765eeffffeeeeee111eeeee111eeeee111eee8888eeee8888eeeee8788ee8878eee
5595555555555955559555555555595500000000556666666666665555666655eeeeeeeeeeee111eeeee111eeeee111eee6eeeeeee6eeeeeeeee66eeee66eeee
5555555555555555555555555555555555555555555555557777777000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
5577755777555755557555777555755555557775555555557777777000000000ee7777eeeeeeeeeeeeeeeeeeeeeeeeeeee666eeeee6666eeee6666eeee6666ee
5577755777555755557555777555755575757665555665557777777000000000ee7766eeeeeeeeeeeeeeeeeeeeeeeeeeee6ee6eeeeeee6eeee6eeeeeeeee6eee
551115588855ccc55aaa55ddd55bbb5575757775555655557777777000000000ee7777eeeeeeeeeeeeeeeeeeeeeeeeeeee6ee6eeeeee6eeeee6eeeeeeeee6eee
551115588855ccc55aaa55ddd55bbb557575777556565655fffffff000000000ee2222eeeeee777eeeee777eeeee777eee6ee6eeeee6eeeeee6eeeeeeeee6eee
000000000000000000000000000000000000000000000000fffffff000000000ee2222eeeeee766eeeee766eeeee766eee6ee6eeee6eeeeeee6eeeeeee6e6eee
999999999999999999999999999999999999999999999999fffffff000000000ee2222eeeeee777eeeeefffeeeeefffeee666eeeee6666eeee6666eeee666eee
999999999999999999999999999999999999999999999999fffffff000000000eeeeeeeeeeee777eeeeefffeeeee111eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
444777455ff6666666666ff511111111111111111111111199999994111111116666666611111111588888888888888566666666444444455555455555555544
447797755ffffffffffffff51a1111a11a1111a11a1111a1999999641a1111a1777777771a1111a1588888888888888566666666444444452222455555554444
47777777588888888888888511a11a1114444444444444412922258411a11a117777776711a11a115888888888888885666666664444444a2552455555444444
4a77777a58888888888888854444444414444444444444412922666477777777777777674444444458888888888888857777777722222225bbbb455555444444
4999599a5888888888888885444444441ffffffffffffff12922666477777777777777674444444458448888888844857777776722222225bbbb455554444444
449555955888888888888885999999991ff7777777777ff1292225c46666666677777767999999945844dddddddd448577775555222222252222255554444444
444999455888888888888885999999991ff7777777777ff1292225646006600677777777999999945244dddddddd442577779767222222252bbb255554444444
444444455888888888888885999999994ff7777777777ff4299999946006600677777777999999945244dddddddd4425777777775dd5dd552555255554444444
4455555554444444444444455555555599999999eeeeeeee59999999600660061111111111111111000000007777777700000000000000000000000000000000
4444555554444444444444455555555599999999eeeeeeee54444444666666661a1111a11a1111a104499aa07eeeeee700000000000000000000000000000000
4444445555444444444444555555555542222224eeeeeeee74444444dddddddd11a11a1111a11a1104499aa07eeeeee700000000000000000000000000000000
4444445555544444444455555555555542744724666666ee54444444d000000d111111111111111104499aa07eeeeee700000000000000000000000000000000
4444444555555444445555555555555542444424e6c6ee6e54444444d000000d11a11a1111a11a1104499aa07eeeeee700000000000000000000000000000000
44444445555555522555555555555555424444246ccc6e6e54444444d000000d1a1111a11a1111a104499aa07eeeeee700000000000000000000000000000000
444444455555522222255555555555554222222467cc66ee54444444d000000d111111111111111104499aa07eeeeee700000000000000000000000000000000
4444444555555222222555555555555522222222e666eeee55555555222222221111111144444444000000007777777700000000000000000000000000000000
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
1dd1dd1d1dd1dd1dd1552d2dd2dd201155555555555555555533335555555555555335555555555555555555555335555553355533333333d1dd1d1dd1dd1d1d
111111111111111111552222222200005555555555535555533333355555555555533555555555555555555555533555555335553eeeeee31111111111111111
d1dd1dd1d1dd1dd1dd55d2d2dd21101055555b555555355b333333335555555555533555555555555555555555533555555335553eeeeee3dd1dd1d1dd1dd1d1
111111111111111111552222220000005555553b553b535b333333333333333355533555333335555553333355533333333335553eeeeee31111111111111111
1d1dd1dd1555555d1d55dd2d2d10101155553555b5553353333333333333333355533555333335555553333355533333333335553eeeeee31dd1dd1d1dd1dd1d
1111111115553351115555555555000055355355333b3b3b333333335555555555533555555335555553355555555555555555553eeeeee31111100000011111
d1d1dd1dd533555dd2555500005501105553353b33b33333533333355555555555533555555335555553355555555555555555553eeeeee3d1dd0000000d1dd1
1111111115558851122255000055000053b3bb33b33b3b3355333355555555555553355555533555555335555555555555555555333333331111000000001111
555555551588555dd2dd5555555511015dddddd5777777775588885555555555555885555555555555555555555885555558855588888888dd1000000000d1dd
555555551555cc512225555555555000dccccccd7eeeeee7588888855555555555588555555555555555555555588555555885558eeeeee81110000000000011
55555555d5cc5551dd25508888055010ddccccdd7eeeeee7888888885555555555588555555555555555555555588555555885558eeeeee81d0000000000001d
55555555155555512225588998855555d6dccd6d7eeeeee7888888888888888855588555888885555558888855588888888885558eeeeee81100000000000001
555555551d1dd1dd2dd5589999855555d66dd66d7eeeeee7888888888888888855588555888885555558888855588888888885558eeeeee8d10000000000000d
555555551111111122255555555550005d6666d57eeeeee7888888885555555555588555555885555558855555555555555555558eeeeee81000000000000001
55555555d1d1dd1dd2d55110101551105d6666d57eeeeee7588888855555555555588555555885555558855555555555555555558eeeeee81000000000000001
5555555511111111222550000005500055dddd557777777755888855555555555558855555588555555885555555555555555555888888880000000000000000
555229aaaa9222552222222002222222244444400444444255cccc5555555555555cc5555555555555555555555cc555555cc555cccccccc0505050500500050
555229aaa9922255244444400444444224444440044444425cccccc555555555555cc5555555555555555555555cc555555cc555ceeeeeec5055055005055005
25229aaa9922225524222740042227422444449009444442cccccccc55555555555cc5555555555555555555555cc555555cc555ceeeeeec5050050505500555
529999999222255524277240042777422444494004944442cccccccccccccccc555cc555ccccc555555ccccc555cccccccccc555ceeeeeec0505505555505005
522999292225555524277240042777422444494004944442cccccccccccccccc555cc555ccccc555555ccccc555cccccccccc555ceeeeeec5555555555555550
222922222555555524222740042227422444494004944442cccccccc55555555555cc555555cc555555cc5555555555555555555ceeeeeec5555555555555555
5522222255555555244444400444444224444490094444425cccccc555555555555cc555555cc555555cc5555555555555555555ceeeeeec5555555555555555
55255525555555552444444004444442244444400444444255cccc5555555555555cc555555cc555555cc5555555555555555555cccccccc5555555555555555
22222222222222222444444444444442244444400444444255999955555555555559955555555555555555555559955555599555999999990000000000000000
244444444444444224444444444444422444444004444442599999955555555555599555555555555555555555599555555995559eeeeee90000000000000000
242227444422274224222244442227422422224004222742999999995555555555599555555555555555555555599555555995559eeeeee90000000000000000
242772444427774224772744447727422477274004772742999999999999999955599555999995555559999955599999999995559eeeeee90000000000000000
242772444427774224772744447277422477274004727742999999999999999955599555999995555559999955599999999995559eeeeee90000000000000000
242227444422274224222744447222422422274004722242999999995555555555599555555995555559955555555555555555559eeeeee90000000000000000
244444444444444224444444444444422444444004444442599999955555555555599555555995555559955555555555555555559eeeeee90000000000000000
24444444444444422222222222222222222222200222222255999955555555555559955555599555555995555555555555555555999999990000000000000000
__gff__
0001010101010101010000000000000000010100010101010101000000000000000000000101000000010000000000000001010000000000000100000000000001010101010101010100000000000000010101010101010000000000000000000101010101000000000000000000000001010101010100000000000000000000
0101010101010101010101010101010101010100010101010101010101010101000000000000000000000000000000000000000000000000000000000000000001010101000000000000000000000101000101010100000000000000000001010000010101010000000000000000000001010101010100000000000000000000
__sfx__
010300003c6743a67436674326742d6642b66325663226631f6531d6531b653186531465312643106430e6430c6430a6330763306633056330462303623026250261501615006150061508600066000560004600
010600001425414255222542225527234272353823438235175001750017500175001750017500175001750017500175001750017500175001750017500175001750017500175001750017500175001750017500
013000000751007510075100751007510075100751007510075100751007510085100851008510085100851008510085100851008510085100751007510075100751007510075100751007510075100751007510
013000000c51010510115100c51010510115000c500105000c51010510115100c510105100000000000000000c51010510115100c510105100000000000000000c51010510115100c51010510000000000000000
013000000f50000000000000c5001551015510155101851018510185101c5101c5101d5101c5101c510185101751015510155101551015510185101a5101c5101c5101d5101c5101c51000000000000000000000
013000000000000000000000000021510215102151024510245102451028510285102951028510285102451023510215102151021510215102451026510285102851029510285102851000000000000000000000
0130000000000000000000017510175101a5101a5101c5101c5101d5101d5101f5101d5101d5101c5101a51018510175101751015510155101551014510145101a51017510155101451015510155101551000000
0130000000000000000000023510235102651026510285102851029510295102b510295102951028510265102451023510235102151021510215102051020510265102351021510205102151021510215102d500
013000001551015510175101751018510185101a5101a510185101851017510155101551017510185101551015510175101751018510175101751015510155101451014510115101051014510155101551000000
0130000021510215102351023510245102451026510265102451024510235102151021510235102451021510215102351023510245102351023510215102151020510205101d5101c51020510215102151000000
010300001852000500025000050002500005001150000500025000050002500005000050500505065050c505165051f5051b505155050d50507505005050050501505085050d5051f505155050c5050750509505
010600001420014200222002220027200272003820038200142001420022200222002720027200382003820014200142002220022200272002720038200382000020000200002000020000200002000020000200
__music__
01 02030405
00 02030607
02 02030809

>>>>>>> master
