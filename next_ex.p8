pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
--main functions--
--music from: https://youtu.be/7umg6zrieh8--
function _init()

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


	timer_mins = 18
	timer_secs = 0
	timer_ticks = 0

	curr_key_item=-1 --sprite number for current key item (-1 for no item)
	collected_pieces = {} --sprite numbers for collected puzzle pieces (letters)
	d =false
	j =false
	z =false
	c =false

	controls = false

	lights = false


	fail = false
	final_spr = 76

	--dialog stuff--
	dialog_state=0 --0 is not currently in dialog
	dialog_messages={} --dialog to show (manipulated through different functions)
	dialog_curr_char=1 --animating dialog
	dialog_counter=0 --animating dialog
	print_x=0
	print_y=0

--dialog that should display if the player interacts with the sprites listed
	item_dialogs = {
		{{3}, {"the wall is adorned\nwith some ominous", "paintings..."}},
		{{36, 37}, {"it's a massive\nlocked door.", "there appear to be\npanels missing.", "find them to\nescape!"}},
		{{35, 51}, {"it's an old mirror.", "in your reflection","you see a nametag:","experiment 438\n"}},
		{{45,46,61,62}, {"it's a desk.","there's a dry quill\nand an ink well."}},
		{{13,14,29,30}, {"the shelf is full\nof various books", "on different kinds\nof sciences...", "you don't see\nanything special."}},
		{{9,10,25,26}, {"there are many\ndifferent kinds", "of books on the\nshelf...","there seems to\nbe one missing."}},
		{{56, 142}, {"a simple chair.", "there's not much\nelse to say."}},
		{{128}, {"it's a lamp."}},
		{{129,130,138,139}, {"it's a very plain\nbed.", "there's nothing\nelse to see."}},
		{{136}, {"it's an old fridge.","there's nothing\ninside."}},
		{{148}, {"you search through\nthe cabinet...","but find nothing."}},
		{{151}, {"this oven likely\nhasn't been used","in a while."}},
		{{134, 150}, {"there's a sink...", "the water is\nmiraculously still running."}},
		{{212}, {"the bucket is filled with old soap water."}},
		{{196,197}, {"something vile is\ngrowing here.", "you don't want\nto touch it."}},
		{{222,223}, {"there's a big hole\nin the wall caused", "by the explosion\nyou created."}},
		{{143, 145}, {"an old table.", "there's nothing\non it."}},
		{{141}, {"there's a side\ntable with a", "lamp on it."}}
	}

	mech_room_init()
	lab_room_init()
	serv_room_init()
	mainroom_init()

	explo = false

	dropped_items={
	{4,1,8,212}}

	prompt = false
	use_item = false
	lock_sound=false
end

function _update()
	if timer_mins <= 0 and timer_secs <= 0 then
		fail = true
		dialog_state = 0
		set = time()
		state= 5
	end

	if dialog_state==0 then
		if d_done and not puzzle_win and not ex then
			state=7
		end
		if state == 7 then
			laser_con()
		elseif state == 8 then
			chem_con()
		elseif state == 9 then
			lock_con()
		elseif btnp(5) then
			if not controls and state < 5 then
				controls =true
				show_dialog({"it is too dark\nto see anything","you need to\nrestore the power"},52,113,7)
			end
			if state == 5 and(fail or time() - set > 6)  then
				state = 6
				_init()
			elseif state == 6 then
				state = 1
				start_time = time()
			end
		end
	end

	if(state < 5 and dialog_state==0) then
		if controls then
		 player_move()
		end
		if btnp(5)and not p_moving then
			if not lights  and controls then
				lights_dialog()
			else
				win_check()
				use_id()
				add_inventory()
				puzzle_select()
				pick_up()
			end
		end
	end
	if btnp(4)and not p_moving then
		if curr_key_item!=-1 then
			drop_item()
		end
	end
	if(dialog_state>0) dialog_update()

	exp_update()
	flowers_update()
	trap_door_update()
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
			if(not controls) print("⬅️⬇️⬆️➡️:move\n❎:interact\nz:drop item",75,108,7)
			if(dialog_state>0) dialog_draw()
		end
		runtime = game_timer()
		rectfill(0,0,22,8,1)
	 rect(0,0,22,8,0)
		if timer_mins <= 0 then
			print(runtime,2,2,8)
		else
			print(runtime,2,2,7)
		end
	end
	exp_draw()
	draw_flowers()
	arrow_check()
end
-->8
--destiny--
--main entryway, 16x16--
function mainroom_init()

	mainroom = {
		{1,2,1,2,1,2,1,4,5,2,1,2,1,2,1,2},
		{17,18,17,18,17,18,17,20,21,18,17,18,17,18,17,18},
		{3,3,3,3,3,3,3,36,37,3,3,3,3,3,3,3},
		{19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19},
		{19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19},
		{19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19},
		{102,19,19,19,19,19,19,6,7,8,19,19,19,19,19,101},
		{19,19,19,19,19,19,19,22,23,24,19,19,19,19,19,19},
		{19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19},
		{19,19,19,19,19,19,19,19,19,19,19,19,19,19,19,19},
		{35,19,19,19,19,19,19,19,19,19,19,19,13,14,9,10},
		{51,19,19,19,19,19,19,19,19,19,19,19,29,30,25,26},
		{45,46,19,19,19,19,19,19,19,19,19,19,19,19,19,19},
		{61,62,56,19,19,19,19,42,44,19,19,19,19,19,19,19},
	}
flowers_solved = false
flower_draw = true
flower_spr = 38
trap_solved = false
stairs_shown = false
book_taken = false
dilay=20
end

