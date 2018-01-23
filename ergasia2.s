.data
	T:	.word 5,0,0,0,0,4
		.word 0,2,0,0,0,2
		.word 0,0,10,0,0,0
		.word 0,0,0,-20,0,-10
		.word 0,0,0,0,3,0
		.word 0,2,0,4,3,0
	
	elements:  .word 36
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
	
	lw $t1, elements($t0)			#noOfElements
	li $t2,0						#row_count
	li $t3,0						#col_count
	li $t4,0						#counter
	li $t5,6						#dimension
	

loop:			beq $t4, $t1, Exit		#if counter==elements exit
				j get5dim_matrix
after_matrix:	addi $t3,$t3,1			#col_count+=1
				addi $t4,$t4,1			#counter+=1
				beq $t3,$t5, change_col_row # col_count==dimension
after_change_col_row:
				bne $t4, $t1, loop		#if counter!=elements go to loop			
				j Exit

change_col_row:	li, $t3, 0	
				addi $t2,$t2,1			#row_count+=1
			 	j after_change_col_row



				
Print_num:		move $a0,$t0		#ektupose ton ari8mo
				li	$v0,1
				syscall
				j After_print5


Print_endl:		li	$v0,4			#ektupose to endl
				la	$a0,endl	
				syscall		
				j after_endl5
				

Exit:			li	$v0,10		#telos
				syscall



get5dim_matrix:	#check if matrix 5x5 can be computed
				addi $t6, $t2, 5					#row_count+5
				sle $t6, $t6, $t5					#result<6
				bne $t6,1, after_matrix				#return

				addi $t6, $t3, 5					#col_count+5
				sle $t6, $t6, $t5					#result<6
				bne $t6,1, after_matrix				#return

				#must get 5x5 matrix
				#$t6 = new row_count
				#$t7 = new col_count
				#$t9 = new counter

				addi $t6, $t2,0
				addi $t7, $t3,0
				li $t9, 0				#new counter == 0  must be less than 25

loop_matrix5x5:	mult $t6,$t5		#get and print element
				mflo $t8
				add $t8,$t8,$t7
				li $t0,4
				mult $t8,$t0
				mflo $t8
				lw $t0, T($t8)

				j Print_num
				
After_print5:	addi $t7,$t7,1			#col_count+=1
				addi $t9,$t9,1			#new counter+=1
				addi $t8, $t3, 5					#col_count+5
				beq $t7,$t8, change_col_row_5
after_change_col_row_5:
				bne $t9, 25, loop_matrix5x5		#if new counter!=25 go to loop			

				j after_matrix			



change_col_row_5:addi $t7, $t3,0		#initial column
				addi $t6,$t6,1			#row_count+=1
				j Print_endl
after_endl5:	j	after_change_col_row_5					