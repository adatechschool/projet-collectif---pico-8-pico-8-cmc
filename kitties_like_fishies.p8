pico-8 cartridge // http://www.pico-8.com
version 29
__lua__
-- main functions

function _init()
--music
	sfx(3)
--score
	score=0
	game_won=false
	game_over=false
--sprites
	cats={}
	create_cat()
	dogs={}
	create_dog()
	fishes={}
	create_fish()
end
--update
function _update()
 cat_movement()
 dog_movement(dogs)
--score and time
	if score==20 and finish_time==nil then
		finish_time=flr(time())
		game_won=true
	end
end
--draw
function _draw()
	cls()
	draw_map()
 draw_sprites()
--print score
	print('score: '..score,1,1,7)
--you win ! print whatever
	if game_won==true then
		print('you win !',20,55,0)
		print('it took you '..finish_time..' sec !',35,68,0)	
	else
		print('time: '..flr(time()),40,1,7)
	end
	if game_over==true then
		print('game over !',20,55,0)	
	end
end

-->8
-- functions sprites

function create_cat()
 for i=1,1 do
		local c={
			sp=2,
			xt=8,
			yt=3,	
		}
		add(cats,c)	
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
		until (check_flag(0,f.xt,f.yt)==false) 		
		add(fishes,f)	
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
		until (check_flag(0,d.xt,d.yt)==false) 		
		add(dogs,d)	
	end
end

function dog_movement(dogs)
	for d in all(dogs) do
	 local rn=flr(rnd(32))
		newx=d.xt
		newy=d.yt
		if rn==0 then newx+=1 end
		if rn==8 then newx-=1 end
		if	rn==16 then newy+=1 end
		if rn==24 then newy-=1 end
		if (check_flag(0,newx,newy)==false  
	 and check_flag(1,newx,newy)==false)
			then	
			d.xt=mid(0,newx,15)
			d.yt=mid(0,newy,15)
			end
			if collision_cat_dog(d.xt*8,d.yt*8) then
				game_over=true
				return game_over									
 		end
 	
 end 
end					

function draw_sprites()
	for c in all(cats) do
		spr(c.sp,c.xt*8,c.yt*8) 
	end
	for d in all(dogs) do
		spr(d.sp,d.xt*8,d.yt*8)
	end
	for f in all(fishes) do
		spr(f.sp,f.xt*8,f.yt*8)
	end
end


function cat_movement()
	for c in all(cats) do
	 if game_over!=true then
			newx=c.xt
			newy=c.yt
			if (btnp(➡️)) newx+=1
			if (btnp(⬅️)) newx-=1
			if (btnp(⬇️)) newy+=1
			if (btnp(⬆️)) newy-=1
			
			if not check_flag(0,newx,newy) then
				c.xt=mid(0,newx,15)
				c.yt=mid(0,newy,15)
				collision_cat_fish(c.xt*8,c.yt*8)
			end					
	 else sfx(4)
 	end 
 end
end

function collision_cat_fish(x,y)
 for f in all(fishes) do
		if f.xt*8==x and f.yt*8==y then
			del(fishes,f)
			sfx(2)
			score+=1
			create_fish()
			create_dog()
		end
	end
end

function collision_cat_dog(x,y)
	for c in all(cats) do
		if c.xt*8==x and c.yt*8==y then
			del(cats,c)
			sfx(1)
			return true
		end
	end
end


-->8
-- functions map

function draw_map()
 map(0,0,0,0,128,64)
end

function check_flag(flag,x,y)
	local sp=mget(x,y)
	return fget(sp,flag)
end


