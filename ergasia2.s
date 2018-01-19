	.data
	T:	.word 5,0,0,0,0,4
		.word 0,2,0,0,0,2
		.word 0,0,10,0,0,0
		.word 0,0,0,-20,0,-10
		.word 0,0,0,0,3,0
		.word 0,2,0,4,3,0
	
	elements:  .word 25
	zero:	   .word 0
	
str1:	.asciiz "Sub-matrix at position i = "
str2:	.asciiz " ,j = "
symm:	.asciiz " is symmetric."
diag:	.asciiz " is diagonal."
both:	.asciiz " is symmetric and diagonal."	
endl:	.asciiz "\n"


.text		
.globl main
	
main:
	
	lw $t1, elements($t0)			#first element
	lw $t2,zero($t0)				#row_count
	lw $t3,zero($t0)				#col_count
	lw $t4,zero($t0)				#counter
	lw $t5,zero($t0)				
	addi $t6,$t6,6					#dimension
	
loop:			addi $t7,$t2,5
				addi $t8,$t3,5
				slt $t7,$t7,$t6
				slt $t8,$t8,$t6
				beq $t7, $t8,isDiagonal

After_isDiagonal:
After_print:	addi $t0,$t0,4		#offset+=4
				addi $t3,$t3,1		#col_count+=1
				addi $t4,$t4,1		#counter+=1
				div $t4,$t6			#get modulo
				mfhi $t7
				bne $t7,$zero,tag1	#still in same row 
				#j Print_endl				
After_row:		addi $t2,$t2, 1		#row_count+=1
		
tag1:			bne $t6, $t3, tag2  #still in same column
				lw $t3, zero($t5)	#col_count=0
tag2:			bne $t1, $t4, loop	#while(counter<elements)
				j Exit
				
Print_num:		move $a0,$t7		#ektupose ton ari8mo
				li	$v0,1
				syscall
				j After_print


Print_endl:		li	$v0,4			#ektupose to endl
				la	$a0,endl	
				syscall		
				j After_row
				
Print_str:		li	$v0,4			#ektupose to str1
				la	$a0,str1	
				syscall		
				
				move $a0,$t2		#ektupose to i
				li	$v0,1
				syscall				
				
				li	$v0,4			#ektupose to str2
				la	$a0,str2	
				syscall
				
				move $a0,$t3		#ektupose to j
				li	$v0,1
				syscall	
				
				bne $t8,1,Exit
				li	$v0,4			#ektupose to diag
				la	$a0,diag	
				syscall
				
				j Exit

isDiagonal:		move $s0, $t2					#temp_counter=row_count
				move $s1, $t3					#col_count_temp
				li $t8,1						#flagDiag=1
				#beq $t2, $t3, isDiagonal_row_eq_count
				#j isDiagonal_row_noteq_count
				
return:			addi $t9, $t2, 5		#row_count+5
				slt $t9,$s0,$t9
				bne $t9,$zero,isDiagonal		#if temp_counter<row_count+5 -> not equal to zero -> isDiagonal
				addi $t9, $t3, 5		#row_count+5
				slt $t9,$s1,$t9
				bne $t9,$zero,isDiagonal
				beq $t8, 1, Print_str #checkfor_print
				j After_isDiagonal
				
				
isDiagonal_row_eq_count: 	beq $t7,$zero, set_flag_zero
							j return		
isDiagonal_row_noteq_count:	bne $t7,$zero, set_flag_zero
							j return

set_flag_zero:			li $t8,0
						j return

Exit:			li	$v0,10		#telos
				syscall