function main_room_draw()
	cls(0)
	draw_room(mainroom)
	if not book_taken then
	 if not lights then
		 for i=2,15 do
			 pal(i,1)
		 end
		 pal(1,0)
		 pal(5,0)
		 pal(2,0)
	 end
	end
	 spr(flower_spr,64-((#mainroom[1]/2)*8)+flr(8*(9-1)),flr(8*(7-1)))
	 spr(54, 40, 6)
	 spr(55, 80, 6)
	 spr(57, 104, 4)
	 spr(58, 112, 4)
	 spr(41, 20, 6)
	 if not book_taken then
	 spr(59, 1, 100)
  end
	 pal()
	 palt(0,false)
	 palt(14,true)
end

function flowers_update()
	if not flower_draw then
		dilay -= 1
		if dilay <0 then
			flower_spr += 1
			dilay=20
		end
	end
	if (flower_spr == 40) flower_draw = true
end

function draw_flowers()
	if not flower_draw then
		spr(flower_spr,64-((#mainroom[1]/2)*8)+flr(8*(9-1)),flr(8*(7-1)))
	end
end

function trap_door_update()
	if trap_solved and not stairs_shown then
		if time()-trap_timer >= 3 and time()-trap_timer <3.5 then
			for i=1,#dropped_items do
				if dropped_items[i][1]== 1 then
					if dropped_items[i][2]==8 or dropped_items[i][2]==9 then
						if dropped_items[i][3]== 13 then
								dropped_items[i][3] = 12
								mainroom[dropped_items[i][3]][dropped_items[i][2]] =254
						end
					end
				end
			end

			mainroom[14][8] = 49
			mainroom[14][9] = 50
			mainroom[13][8] = 42
			mainroom[13][9] = 44
		elseif time()-trap_timer >= 3.5 and time()-trap_timer <4 then
			for i=1,#dropped_items do
				if dropped_items[i][1]== 1 then
					if dropped_items[i][2]==8 or dropped_items[i][2]==9 then
						if dropped_items[i][3]== 12 then
								dropped_items[i][3] = 11
								mainroom[dropped_items[i][3]][dropped_items[i][2]] =254
						end
					end
				end
			end


			mainroom[13][8] = 33
			mainroom[13][9] = 34
			mainroom[12][8] = 42
			mainroom[12][9] = 44
			stairs_shown = true
		end
	end
end



-->8
--jimbob--
function lab_room_init()
	labroom={
	{100,100,100,71,72,100,100,100,100,100,100,100},
	{100,100,100,87,88,68,69,70,100,100,100,100},
	{19,19,19,19,19,84,85,86,19,19,19,19},
	{19,19,19,19,19,19,19,19,19,19,19,19},
	{19,19,19,19,19,19,19,19,19,19,19,19},
	{19,19,19,64,65,19,19,82,83,19,19,19},
	{19,19,19,19,19,19,19,19,19,19,19,19},
	{19,19,19,66,67,19,19,80,81,19,19,19},
	{19,19,19,19,19,19,19,19,19,19,19,19},
	{19,19,19,96,97,19,19,98,99,19,19,19},
	{19,19,19,19,19,19,19,19,19,19,19,19},
	{19,19,19,112,113,114,115,116,117,19,19,19},
	{19,19,19,19,19,19,19,19,19,19,19,19},
	{19,19,19,19,19,19,19,19,19,19,19,19}}

	chem_selector=1
	chem_colors={1,8,12,10,13,11}
	chem_sol={1,8,11,12,13,10} --numbers represent colors of chemicals (dark blue,red,green,light blue,light indigo,yellow)
	chem_mix={}
	chem_anim=0 --for animating chemical puzzle
	sel_color=0 --selected color for animating
	chem_puzzle_intro=false
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
				return
			end
		else
			d_sel=0
			if(btnp(2)) d_sel-=1
			if(btnp(3)) d_sel+=1
			chem_selector+=d_sel
			if(chem_selector<1) chem_selector=6
			if(chem_selector>6) chem_selector=1
			if btnp(5) then
				sel_color=chem_colors[chem_selector]
			end
			if(btn(0)) chem_mix={}
			if(btn(4)) then
				sel_color=0
				chem_anim=0
				chem_selector=-1
				state=2
			end
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
	rect(8,104,120,127,7)
	print("try to mix the chemicals in\nthe correct order\n⬆️⬇️:change color ❎:select",10,107,7)
	for i=1,6 do
		pal(15,chem_colors[i])
		spr(118,12,12*i)
	end
	pal(15,15)
	rect(9,12*(chem_selector)-3,21,12*(chem_selector)+10,10)
	print("⬅️:reset",9,84,7)
	print("z:quit",9,96,7)
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
--room 3
--puzzle 9
function serv_room_init()
	num={0,0,0}
	pad_sel=1

servroom= {
	{152,152,152,152,152,152,152,152,152,152,152},
	{132,133,153,153,153,131,135,131,140,131,137},
	{129,130,147,208,208,148,151,148,136,148,134},
	{138,139,208,208,208,208,208,208,208,208,150},
	{208,208,208,208,208,208,208,208,208,208,208},
	{128,208,208,208,143,144,208,208,208,208,208},
	{141,208,208,208,145,146,142,208,208,208,208},
	{102,208,208,208,208,208,208,208,208,208,208}}

	jug_taken=false

	pad_lock_prompt=false

	lock_top = false
	timer_s = false

end

function serv_room_draw()
	cls()
	draw_room(servroom)
	if(not jug_taken) then
		if lights then
			spr(157,52,40)
		else
			for i=2,15 do
				pal(i,1)
			end
			pal(1,0)
			pal(5,0)
			pal(2,0)
			spr(157,52,40)
			pal()
			palt(0,false)
			palt(14,true)
		end
	end
end


function lock_draw()
	cls()

	if not lock_top then
 	sspr(112,72,8,8,43,0,40,35)
 else
 	sspr(120,72,8,8,43,0,40,35)
 end
 sspr(80,72,8,8,36,32,54,17)
 sspr(80,72,8,8,36,47,54,17)
 sspr(80,72,8,8,36,62,54,17)

	print(num[1],62,38,0)
	print(num[2],62,54,0)
	print(num[3],62,68,0)

	if pad_sel==1 then
		sspr(88,72,8,8,40,32,45,17)
	elseif pad_sel==2 then
		sspr(88,72,8,8,40,47,45,17)
	elseif pad_sel==3 then
		sspr(88,72,8,8,40,62,45,17)
	end

	palt(14,true)

	cons()
end

function lock_con()
	if not lock_top then
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
	end
	if lock_solve() and not timer_s then
		timer_s = true
		lock_top = true
		sfx(12)
		solved_t = time()
	elseif lock_solve() and timer_s then
		if time()-solved_t>= 1.5 then
			state=3
			add(collected_pieces,126)

			c = true
			sfx(1)
			servroom[3][3]=156
			show_dialog({"you recieved a\ndoor panel"},52,112,7)
		end
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
	"⬅️⬇️⬆️➡️: change numbers\n"..
	"enter the correct number\n"..
	"to unlock the chest.\n\n"..
	"z: exit",4,88,7)
end
-->8
--zoe--
function mech_room_init()
	sel = {}
	sel.color = 213
	sel.x = 1
	sel.y = 1
	sel.dir = "none"

	exp= {}
	for i = 1, 100 do
	add(exp,{x=0,y=0,dx=0,dy=0,r=0,m=0,a=false})
	end


	puzzle_win= false
	d_done =false
	ex = false
	mechroom = {
	{192,192,193,192,194,195},
	{192,192,209,192,210,211},
	{208,208,208,208,224,225},
	{208,208,208,208,208,208},
	{208,208,208,208,208,101},
	{208,208,208,208,208,208},
	{208,208,208,208,208,208},
	{254,208,208,208,196,197}}

	laser_puz = {
	{208,208,208,208,208,208,208},
	{176,208,208,208,208,208,208},
	{208,208,246,208,208,208,208},
	{208,208,208,208,246,208,208},
	{208,208,230,208,214,208,208},
	{198,214,208,208,230,198,208},
	{176,208,208,208,208,208,208},
	{255}}

	puz_ans = {
	{180,177,177,177,177,177,179},
	{176,202,199,199,199,201,178},
	{202,204,246,247,249,200,178},
	{200,218,215,217,246,200,178},
	{200,216,230,219,214,200,178},
	{198,214,235,231,230,198,178},
	{176,177,177,177,177,177,182},
	{255}}

	laser_reset = {
	{208,208,208,208,208,208,208},
	{176,208,208,208,208,208,208},
	{208,208,246,208,208,208,208},
	{208,208,208,208,246,208,208},
	{208,208,230,208,214,208,208},
	{198,214,208,208,230,198,208},
	{176,208,208,208,208,208,208},
	{255}}

end

function mech_room_draw()
	cls()
	draw_room(mechroom)

	if (explo and not j) spr(127,(64-((#mechroom[1]/2)*8)+36),4)
end

function laser_draw()
	cls()
	for i=3,12 do
		if i != 7 then
			pal(i,i+128,1)
		end
	end
	x =64-((#laser_puz[1]/2)*8)
 y = 0
 for i=1,#laser_puz do
 	for j=1,#laser_puz[i] do
			spr(laser_puz[i][j],x,y)
 		x+= 8
 	end
 	x =64-((#laser_puz[1]/2)*8)
 	y+= 8
 end
 palt(0,false)
	palt(14,true)
	rectfill(0,0,22,8,1)
	rect(0,0,22,8,0)
	spr(sel.color,64-((#laser_puz[1]/2)*8)+flr(8*(sel.x-1)),(8*(sel.y-1)))
	draw_cons()
end

function draw_cons()
	rect(2,74,127,127,7)
	print(
	"❎: select / deselect\n"..
	"⬅️⬇️⬆️➡️: move\n"..
	"  : reset\n\n"..
	"connect wires "..
	"to restore power\n\n"..
	"z: exit",4,78,7)
	spr(255,4,89)
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
			show_dialog({"you recieved a\ndoor panel"},52,112,7)
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
			show_dialog({"you recieved a\ndoor panel"},52,112,7)
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
			show_dialog({"you recieved a\ndoor panel"},52,112,7)
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
			show_dialog({"you recieved a\ndoor panel"},52,112,7)
		else
			lights = false
		end
	end
	if btnp(4) then
		state = 4
		ex=true
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
		elseif laser_puz[sel.y][sel.x]== 176 then
			if sel.color != 183 then
				sel.color = 183
			end
		elseif laser_puz[sel.y][sel.x]== 255 then
			puz_reset()
		end
	end
end

function wall_check(x,y,l)
	if (y<1 or y>#l) return true
	if (x<1 or x>#l[y]) return true
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
	elseif sel.color == 183 then
		lr =177
	end
	ud = lr+1
	ld = lr+2
	rd = lr+3
	ru = lr+4
	lu = lr+5

	if  l[sel.y][sel.x]!= 255 and l[sel.y][sel.x]!= 214 and l[sel.y][sel.x]!= 198 and l[sel.y][sel.x]!= 246 and  l[sel.y][sel.x]!= 230 and l[sel.y][sel.x]!= 176 then
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
 if num_cor == #puz_ans*#puz_ans[1] then
 	lights = true
		add(collected_pieces,125)
		z= true
		sfx(1)
		puzzle_win = true
 	return true
 else
 	return false
 end
end

function puz_reset()
	x =64-((#laser_puz[1]/2)*8)
 y = 0
 for i=1,#laser_puz do
 	for j=1,#laser_puz[1] do
			laser_puz[i][j] = laser_reset[i][j]
 	end
 	x =64-((#laser_puz[1]/2)*8)
 	y+= 8
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
			if state == 4 and i<3 and not lights then
				if j<5 then
					pal(5,5)
				end
			end
			spr(room[i][j],x,y)
 		x+= 8
 	end
 	x =64-((#room[1]/2)*8)
 	y+= 8
 end
 if dropped_items != nil then
 	for i=1,#dropped_items do
 		if dropped_items[i][1] == state then
 			spr(dropped_items[i][4],64-((#room[1]/2)*8)+flr(8*(dropped_items[i][2]-1)),flr(8*(dropped_items[i][3]-1)))
 		end
 	end
 end
 pal()
 palt(0,false)
	palt(14,true)



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
				p_x=6
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
			p_y=14
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
				if(flowers_solved == true) then
				show_dialog({"the flowers\nhave bloomed."},52,115)
			elseif not flowers_solved and curr_key_item == 149 and use_item then
				ctime = time()
				flower_draw = false
				flowers_solved = true
				add(collected_pieces,124)
				sfx(1)
				show_dialog({"you recieved a\ndoor panel"},52,112,7)
				curr_key_item = -1
				use_item = false
				d = true
			elseif not flowers_solved and curr_key_item == 212 and use_item then
				show_dialog({"the bucket is\nheavy","you spill the soapy\nmop water\neverywhere...\n","except in the vase\n"},52,115)
				curr_key_item = -1
				use_item =false
			elseif use_item then
				show_dialog({"this item doesn't\ndo anything."},55,115,7)
				use_item = false
			elseif not flowers_solved and curr_key_item != -1 then
				show_dialog({"there's a vase of\ndried flowers", "on the table.", "they could use\nsome water.","use your item?\nx:yes\tz:no"},52,115)
				item_prompt()
			elseif not flowers_solved and curr_key_item == -1 then
				show_dialog({"there's a vase of\ndried flowers", "on the table.", "they could use\nsome water."},52,115)
			end
		elseif(stan == 35 or stan == 51) then
		show_dialog({"it's an old\nmirror.", "on your reflection\n","you see a nametag:\n",
		"experiment #438"}, 55, 115)
		--book puzzle
	elseif(til == 9 or til == 10 or til == 25 or til == 26) then
			if (trap_solved == true) then
				show_dialog({"the books are\nall in place."}, 55, 115)
			elseif not trap_solved and curr_key_item == 59 and use_item then
				trap_solved = true
				sfx(1)
				show_dialog({"you placed the\nbook in the empty", "slot...", "revealing a trap\ndoor!"}, 55, 115)
				curr_key_item = -1
				use_item = false
				trap_timer = time()
			elseif use_item then
				show_dialog({"this item doesn't\ndo anything."},55,115,7)
				use_item = false
			elseif not trap_solved and curr_key_item != -1 then
				show_dialog({"there are many\ndifferent kinds", "of books on the\nshelf...","there seems to\nbe one missing.","use your item?\nx:yes\tz:no"},52,115)
				item_prompt()
			elseif not trap_solved and curr_key_item== -1 then
				show_dialog({"there are many\ndifferent kinds", "of books on the\nshelf...","there seems to\nbe one missing."},52,115)
			end

		end

	elseif state == 2 then
		if til >= 112 and til <= 117 then
			if not chem_puzzle_intro then
				show_dialog({"there are some\nchemicals on the\ntable.","there is also\nan empty beaker\nlabeled 'FRIEND'"},52,107)
				chem_puzzle_intro=true
			elseif curr_key_item~=-1 then
				show_dialog({"your hands are\nfull already."},52,110)
			elseif explo then
				show_dialog({"there are no\nempty beakers left"},52,110)
			else
				state=8
			end
		end
		if til >= 84 and til <= 86 then
			show_dialog({"there's something\nwritten on the","chalkboard...",
			small_font("\"i have crafted a\n fun, new\""),
			small_font("\"mixture like\nno other!\""),
			small_font("\"it explodes when\nexposed to just\""),
			small_font("\"a little heat.\""),
			small_font("\"the mixing order\nmust be exact.\"\n"),
			small_font("\"i've decided to\ncall it 'friend.'\"\n")},52,115)
		--chalkboard
		end
		if til==64 or til==65 then
		--dark blue
			show_dialog({"there are beakers\nlabeled 'FREEDOM'\non the table"},55,107)
		end
		if til==80 or til==81 then
			show_dialog({"there are beakers\nlabeled 'RENEGADE'\non the table"},55,107)
		--red
		end
		if til==66 or til==67 then
			show_dialog({"there are flasks\nlabeled 'ILLUSION'\non the table"},55,107)
		--green
		end
		if til==82 or til==83 then
			show_dialog({"there are flasks\nlabeled 'ENTROPY'\non the table"},55,107)
		--light blue
		end
		if til==96 or til==97 then
			show_dialog({"there are beakers\nlabeled 'NATURE'\non the table"},55,107)
		--indigo
		end
		if til==98 or til==99 then
			show_dialog({"there are flasks\nlabeled 'DEATH'\non the table"},55,107)
		--yellow
		end
	elseif state == 3 then
		if til==147  then
			if not lights then
				show_dialog({"it is too dark\nto see anything"},52,110)
			else
				if c then
					show_dialog({"the pad lock\nis open"},52,110)
				elseif not pad_lock_prompt then
					show_dialog({"there's a chest\nhere with a\npadlock on it.","it's labeled\n'experiment's\nitems'","you'll need the\ncombination to\nopen it."},52,105,7)
					pad_lock_prompt= true
				else
					state=9
				end
			end
		elseif til==156 then
			show_dialog({"the chest is\nunlocked","it contained a\ndoor panel","and nothing else\ninteresting."},52,110)
		elseif til== 134 or til== 150 then
			if curr_key_item==157 and use_item then
				show_dialog({"you filled\nthe water jug."},52,110)
				curr_key_item=149
				use_item =false
			elseif curr_key_item!=157 and use_item then
				show_dialog({"this item doesn't\ndo anything."},52,115,7)
				use_item = false
			elseif curr_key_item != -1 then
				show_dialog({"although it\nis quite rusty,","it appears that\nthe sink works.","use your item?\nx:yes\tz:no"},52,110)
				item_prompt()
			else
				show_dialog({"although it\nis quite rusty,","it appears that\nthe sink works."},52,110)
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
			if curr_key_item==120 and use_item then
				show_dialog({"you toss the\nchemical into\nthe stove","causing the stove\nto explode!"},52,105)
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
				use_item =false
			elseif curr_key_item==104 and use_item then
				show_dialog({"you toss the\nchemical into\nthe stove","nothing happens."},52,110)
				curr_key_item=-1
				use_item =false
			elseif curr_key_item!=104 and curr_key_item!=120  and use_item then
				show_dialog({"this item doesn't\ndo anything."},55,107,7)
				use_item = false
			elseif curr_key_item != -1 then
				show_dialog({"the stove has\na strong fire","it must be used to\nwarm the castle.","use your item?\nx:yes\tz:no"},55,110)
				item_prompt()
			else
				show_dialog({"the stove has\na strong fire","it must be used to\nwarm the castle."},55,110)
			end
		end
	end
end

function add_inventory()
	if state == 3 and (tile_facing()==143 or tile_facing()==145) and not jug_taken then
		if curr_key_item~=-1 then
			show_dialog({"your hands are\nfull already."},55,110)
		else
			show_dialog({"you received\nempty jug."},55,110)
			curr_key_item=157
			jug_taken=true
		end
	elseif state == 1 and (tile_standing() == 45 or tile_standing() == 46) and not book_taken then
			if curr_key_item~=-1 then
				show_dialog({"your hands are\nfull already."}, 55, 110)
			else
				--show_dialog({"it's a desk.","on it lays a worn\nbook,","a dry quill,", "and an ink well."}, 55, 110)
				show_dialog({"you picked up\nthe old book."},55,115)
				curr_key_item = 59
				book_taken = true
			end
	elseif state == 4  then

		if explo and not j and (tile_facing() == 222 or tile_facing() == 223)  then
			add(collected_pieces,127)
			j = true
			sfx(1)
			show_dialog({"you recieved a\ndoor panel."},52,112,7)
		end
	end
end

function win_check()
	if tile_facing() == 36 or tile_facing() == 37 then
		if z and j and d and c then
			set = time()
			state = 5
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
	elseif prompt and dialog_state==#dialog_messages then
		if btnp(4) then
			dialog_state = 0
			prompt=false
		end
		if btnp(5) then
			use_item = true
			dialog_state = 0
			prompt=false
			puzzle_select()
		end
	elseif btnp(5) then
		dialog_counter=0
		if dialog_state<#dialog_messages then
			dialog_state+=1
			dialog_curr_char=1
		else
			if tile_facing() >= 112 and tile_facing() <= 117 and dialog_state==2 then
				state=8
			elseif tile_facing() ==147 and dialog_state == 3 then
				state=9
			end
			dialog_state=0
		end
	end
	dialog_counter+=1
end

function dialog_draw()
	local button=""
	if dialog_curr_char==#dialog_messages[dialog_state] then
	 if(dialog_counter>10) button="❎"
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

function lights_dialog()
	if state == 4 then
		if tile_facing() == 209 and not puzzle_intro then
			if not d_done then
				show_dialog({"it appears to be\nan electrical\npanel","the wires are\ndisconnected."},52,110)
				d_done = true
			else
				state = 7
			end
		elseif tile_facing() == 210 or tile_facing()==211 then
			show_dialog({"the stove has\na strong fire","it must be used to\nwarm the castle."},52,110)
		else
			show_dialog({"it is too dark\nto see anything."},52,110)
		end
	else
		show_dialog({"it is too dark\nto see anything."},52,115)
	end
end


function arrow_check()
	local f = tile_facing()
	if (f>=101 and f<=103) or f == 33 or f == 34 or f == 87 or f == 88 then
		if state== 1 then
			if	f== 101 then
				spr(52,120,48)
			elseif f== 102 then
				spr(52,0,48,1,1,true,false)
			elseif f== 33 and lights then
				spr(53,56,103)
			elseif f== 34 and lights then
				spr(53,64,103)
			end
		elseif state==2 then
			if f == 87 then
				spr(53,39,2,1,1,false,true)
			elseif f == 88 then
				spr(53,48,2,1,1,false,true)
			end
		elseif state==4 then
				spr(52,80,32)
		elseif state==3 then
				spr(52,20,56,1,1,true,false)
		end
	end
end

function drop_item()
	local item ={}
	local room
	local playery,playerx=player_facing()
	if playerx !=-1 then
		if tile_facing() == 19 or tile_facing()== 208 then
			if state == 1 then
				room = mainroom
				add(item,1)
			elseif state == 2 then
				room = labroom
				add(item,2)
			elseif state == 3 then
			 room = servroom
				add(item,3)
			elseif state == 4 then
			 room= mechroom
				add(item,4)
			end

			add(item,playerx)
			add(item,playery)
			add(item,curr_key_item)

			room[playery][playerx] =254
			curr_key_item =-1

			add(dropped_items,item)
		end
	end
end

function pick_up()
	local playery,playerx=player_facing()
	if state == 1 then
		room = mainroom
		add(item,1)
	elseif state == 2 then
		room = labroom
		add(item,2)
	elseif state == 3 then
	 room = servroom
		add(item,3)
	elseif state == 4 then
	 room= mechroom
		add(item,4)
	end
	for i=1,#dropped_items do
		if dropped_items[i][1]==state then
			if playerx == dropped_items[i][2] then
				if playery ==dropped_items[i][3] then
					if curr_key_item == -1 then
						curr_key_item = dropped_items[i][4]
						room[playery][playerx] =208
						del(dropped_items,dropped_items[i])
						return
					end
				end
			end
		end
	end
end
--add it so it is a tile facing to put down and pick up

function player_facing()
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
		if(p_y+1>#room) return -1,-1
		return p_y+1,p_x
	elseif p_dir==77 then
		if(p_y-1<1) return -1,-1
		return p_y-1,p_x
	elseif p_dir==78 then
		if(p_x-1<1) return -1,-1
		return p_y,p_x-1
	elseif p_dir==79 then
		if(p_x+1>#room[1]) return -1,-1
		return p_y,p_x+1
	end
end

--found from this cart higininufo--
function large_print(t,x,y,c)
local f,a=0
  if (t==nil) print("")return
  if (c==nil) c=peek(24357)
  if (x==nil) x=peek(24358)
  if (y==nil) y=peek(24359)
  for i=1,#t do
    a=sub(t,i,i)
    if a=="@" then
      f=1-f
    else
      print(a,x,y,c)
      if f==1 then
        for j=0,4 do
          for k=0,2 do
            sset(k,j,pget(x+k,y+j))
          end
        end
        rectfill(x,y,x+2,y+4,0)
        color(c)
        sspr(0,0,3,5,x,y,6,5)
        x+=3
      end
      x+=4
    end
  end
  if (y>=116) print("") y=116
  poke(24359,y+6)
  poke(24358,0)
  reload(0,0,320)
end

function use_id()
	if state< 5 or state>6 then
		for i=1,#item_dialogs do
			for j=1,#item_dialogs[i][1] do
				if tile_facing() == item_dialogs[i][1][j] then
					show_dialog(item_dialogs[i][2],52,112,7)
				end
			end
		end
	end
end

function item_prompt()
	prompt = true
end

-->8
--intro/outtro code--
function intro_draw()
	cls()
	large_print("@the next",37,10,8)
	large_print("@experiment",32,20,8)
	print("you have been taken and are now ",hcenter("you have been taken and are now"),40,6)
	print("trapped inside a dark castle",hcenter("trapped	inside a dark castle"),50,6)
	print("read carefully" ,hcenter("read carefully"),70,6)
	print("figure out how to escape",hcenter("figure out how to escape"),60,6)
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


function win_draw()
	if not fail then
		if time()-set <= 7 then
			cls()
			win_animation()
			draw_room(mainroom)
			spr(flower_spr,64-((#mainroom[1]/2)*8)+flr(8*(9-1)),flr(8*(7-1)))
			spr(54, 40, 6)
			spr(55, 80, 6)
			spr(57, 104, 4)
			spr(58, 112, 4)
			spr(41, 20, 6)
			rectfill(0,0,22,8,1)
	 	rect(0,0,22,8,0)
			print(runtime,2,2,7)
		else
			cls(0)
			con_animation()
			if (time()-set >= 11) music(-1,2000)


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
		if (time()-set >= 8) music(-1,2000)
		print("you have failed",hcenter("you have failed"),70,8)
		print("press ❎ to try again",hcenter("press ❎ to try again"),80,8)

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
		mainroom[1][8] = 240
	end
	if time()-set >= 2 then
		mainroom[1][9] = 241
	end
	if time()-set >= 3 then
		mainroom[3][8] = 242
	end
	if time()-set >= 4 then
		mainroom[3][9] = 243
	end

	if time()-set >= 5 then
		if not lock_sound then
			sfx(11)
			lock_sound=true
		end
		mainroom[1][8] = 226
		mainroom[1][9] = 227
		mainroom[2][8] = 228
		mainroom[2][9] = 229
		mainroom[3][8] = 244
		mainroom[3][9] = 245

	end
end

function con_animation()
	local x
	if (time()-set >= 7 and time()-set <= 7.5) then
		final_spr = 79
		x = -1
	elseif (time()-set >=7.5 and time()-set <= 8) then
		final_spr = 95
		x = 2
 elseif (time()-set >= 8 and time()-set <= 8.5) then
		final_spr = 111
		x = 4
	elseif (time()-set >= 8.5 and time()-set <= 9) then
		final_spr = 79
		x = 8
	elseif (time()-set >= 9) then
		final_spr = 76
		x = 8
	end
	spr(final_spr,x,60)
	spr(191,110,60)
	if (time()-set >= 9.5) print(small_font("you escaped my lab!\nthis is fantastic!"),55,5,3)
	if (time()-set >= 10) print(".",1,20,12)
	if (time()-set >= 10.4) print(".",5,20,12)
	if (time()-set >= 10.8) print(".",9,20,12)
	if (time()-set >= 11.5) print(small_font("this means you are\nsmart enough to be\nmy friend and stay\nhere forever!"), 55,30,3)

end


function hcenter(s)
  return 64-#s*2
end
__gfx__
00000000111111d11d11111122222222222222222222222255599999999999999999955599999999999999990000000000000000999999999999999900000000
0000000011dd111dd111dd1124442444244444444444444255922222222222222222295599999999999999990000000000000000999999999999999900000000
007007001d11d111111d11d124442444242225444422254259244444444444444444429599999999999999990000000000000000999999999999999900000000
0007700011dd11111111dd1124442444242552444425554292444444444444444444442944444444444444440000000000000000444444444444444400000000
000770001111111dd111111124442444242552444425554292444444444444444444442948226232222c2284000000000000000048226232222c228400000000
00700700111111d11d111111244424442422254444222542924444444444444444444429482a65f1a28c21840000000000000000482a65f1a28c218400000000
0000000011dd111dd111dd1124442444244444444444444292444444444444444444442948ca65312a8c6184000000000000000048ca65312a8c618400000000
000000001d11d111111d11d122222222244444444444444292444444444444444444442944444444444444440000000000000000444444444444444400000000
0000000011dd11111111dd115555555524444444444444429244444444444444444444294222232ca222223400000000000000004212232ca222223400000000
000000001111111dd1111111555555552444444444444442924444444444444444444429422c235ca11281340000000000000000461c235ca112813400000000
00000000111111d11d111111555555552444449449444442922444444444444444444229422c835ca67681340000000000000000461c835ca676813400000000
0000000011dd111dd111dd1155555555244449444494444259924444444444444444299544444444444444440000000000000000444444444444444400000000
000000001d11d111111d11d155555555244449444494444255599999999999999999955542322222c2282c54000000000000000042322222c2282c5400000000
0000000011dd11111111dd11555555552444494444944442555522222222222222225555453a1282c1283c540000000000000000453a1282c1283c5400000000
000000001111111dd1111111555555552444449449444442555522444444444444225555453a218ac1583c540000000000000000453a218ac1583c5400000000
00000000111111d11d11111155555555244444444444444255522244455555544422255544444444444444440000000000000000444444444444444400000000
000000000000000000000000555555552444444444444442eeeeeeeeee8eee8eee8eee8e44444444999999999999999999999999555555555555555500000000
000000000555555555555550555555552444444444444442ee8eee8ee88eee88e828e88841111114991111111111111111111199555555555555555500000000
000000000555555555555550455555552422224444222542eee3e3eeeee3e3eeee83e38e41177114919111111111111111111919555555555555555500000000
000000000555555555555550465555552455254444552542ee6637eeee6637eeee6637ee41177114911111111111111111111119559999999999995500000000
000000000000000000000000465555552425254444525542ee6367eeee6367eeee6367ee41677614911111111111111111111119594444444444449500000000
000000000011111111111100475555552422254444522242ee3666eeeecccceeeeccccee40677654919111111111111111111919943333333330334900000000
000000000055555555555500265555552444444444444442ee7666eeee7ccceeee7cccee45677604991111111111111111111199943333333333564900000000
0000000000555555555555002655555522222222222222228eeddee88eeddee88eeddee844444444999999999999999999999999943333333333656900000000
00000000000000000000000027555555eeeeeeeeeeeeeeeeeee44eeeee4444ee555554554444444444444444eeeeeeee00000000943333333333365900000000
00000000010111111111101027555555eeee86eeeeeeeeeeee4774eee455354e552224554000000000000004eeeeeeee00000000943333333673334900000000
00000000010555555555501026555555ee88886eeee888eee470074e45555354552554554005500000055004ee1117ee00000000943333336006334900000000
00000000010000000000001026555555ee888886eee888eee47f074e45555654544442554057750000577504ee1117ee00000000594444444674449500000000
00000000010011111111001025555555ee88886eee88888ee47f074e459a565454222255457cc750057cc754ee1117ee00000000559999999999999500000000
00000000001011111111010055555555eeee86eeee68886ee477874e42992624542442554057750000577504ee1117ee00000000552255555555225500000000
00000000000000000000000055555555eeeeeeeeeee686eeee4884eee4ffff4e522222554005500000055004ee1117ee00000000552255555555225500000000
00000000000000000000000055555555eeeeeeeeeeee6eeeeee44eeeee4444ee525552554444444444444444eeeeeeee00000000554455555555445500000000
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
5577755777555755557555777555755555557775555555557777777000000000ee7777eeeeeeeeeeeeeeeeeeeeeeeeeee722277ee722227ee722227ee722227e
5577755777555755557555777555755575757665555665557777777000000000ee7766eeeeeeeeeeeeeeeeeeeeeeeeeee727727ee777727ee727777ee777277e
551115588855ccc55aaa55ddd55bbb5575757775555655557777777000000000ee7777eeeeeeeeeeeeeeeeeeeeeeeeeee727727ee777277ee727777ee777277e
551115588855ccc55aaa55ddd55bbb557575777556565655fffffff000000000ee2222eeeeee777eeeee777eeeee777ee727727ee772777ee727777ee777277e
000000000000000000000000000000000000000000000000fffffff000000000ee2222eeeeee766eeeee766eeeee766ee727727ee727777ee727777ee727277e
999999999999999999999999999999999999999999999999fffffff000000000ee2222eeeeee777eeeeefffeeeeefffee722277ee722227ee722227ee722277e
999999999999999999999999999999999999999999999999fffffff000000000eeeeeeeeeeee777eeeeefffeeeee111eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee
444777455ff6666666666ff511111111111111111111111199999994111111116666666611111111588888888888888566666666444444455555455555555544
447797755ffffffffffffff51a1111a11a1111a11a1111a1999999641a1111a1777777771a1111a1588888888888888566666666444444452222455555554444
47777777588888888888888511a11a11144444444444444129dddd8411a11a117777776711a11a115888888888888885666666664444444a2552455555444444
4a77777a588888888888888544444444144444444444444129dd666477777777777777674444444458888888888888857777777722222225bbbb455555444444
4999599a5888888888888885444444441ffffffffffffff129dd6d6477777777777777674444444458448888888844857777776722222225bbbb455554444444
449555955888888888888885999999991ff7777777777ff129ddddc46666666677777767999999945844dddddddd448577777767222222252222255554444444
444999455888888888888885999999991ff7777777777ff129dddd646006600677777777999999945244dddddddd442577777767222222252bbb255554444444
444444455888888888888885999999994ff7777777777ff4299999946006600677777777999999945244dddddddd4425777777775dd5dd552555255554444444
4455555554444444444444455555555599999999eeeeeeee59999999600660061111111111111111055555507777777755555555eeeeeeee0000000000000000
4444555554444444444444455dddddd599999999eeeeeeee54444444666666661a1111a11a1111a104499aa07eeeeee75dddddd5eeeeeeee0000000000000000
444444555544444444444455dddddddd42222224e666666e74444444dddddddd11a11a1111a11a1104499aa07eeeeee766666666e666666e0000000000000000
4444445555544444444455556666666642744724ee6c6ee654444444d000000d111111111111111104499aa07eeeeee700000000ee676ee60000000000556700
444444455555544444555555ddd99ddd42444424e6ccc6e654444444d000000d11a11a1111a11a1104499aa07eeeeee7ddd99ddde67776e60000000005500650
444444455555555225555555ddd99ddd42444424e67cc66e54444444d000000d1a1111a11a1111a104499aa07eeeeee7ddd99ddde677766e0055670005000050
444444455555522222255555dddddddd42222224ee666eee54444444d000000d111111111111111104499aa07eeeeee7ddddddddee666eee0550065000000050
444444455555522222255555dddddddd22222222eeeeeeee555555552222222211111111444444440555555077777777ddddddddeeeeeeee0500005000000050
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
55aaaa5555555555555aa5555555555555555555555aa555555aa555aaaaaaaa00000000000000000000000000000000000000000000000000000000eeccccee
5aaaaaa555555555555aa5555555555555555555555aa555555aa555aeeeeeea00000000000000000000000000000000000000000000000000000000ecccccce
aaaaaaaa55555555555aa5555555555555555555555aa555555aa555aeeeeeea00000000000000000000000000000000000000000000000000000000ecffffce
aaaaaaaaaaaaaaaa555aa555aaaaa555555aaaaa555aaaaaaaaaa555aeeeeeea00000000000000000000000000000000000000000000000000000000ec0ff0ce
aaaaaaaaaaaaaaaa555aa555aaaaa555555aaaaa555aaaaaaaaaa555aeeeeeea00000000000000000000000000000000000000000000000000000000ecffffce
aaaaaaaa55555555555aa555555aa555555aa5555555555555555555aeeeeeea00000000000000000000000000000000000000000000000000000000ef7887fe
5aaaaaa555555555555aa555555aa555555aa5555555555555555555aeeeeeea00000000000000000000000000000000000000000000000000000000ef7887fe
55aaaa5555555555555aa555555aa555555aa5555555555555555555aaaaaaaa00000000000000000000000000000000000000000000000000000000ee1ee1ee
1dd1dd1d1dd1dd1dd1552d2dd2dd201155555555555555555533335555555555555335555555555555555555555335555553355533333333d1dd1d1dd1dd1d1d
111111111111111111552222222200005555555555535555533333355555555555533555555555555555555555533555555335553eeeeee31111111111111111
d1dd1dd1d1dd1dd1dd55d2d2dd21101055555b555555355b333333335555555555533555555555555555555555533555555335553eeeeee3dd1dd1d1dd1dd1d1
111111111111111111552222220000005555553b553b535b333333333333333355533555333335555553333355533333333335553eeeeee31111111111111111
1d1dd1dd1555555d1d55dd2d2d10101155553555b5553353333333333333333355533555333335555553333355533333333335553eeeeee31dd1dd1d1dd1dd1d
1111111115553351115555555555000055355355333b3b3b333333335555555555533555555335555553355555555555555555553eeeeee31111100000011111
d1d1dd1dd533555dd2555500005501105553353b33b33333533333355555555555533555555335555553355555555555555555553eeeeee3d1dd0000000d1dd1
1111111115558851122255000055000053b3bb33b33b3b3355333355555555555553355555533555555335555555555555555555333333331111000000001111
555555551588555dd2dd555555551101edddddde777777775588885555555555555885555555555555555555555885555558855588888888dd1000000000d1dd
555555551555cc512225555555555000dccccccd7eeeeee7588888855555555555588555555555555555555555588555555885558eeeeee81110000000000011
55555555d5cc5551dd25508888055010ddccccdd7eeeeee7888888885555555555588555555555555555555555588555555885558eeeeee81d0000000000001d
55555555155555512225588998855555d6dccd6d7eeeeee7888888888888888855588555888885555558888855588888888885558eeeeee81100000000000001
555555551d1dd1dd2dd5589999855555d66dd66d7eeeeee7888888888888888855588555888885555558888855588888888885558eeeeee8d10000000000000d
55555555111111112225555555555000ed6666de7eeeeee7888888885555555555588555555885555558855555555555555555558eeeeee81000000000000001
55555555d1d1dd1dd2d5511010155110ed6666de7eeeeee7588888855555555555588555555885555558855555555555555555558eeeeee81000000000000001
55555555111111112225500000055000eeddddee7777777755888855555555555558855555588555555885555555555555555555888888880000000000000000
555229aaaa9222552222222002222222244444400444444255cccc5555555555555cc5555555555555555555555cc555555cc555cccccccc0505050500500050
555229aaa9922255244444400444444224444440044444425cccccc555555555555cc5555555555555555555555cc555555cc555ceeeeeec5055055005055005
25229aaa9922225524222740042227422444449009444442cccccccc55555555555cc5555555555555555555555cc555555cc555ceeeeeec5050050505500555
529999999222255524277240042777422444494004944442cccccccccccccccc555cc555ccccc555555ccccc555cccccccccc555ceeeeeec0505505555505005
522999292225555524277240042777422444494004944442cccccccccccccccc555cc555ccccc555555ccccc555cccccccccc555ceeeeeec5555555555555550
222922222555555524222740042227422444494004944442cccccccc55555555555cc555555cc555555cc5555555555555555555ceeeeeec5555555555555555
5522222255555555244444400444444224444490094444425cccccc555555555555cc555555cc555555cc5555555555555555555ceeeeeec5555555555555555
55255525555555552444444004444442244444400444444255cccc5555555555555cc555555cc555555cc5555555555555555555cccccccc5555555555555555
22222222222222222444444444444442244444400444444255999955555555555559955555555555555555555559955555599555999999995555555500000000
244444444444444224444444444444422444444004444442599999955555555555599555555555555555555555599555555995559eeeeee95555555506555560
242227444422274224222244442227422422224004222742999999995555555555599555555555555555555555599555555995559eeeeee95555555505666650
242772444427774224772744447727422477274004772742999999999999999955599555999995555559999955599999999995559eeeeee95555555505666650
242772444427774224272744447277422427274004727742999999999999999955599555999995555559999955599999999995559eeeeee95555555505666650
242227444422274224222744447222422422274004722242999999995555555555599555555995555559955555555555555555559eeeeee95555555505666650
244444444444444224444444444444422444444004444442599999955555555555599555555995555559955555555555555555559eeeeee95555555506555560
24444444444444422222222222222222222222200222222255999955555555555559955555599555555995555555555555555555999999995555555500000000
__gff__
0001010101010101010101000001010000010100010101010101010101010100000000000101000000010000000000000001010000000000010100000001010001010101010101010100000000000000010101010101010000000000000000000101010101000000000000000000000001010101010100000000000000000000
0101010101010101010101010101010101010101010101010101010101010101000000000000000000000000000000000000000000000000000000000000000001010101000000000000000000000101000101010100000000000000000001010000010101010000000000000000000001010101010100000000000000000100
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
010f00002463300000186252460027500275003850038500005000050000500005000050000500005000050000500000000000000000000000000000000000000000000000000000000000000000000000000000
011000002463300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
01 02030405
00 02030607
02 02030809
