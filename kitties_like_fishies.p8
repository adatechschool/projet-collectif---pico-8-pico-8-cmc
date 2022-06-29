pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
-- main functions

function _init()
--time
	start_time=time()
--music
	sfx(3)
--scene
	scene='menu'
--test
	loghs=true
--score
	fish=0	
	game_over=false
--sprites
	cats={}
	create_cat()
	dogs={}
	create_dog()
	fishies={}
	create_fish()
--explosions
	explosions={}
end

function _update()
	if scene=='menu' then
		update_menu()
	elseif scene=='game' then
		update_game()
	end
end

function _draw()
	if scene=='menu' then
		draw_menu()
	elseif scene=='game' then
		draw_game()	
	end
end

-->8
--menu-game-end

--for menu

function update_menu()
	if btnp(❎) then
		scene='game'
	end
end

function draw_menu()
	cls()
	print('kitties like fishies, you know ?',1,20)
	print('you are a kitty : the goal of',1,40)
	print('the game is to eat	the most',1,50)
	print('fishies you can while avoiding',1,60)
	print('the dogs.',1,70)
	print('godd luck !',1,80)			
	print('press ❎ to start',30,110)
end

--for game

function update_game()
	if btnp(❎) then
		scene='menu'
	end
	cat_movement()
 dog_movement(dogs)
 update_camera()
 update_explosions()
 if game_over==true
		and finish_time==nil then
			finish_time=flr(gap_time)
	end
end

function draw_game()
	cls()
	draw_map()
	draw_explosions()
	draw_sprites()
 draw_fishies()
 now_time = time()
 gap_time = now_time-start_time
--game over	
	if game_over==true then
		sfx(-1,0)
		draw_end()
	else
		local score=round(fish/60*100,2)
		print('time: '..flr(gap_time),38,2,7)
		print('score: '..score,78,2,7)
	end
end


function draw_end()
	if btnp(❎) then
		_init()
	end
 if loghs then
  --type in name for hs list
  local _y=25
  local score=round(fish/60*100,2)
  	
  rectfill(0,_y,128,_y+80,1)
  print("🐱 don't be greedy...🐱",20,_y+4,14)
  --print('it took you '..finish_time..' sec',10,_y+19,7)
		
		--if fish<1 then		
			--print('to eat '..fish..' fish !',10,_y+29,7)
		--else 
			--print('to eat '..fish..' fishies !',10,_y+29,7)
		--end
	
		print('your score is : '..score,10,_y+19,8)
  print('enter your initials',10,_y+29,7)
  print('for the high score list.',10,_y+39,7)
  print('aaa',59,_y+49)
  print("press 🅾️ to get high-scores",10,_y+59,6)
 
  print("press ❎ to start",10,_y+69,6)
 else
 end
end

--interface game

function draw_fishies()
	camera()
	palt(0,false)
	palt(11,true)
	spr(38,1,1)
	palt()
	print_contour('X'..fish,13,2)
end

function print_contour(text,x,y)
	print(text,x-1,y,0)
	print(text,x+1,y,0)
	print(text,x,y-1,0)
	print(text,x,y+1,0)
	
	print(text,x,y,7)
end

-->8
-- functions sprites

function create_cat()
 for i=1,1 do
		local c={
			sp=2,
			xt=8,
			yt=3,
			flip_x=true	
		}
		add(cats,c)	
	end
end

function create_dog()
	for i=1,1 do
		local d={
			sp=1,
			xt=flr(rnd(16)),
			yt=flr(rnd(16)),	
		}
			repeat 
	 		d.xt=flr(rnd(16))
				d.yt=flr(rnd(16))
			until (check_flag(0,
																					d.xt,
																					d.yt)==false) 		
		add(dogs,d)	
	end
end

function create_fish()
	for i=1,1 do
		local f={
			sp=4,
			xt=0,
			yt=0,	
		}
		repeat 
	 	f.xt=flr(rnd(16))
			f.yt=flr(rnd(16))
		until (check_flag(0,
																				f.xt,
																				f.yt)==false) 		
		add(fishies,f)	
	end
