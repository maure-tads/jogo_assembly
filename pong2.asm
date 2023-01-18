
.text 



main:


addi $k0, $0, 100 #init x position of the ball
addi $k1, $0, 256 #init y position of the ball
addi $s1, $0, 1
addi $s2, $0, 4
addi $t8, $0, 248
addi $t9, $0, 248
game_loop:

clear_ball:
	addi $a1 $0 0x000000 # RGB 0x ff ff ff
	addi $a2 $0 2 # b
	addi $a3 $0 2 # h
	add $t0 $0 $k0 # x
	add $t1 $0 $k1 # y
	jal ret

clear_player_2_last_pos:
	addi $a3 $0 15 # h
	addi $t0 $0 497 # x
	add $t1 $0 $t9 # y
	jal ret
	

clear_player_1_last_pos:		
	addi $a3 $0 15 # h
	addi $t0 $0 15 # x
	add $t1 $0 $t8 # y
	jal ret

player_mov:
	lui $t0, 0xffff
	lw $t4, 0($8)
	beq $t4, $0, naodig
	lw $t6, 4($8)
	addi $t5, $0, 'w'
    	bne $t5, $t6, down
	addi $t5, $0, 's'
    	bne $t5, $t6, up
    	j naodig
up:
	addi $t8, $t8, -12
	j naodig	
down:
	addi $t8, $t8, 12
	
naodig:
	
update_ball_position:
	add $k0, $k0, $s1
	add $k1, $k1, $s2
	ble $k1, $0, invert_y_direction 
	bge $k1, 512, invert_y_direction
	
	ble $k0, $0, reset_ball 
	bge $k0, 256, reset_ball
	
update_player_2_position:

	addi $at, $t9, 7
	bge $at, $k1, sobe
desce:
	addi $t9, $t9, 4
	j continue_player_2_position
sobe:
	addi $t9, $t9, -4	
	
	
continue_player_2_position:

	addi $a3, $t9, 15
	add $a0, $k0, $s1
	add $a1, $k1, $s2
	ble $a0, 239, end_player_2_collision_routine
	bge $a1, $a3, end_player_2_collision_routine
	ble $a1, $t9, end_player_2_collision_routine
	
	mul $s1, $s1, -1
end_player_2_collision_routine:
	
	
	
continue_ball_trajectory:

ball:
	addi $a1 $0 0xffffff # RGB 0x ff ff ff
	addi $a2 $0 2 # b
	addi $a3 $0 2 # h
	add $t0 $0 $k0 # x
	add $t1 $0 $k1 # y
	
	jal ret

player_1:
	addi $a1 $0 0xcfcfcf # RGB 0x ff ff ff
	addi $a3 $0 15 # h
	addi $t0 $0 15 # x
	add $t1 $0 $t8 # y
	
	jal ret

player_2:
	addi $a1 $0 0xcfcfcf # RGB 0x ff ff ff
	addi $a2 $0 2 # b
	addi $a3 $0 15 # h
	addi $t0 $0 497 # x
	add $t1 $0 $t9 # y
	
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
	jal timer
	j game_loop
	

	addi $2, $0, 10
	syscall
	
	
#t0 x pos
#t1 y pos
#t2 height
#t3 width

ret:	
	lui $a0, 0x1001
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
rnd_y_direction:
	li $v0, 42            # system call to generate random int
	la $a1, 4       # where you set the upper bound
	syscall  
	mul $a0, $a0, 2
	add $s2, $a0, $0
	addi $s2, $s2, -4
	beq $s2, $0, rnd_y_direction
	mul $s1, $s1, -1 #reset ball direction on reset
	j continue_ball_trajectory


timer:  addi $s6, $0, 2000
fortimer: beq $s6, $0, fimtimer
          nop
          nop
          nop
          addi $s6, $s6, -1
          j fortimer      
fimtimer: jr $31
