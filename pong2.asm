
.text 

main:

draw_vertical_line:
			
	lui $a0, 0x1001
	addi $a1, $0, 0
	addi $a2, $0, 256
	addi $a3, $0, 256
	addi $20, $0, 512
	addi $9, $0, 0xFFFFFF
	
for_i: 
	beq $20, $0, end_i
	addi $a1, $a1, 1
	jal get_pixel_addr
	sw $9, 0($v0)
	addi $20, $20, -1
	j for_i 

end_i: 

	addi $2, $0, 10
	syscall

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