end
					

function draw_sprites()
	for c in all(cats) do
		spr(c.sp,c.xt*8,c.yt*8,1,1,c.flip_x) 
	end
	for f in all(fishies) do
		spr(f.sp,f.xt*8,f.yt*8)
	end
	for d in all(dogs) do
		spr(d.sp,d.xt*8,d.yt*8)
	end
end








-->8
-- functions map

function draw_map()
 map(0,0,0,0,128,64)
 print('kitty\'s in a safe place',147,70,8)
end

function check_flag(flag,x,y)
	local sp=mget(x,y)
	return fget(sp,flag)
end

function update_camera()
	if #cats > 0 then
		c=cats[1]
		camx=flr(c.xt/16)*16
		camy=flr(c.yt/16)*16
		camera(camx*8,camy*8)
	end
end


function old_camera()
		if #cats > 0 then
		c=cats[1]
		camx=mid(0,c.xt-7,5,31-15)
		camy=mid(0,c.yt-7,5,31-15)
		camera(camx*8,camy*8)
	end
end


-->8
-- functions movements

function cat_movement()
	for c in all(cats) do
	 if game_over!=true then
			newx=c.xt
			newy=c.yt
			if (btnp(➡️)) newx+=1
			if (btnp(➡️)) c.flip_x=false
			if (btnp(⬅️)) newx-=1
			if (btnp(⬅️)) c.flip_x=true
			if (btnp(⬇️)) newy+=1
			if (btnp(⬆️)) newy-=1
			
			if not check_flag(0,newx,newy) then
				c.xt=mid(0,newx,31)
				c.yt=mid(0,newy,31)
				collision_cat_fish(c.xt*8,c.yt*8)
			end					
	 else sfx(4)
 	end 
 end
end

function dog_movement(dogs)
	for d in all(dogs) do
	 local rn=flr(rnd(32))
		newx=d.xt
		newy=d.yt
		if rn==0 	then newx+=1 end
		if rn==8 	then newx-=1 end
		if	rn==16 then newy+=1 end
		if rn==24 then newy-=1 end
		local is_free=true
		for f in all(fishies) do
			if check_flag(0,newx,newy)
			or (f.xt==newx and f.yt==newy)
			then
				is_free=false
			end
		end
		if is_free then
				d.xt=mid(0,newx,15)
				d.yt=mid(0,newy,15)
		end
		if collision_cat_dog(d.xt*8,d.yt*8) then
			game_over=true
			return game_over									
 	end	
 end 
end
			


-->8
-- functions collisions

function collision_cat_fish(x,y)
 for f in all(fishies) do
		if f.xt*8==x and f.yt*8==y then
			del(fishies,f)
			sfx(2)
			fish+=1
			create_fish()
			create_dog()					
		end
	end
end

function collision_cat_dog(x,y)
	for c in all(cats) do
		if c.xt*8==x and c.yt*8==y then
			sfx(1)
			create_explosion(x,y)
			del(cats,c)
			return true
		end
	end
end


-->8
--functions explosions

function create_explosion(x,y)
	add(explosions,{x=x,
																	y=y,
																	timer=0})
end

function update_explosions()
	for e in all(explosions) do
		e.timer+=1
		if e.timer==13 then 
			del(explosions,e)
		end
	end
end

function draw_explosions()
	circ(x,y,rayon,couleur)
	for e in all(explosions) do
	circ(e.x,
						e.y,
						e.timer/3,
						8+e.timer%3)
	end
end
-->8
--others

function round(num, numdecimalplaces)
  local mult = 10^(numdecimalplaces or 0)
  return flr(num * mult + 0.5) / mult
end

