.text

main:

draw_vertical_line:

	lui $8, 0x1001
	#addi $8, $8, 512
	addi $10, $0, 512
	addi $11, $0, 512

	draw_vertical_line_i:
		beq $10, $0, end_draw_vertical_line_i
		
		draw_vertical_line_j:
			beq $11, $0, end_draw_vertical_line_j
			
			addi $11, $0, -1
			j draw_vertical_line_j
		end_draw_vertical_line_j:
		addi $11, $0, 512
		addi $10, $10, -1
		j draw_vertical_line_i
		