__gfx__
0000000044000044560060060070007000005000bb3333bbbbbbbbbbbbb566bbbbbbbbbb77cccc77bbbbbbbbbbb566bbcccccccc65666656ccccccccc444444c
00000000044444405000555500555550d0056500b33bb33b8b8bbbbbb6666656bb7bbbbbccccccccbbbbbbbbb6666656cbcccccccccccccccbccccccc444444c
00700700041441405000595900595950d606d150b33bb33b888bbbbb6cc56cc6b7a7bbbbcccc7cccbbbbbbbb6cc44cc6cccccbccccccccccccccccccc444444c
0007700004455440505555e50555e555dd6d6dd5b333333bb3bbbbbbccccccccbb7bbbbbccc777ccbbbbbbbbccc44cccccccccccccccccccccccccccc444444c
00077000044ee4405555555500055500d606dd50bb3333bbb33bbebeccccccccbbbbb9bbcc57575cbbbbbbbbccc44ccccccccbccccccccccccccccccc444444c
00700700008888005555505000050500d0056500bbb44bbbbbbbbeeeccccccccbbbb9a9bc5555555bbbbbbbbccc44ccccccccccccccccbccccccccbcc444444c
0000000000444400555050500007070000005000bbb44bbbbbbbbb3b566cc656bbbbb9bbbb55555bbbbbbbbb56655656cbccccccccccccccccccccccc444444c
0000000000400400606060600000000000000000bbb44bbbbbbbb33bbb66666bbbbbbbbbbbbbbbbbbbbbbbbbbb66666bcccccccccccccccc5665655656656556
656666566ccccbccccccccc6656666566cccccccccccccc66cccccc6cccccccc6ccccccc66566665ccccccc66ccccbcc6ccccbccccccccc656666656cccccccc
c444444c5ccccccccbccccc56ccccccc5cbcccccccccccc5cccccbc5ccccccbcccccccbc6ccccccc44444445544444445ccccccccccccccccbccccc5cbcccccc
c444444c6cccccccccccccc65ccbcccc6cccccccccccccc6ccccccc6cccccccccccccccc5cbccccc44444446644444446ccccccccbcccccbccccccc6cccccbcc
c444444c5cccccccccccccc56ccccccc5ccccccbcccbccc5ccccccc5cccccccccccccccc6ccccccc44444445544444445cccccccccccccccccccccc5cccccccc
c444444c6cccccccccccbcc66ccccccc6cccccccccccccc6ccccccc6ccccccccccbccccc6ccccccc44444446644444446cccccccccccccccccccbcc6cccccbcc
c444444c6cccccccccccccc65ccccccc6cccccccccccccc6ccccbcc6cccbcccccccccccc5ccccccc44444446644444446cccccccccccccccccccccc6cccccccc
c444444c6cccbcccccccccc66ccccbcc6ccbccccccccccc6ccccccc6cccccccccccccccc6cccccbc44444446644444446cccbcccbcccccbcccccccc6cbcccccc
c444444c5cccccccccccccc55ccccccc5cccccc666566565ccccccc5ccccccc6cccccccc5cccccccccccccc55ccccccc56566656ccccccccccccccc56ccccccc
__gff__
0000000002010001000100000101010000010101010101010101000001010101000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0a0a0a0a080a0a0a0a0a0a0a0a0a0a0a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a050a0a0a0a0a0a060a0a0a0a080a0500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05050505050a0a0a0a0a0a060a0a050a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0505050a0a0a0a0a0a0a0a0a0a0a0a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a060a0a080a0a060a0a0a130d100d0d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0a0a0a0a0a0a0a0a0a0a11170f0e0e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a05190d0d0d0d0d100d0d18120a0a0a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0a11170e0e0e0e0f0e0e0e150a0a0800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0a11120a0a0a0a0a0a0a0a0a0a050a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0a11120a0a060a0a0a080a0a0a0a0a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
080a11120a050a0a0a0a0a0a050a0a0a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0a1b1a0a0a0a0a0a0a0a0a0a0a060a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0a111d0d0d0d0d0d1e0a0a0a080a0a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0a1c0e0e0e0e0e1f120a0a0a0a0a0a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0a0a0a080a0a0a0a1b1a0a060a0a050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
050a0a0a0a0a0a0a11120a0a0a0a050500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
0014002019030160301b0301b0301e030200302003022030220301e0301e030190301b0301b0301e0301e0301e0301b0301b0301e0301b0301b0301e0301e0301e030200301e030200301e030200301e0301b030
0006000036230352303423033230332302d230262301f2301a23014230102300d2300923005230002301b2001b2001b0001b0001b0001b0001b0001b0001b0001b0001b0001b2001e2001e2001e2001920020200
000100000a5700c5700e57010570105700e5700b57009570245001a500085000650000000260001d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0014002019030160301b0301b0301e030200302003022030220301e0301e030190301b0301b0301e0301e0301e0301b0301b0301e0301b0301b0301e0301e0301e030200301e030200301e030200301e0301b030
__music__
03 01020444