function game_over()
	--game over	
	if game_over==true then
		sfx(-1,0)
		print('game over !',20,55,0)
		print('it took you '
			..finish_time..' sec',
			35,68,0)
		if fish<1 then		
			print(' to eat '
				..fish..' fish !',
				35,75,0)
		else 
			print(' to eat '
				..fish..' fishies !',
				35,75,0)
		end
		local score=round(fish/finish_time*10,2)
		print('score: '..score,75,1,7)		
	else
		local score=round(fish/time()*10,2)
		print('fish: '..fish,1,1,7)
		print('time: '..flr(time()),35,1,7)
		print('score: '..score,75,1,7)
	end
end

-->8
--functions highscore

--add new hs
function addhs(_score,_c1,_c2,_c3)
 add(hs,_score)
 add(hs1,_c1)
 add(hs2,_c2)
 add(hs3,_c3)
 sorths()
end

--sorths  algorithm
function sorths()
 for i=1,#hs do
  local j = i
  while j > 1 and hs[j-1] < hs[j] do
   hs[j],hs[j-1]=hs[j-1],hs[j]
   hs1[j],hs1[j-1]=hs1[j-1],hs1[j]
   hs2[j],hs2[j-1]=hs2[j-1],hs2[j]
   hs3[j],hs3[j-1]=hs3[j-1],hs3[j]
   j = j - 1
  end
 end
end
--resets the high score list
function reseths()
--create default values
 hs={3.25,2.25,1.75,1,1.54}
 hs1={18,1,1,1,1}
 hs2={1,1,22,1,1}
 hs3={1,1,1,1,19}
 sorths()
 savehs()
end

--load the hs
function loadhs()
 local _slot=0
 
 if dget(0)==1 then
  _slot+=1
  for i=1,5 do
   hs[i]=dget(_slot)
   hs1[i]=dget(_slot+1)
   hs2[i]=dget(_slot+2)
   hs3[i]=dget(_slot+3)
   _slot+=4
  end
  sorths()
 else
 --no file found or empty
 reseths()
 end
end

--save the data
function savehs()
 local _slot
 dset(0,1)
 --load the data
  _slot=1
  for i=1,5 do
  dset(_slot,hs[i])
  dset(_slot+1,hs1[i])
  dset(_slot+2,hs2[i])
  dset(_slot+3,hs3[i])
   _slot+=4
  end
end

function prinths(_x)
 for i=1,5 do
 --number of rank
  print(i.." - ",_x+50,50+7*i,0)
	 
	 --name
	 local _name = hschars[hs1[i]]
	 _name= _name..hschars[hs2[i]]
	 _name= _name..hschars[hs3[i]]
	 
	 print(_name,_x+65,50+7*i,0)
	 --hs1[i]..hs2[i]..hs3[i]
	 
	 print(hs[i],_x+80,50+7*i,0)
	end
end

function end_game()
 if loghs then
 --won. type in name
 --for highscore list
 print("enter your initials",35,93,0)
 print(hschars[nitials[1]],65,100,7)
 print(hschars[nitials[2]],69,100,7)
 print(hschars[nitials[3]],73,100,7)
  if loghs then
   if btnp(⬅️) then
    nit_sel-=1
    if nit_sel<1 then
      nit_sel=3
    end
   end
   if btnp(➡️) then
     nit_sel+=1
    if nit_sel>3 then
       nit_sel=1
    end
   end
   if btnp(⬇️) then
    nitials[nit_sel]-=1
    if nitials[nit_sel]<1 then
     nitials[nit_sel]=#hschars
    end
   end
   if btnp(⬆️) then
    nitials[nit_sel]+=1
    if nitials[nit_sel]>#hschars then
     nitials[nit_sel]=1
    end
   end
  -- if btnp(❎) then
   print("press ❎ to confirm",30,120,0) 
   print("use ⬅️➡️⬆️⬇️ to enter name",15,110,0)
  end
  addhs(score,nitials[1],nitials[2],nitials[3])
  savehs()
 else
 --won but no highscore
  print("no new highscore",35,105,0)
 end
