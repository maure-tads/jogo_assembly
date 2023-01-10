
.text 



main:


addi $k0, $0, 100 #init x position of the ball
addi $k1, $0, 256 #init y position of the ball
addi $s1, $0, 1
addi $s2, $0, 4
game_loop:
clear_ball:
	addi $a0 $0 0x10010000 # endereco
	addi $a1 $0 0x000000 # RGB 0x ff ff ff
	addi $a2 $0 2 # b
	addi $a3 $0 2 # h
	add $t0 $0 $k0 # x
	add $t1 $0 $k1 # y
	jal ret
	
update_ball_position:
	add $k0, $k0, $s1
	add $k1, $k1, $s2
	ble $k1, $0, invert_y_direction 
	bge $k1, 512, invert_y_direction
	
	ble $k0, $0, reset_ball 
	bge $k0, 256, reset_ball
	
	
continue_ball_trajectory:

ball:
	addi $a0 $0 0x10010000 # endereco
	addi $a1 $0 0xffffff # RGB 0x ff ff ff
	addi $a2 $0 2 # b
	addi $a3 $0 2 # h
	add $t0 $0 $k0 # x
	add $t1 $0 $k1 # y
	
	jal ret

player_1:
	addi $a0 $0 0x10010000 # endereco
	addi $a1 $0 0xcfcfcf # RGB 0x ff ff ff
	addi $a2 $0 2 # b
	addi $a3 $0 15 # h
	addi $t0 $0 15 # x
	addi $t1 $0 248 # y
	
	jal ret

player_2:
	addi $a0 $0 0x10010000 # endereco
	addi $a1 $0 0xcfcfcf # RGB 0x ff ff ff
	addi $a2 $0 2 # b
	addi $a3 $0 15 # h
	addi $t0 $0 497 # x
	addi $t1 $0 248 # y
	
	jal ret

draw_vertical_line:
	lui $a0, 0x1001
	addi $a1, $0, 0
	addi $a2, $0, 256
	addi $a3, $0, 256
	addi $s4, $0, 512
	addi $t1, $0, 0xFFFFFF
	
for_i: 
	beq $s4, $0, end_i
	jal get_pixel_addr
	sw $t1, 0($v0)
	addi $a1, $a1, 2
	addi $s4, $s4, -1
	addi $s0, $0, 8
	div $s4, $s0
	mfhi $s5
	beq $s5, $0, change_color

continue_horizontal_line:
	j for_i 

change_color:
	beq $t1, $0, change_white
	addi $t1, $0, 0
	j continue_horizontal_line
change_white:
	addi $t1, $0, 0xffffff
	j continue_horizontal_line
end_i: 
	
	j game_loop


	addi $2, $0, 10
	syscall
	
	
#t0 x pos
#t1 y pos
#t2 height
#t3 width

ret:	
	sll $t0 $t0 2
	add $t0 $t0 $a0 # inicio + x
	sll $t1 $t1 9
	add $t0 $t0 $t1 # inicio + y
	add $a0 $0 $t0 # endereco
	add $t0 $0 $a0 
	add $t1 $0 $a1 # cor
	add $t2 $0 $a2 # b
	add $t3 $0 $a3 # h

laco1:	
	beq $t3 $0 fimret
laco2:	
	beq $t2 $0 fimlaco2
	
	sw $t1 0($t0) # 'pinta' pixel
	addi $t0 $t0 4 # proximo endereco de memoria
	addi $t2 $t2 -1 # x--
	j laco2

fimlaco2:
	addi $t0 $t0 1024 # proxima linha 
	sll $t7 $a2 2 # x * 4 (endereco de mem)
	sub $t0 $t0 $t7 # volta para inicio
	add $t2 $0 $a2 # x = b
	addi $t3 $t3 -1 # y--
	j laco1

fimret:	 
	jr $ra # retorno da funcao
	
			
#Input:   $a0 &p0
#	  $a1 l (y position)
#	  $a2 L
#	  $a3 c (x position)
#
#Out:	  $2
	
get_pixel_addr:
	mul $t0, $a1, $a2
	add $t0, $t0, $a3
	sll $t0, $t0, 1
	add $v0, $t0, $a0
end_pixel_addr:
	jr $ra
	
invert_y_direction:
	mul $s2, $s2, -1
	j continue_ball_trajectory
	
reset_ball:
	addi $k0, $0, 126 #init x position of the ball
	addi $k1, $0, 256 #init y position of the ball
rnd_direction:
	li $v0, 42            # system call to generate random int
	la $a1, 4       # where you set the upper bound
	syscall  
	mul $a0, $a0, 2
	add $s2, $a0, $0
	addi $s2, $s2, -4
	beq $s2, $0, rnd_direction
	mul $s1, $s1, -1 #reset ball direction on reset
	j continue_ball_trajectory