end
__gfx__
0000000044000044560060060070007000001000bb3333bbbbbbbbbbbbb566bbbbbbbbbb77cccc77bbbbbbbbbbb566bbcccccccc65666656ccccccccc444444c
000000000444444050005555005555501001a100b33bb33bebebbbbbb6666656bb7bbbbbccccccccbbbbbbbbb6666656cbcccccccccccccccbccccccc444444c
0070070004144140500059590059595011018610b33bb33beeebbbbb6cc56cc6b7a7bbbbcccc7cccbbbbbbbb6cc44cc6cccccbccccccccccccccccccc444444c
0007700004455440505555e50555e5551818a881b333333bb3bbbbbbccccccccbb7bbbbbccc777ccbbbbbbbbccc44cccccccccccccccccccccccccccc444444c
00077000044ee440555555500005550011018a10bb3333bbb33bb9b9ccccccccbbbbbebbcc57575cbbbbbbbbccc44ccccccccbccccccccccccccccccc444444c
007007000088880055555050000505001001a100bbb44bbbbbbbb797ccccccccbbbbeaebc5555555bbbbbbbbccc44ccccccccccccccccbccccccccbcc444444c
0000000000444400505050500007070000001000bbb44bbbbbbbbb3b566cc656bbbbbebbbb55555bbbbbbbbb56655656cbccccccccccccccccccccccc444444c
0000000000400400606060600000000000000000bbb44bbbbbbbb33bbb66666bbbbbbbbbbbbbbbbbbbbbbbbbbb66666bcccccccccccccccc5665655656656556
656666566ccccbccccccccc6656666566cccccccccccccc66cccccc6cccccccc6ccccccc66566665ccccccc66ccccbcc6ccccbccccccccc656666656cccccccc
c444444c5ccccccccbccccc56ccccccc5cbcccccccccccc5cccccbc5ccccccbcccccccbc6ccccccc44444445544444445ccccccccccccccccbccccc5cbcccccc
c444444c6cccccccccccccc65ccbcccc6cccccccccccccc6ccccccc6cccccccccccccccc5cbccccc44444446644444446ccccccccbcccccbccccccc6cccccbcc
c444444c5cccccccccccccc56ccccccc5ccccccbcccbccc5ccccccc5cccccccccccccccc6ccccccc44444445544444445cccccccccccccccccccccc5cccccccc
c444444c6cccccccccccbcc66ccccccc6cccccccccccccc6ccccccc6ccccccccccbccccc6ccccccc44444446644444446cccccccccccccccccccbcc6cccccbcc
c444444c6cccccccccccccc65ccccccc6cccccccccccccc6ccccbcc6cccbcccccccccccc5ccccccc44444446644444446cccccccccccccccccccccc6cccccccc
c444444c6cccbcccccccccc66ccccbcc6ccbccccccccccc6ccccccc6cccccccccccccccc6cccccbc44444446644444446cccbcccbcccccbcccccccc6cbcccccc
c444444c5cccccccccccccc55ccccccc5cccccc666566565ccccccc5ccccccc6cccccccc5cccccccccccccc55ccccccc56566656ccccccccccccccc56ccccccc
44000044560060066566566656656656bbbbbbbbbbbbbbbbbb050bbbbbbbbbbb0000000000000000000000000000000000000000000000000000000000000000
0444444050005555ccccccccccccccccbbbbbbb88bbbbbbb000850bbb82bb22b0000000000000000000000000000000000000000000000000000000000000000
0414414050005959cc522ccc1ccccc5cbbbbbb8888b55bbb0508810b878288820000000000000000000000000000000000000000000000000000000000000000
04455440505555e5ccc522c111ccc52cbbbbb88dd8855bbb05888850878888820000000000000000000000000000000000000000000000000000000000000000
044ee44055555550cccc5221111c522cbbbb88dddd885bbb0508850b888888820000000000000000000000000000000000000000000000000000000000000000
0088880055555550ccccc522111522ccbbb88dddddd88bbb000850bbb888882b0000000000000000000000000000000000000000000000000000000000000000
0044440005500550cccc115211522cccb888dd1111dd888bbb050bbbbb8882bb0000000000000000000000000000000000000000000000000000000000000000
000450000d600d60ccc11115152211ccbbdddd1111ddddbbbbbbbbbbbbb82bbb0000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbb8333bbccc11115551111ccbbddddddddddddbb11111111000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbb33bb38bcccc922595999cccbbddddddddddddbb11111111000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbb38bb33bcccc225992599cccbbdddd6666ddddbb11111111000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbb333333bccc2259992259cccbbdddd6666ddddbb11111111000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbb3383bbcc22599999225cccbbdddd5666ddddbb11111111000000000000000000000000000000000000000000000000000000000000000000000000
b3bbb3bbbbb44bbbcc259995559225ccbbdddd6666ddddbb11111111000000000000000000000000000000000000000000000000000000000000000000000000
bb3b3bbbbbb44bbbcc5c99955599225cbbbbbbbbbbbbbbbb11111111000000000000000000000000000000000000000000000000000000000000000000000000
bbb3bbbbbbb44bbb5666656666656666bbbbbbbbbbbbbbbb11111111000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000002010001000100000101010000010101010101010101000001010101000001010101020000000000000000000001010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
3636363636363636363636363636363636363636363636363636363636363636363636363636363636363636363636363636000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a050a0a0a0a0a0a11160a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0a313131310a0a0a0a0a060a0a0a0a300a0a08300a1b1a0a0a0a0a0a300a0a080a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0a0a310a310a0a0a0a0a0a0a0a0a0a080a0a0a0a0a11160a0a0a0a0a0a05310a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a060a0a080a0a060a300a130d100d0d0d0d0d0d22231d160a0a0a0a310a0a31050a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0a0a0a0a0a0a0a0a0a0a11170f0e0e0e0e0e0e32330e150a0a0a080a31050a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a05190d0d0d0d0d100d0d18120a0a0a080a0a0a0a0a0a0a0a0a0a0a0a0a0a060a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0a11170e0e0e0e0f0e0e0e150a0a080a0a2727272727272727272727270a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
300a11120a0a0a0a0a0a0a0a0a0a310a0a270a0a0a0a0a0a0a0a0a300a0a270a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0a11120a0a060a0a0a080a0a0a0a0a0a270a0a0a0a0a0a0a0a0a0a0a0a270a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
080a11120a050a0a24250a0a050a0a0a0a0a2727272727272727272727270a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0a1b1a0a0a0a0a34350a0a0a0a060a0a0a0a0a0a0a0a0a24250a0a0a060a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0a111d0d0d0d0d0d1e0a0a0a080a05050a0a0a0a0a050a34350a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0a1c0e0e0e0e0e1f120a0a0a0a05050505050a0a050a0a0a0a080a0a0a0a300a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0a0a080a0a0a0a1b1a0a060a0a05050505050a080a0a0a060a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
050a0a0a0a0a0a0a11120a0a0a0a050505050a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a0a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000031313131313131000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
001a002019030160301b0301b0301e030200302003022030220301e0301e030190301b0301b0301e0301e0301e0301b0301b0301e0301b0301b0301e0301e0301e030200301e030200301e030200301e0301b030
0006000036230352303423033230332302d230262301f2301a23014230102300d2300923005230002301b2001b2001b0001b0001b0001b0001b0001b0001b0001b0001b0001b2001e2001e2001e2001920020200
000100000a5700c5700e57010570105700e5700b57009570245001a500085000650000000260001d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0019002019030160301b0301b0301e030200302003022030220301e0301e030190301b0301b0301e0301e0301e0301b0301b0301e0301b0301b0301e0301e0301e030200301e030200301e030200301e0301b030
__music__
03 00020444

