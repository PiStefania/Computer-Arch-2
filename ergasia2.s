.data
	T:	.word 5,0,0,0,0,0
		.word 0,2,0,0,0,0
		.word 0,0,3,0,0,0
		.word 0,0,0,1,0,0
		.word 0,0,0,0,3,0
		.word 1,0,0,0,0,8
	
	elements:  .word 36
	zero:	   .word 0
	
str1:	.asciiz "Sub-matrix at position i = "
str2:	.asciiz " ,j = "
symm:	.asciiz " is symmetric.\n"
diag:	.asciiz " is diagonal.\n"
both:	.asciiz " is symmetric and diagonal.\n"	
endl:	.asciiz "\n"


.text		
.globl main
	
main:
	
	li $t2,0						#row_count
	li $t3,0						#col_count
	li $t4,0						#counter
	li $t5,6						#dimension

	

loop:			beq $t4, 36, Exit		#if counter==elements exit
				li $t1, 1				#flag = 1

				j get5dim_matrix
				
After_checkMatrix:				#if flag==1 print str and print diag
				
				beq $t1, 1, print_Everything_for_diagonal
after_print_diag:

after_matrix:	addi $t3,$t3,1			#col_count+=1
				addi $t4,$t4,1			#counter+=1
				beq $t3,$t5, change_col_row # col_count==dimension
after_change_col_row:
				bne $t4, 36, loop		#if counter!=elements go to loop			
				j Exit

change_col_row:	li, $t3, 0	
				addi $t2,$t2,1			#row_count+=1
			 	j after_change_col_row



print_Everything_for_diagonal:	j Print_str
after_print_str:				j Print_diag



Print_str:		li	$v0,4			#ektupose to str1
				la	$a0,str1	
				syscall	

				move $a0,$t2		#ektupose ton ari8mo i
				li	$v0,1
				syscall


				li	$v0,4			#ektupose to str2
				la	$a0,str2	
				syscall	

				move $a0,$t3		#ektupose ton ari8mo j
				li	$v0,1
				syscall

				j after_print_str




Print_diag:		li	$v0,4			#ektupose to diag
				la	$a0,diag	
				syscall	
				j after_print_diag	
				
Print_num:		move $a0,$t0		#ektupose ton ari8mo
				li	$v0,1
				syscall
				j After_print5

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

loop_matrix5x5:	

				#check if matrix is diagonal so far
				#if(r==c) /* true for diagonal elements */
			    #  if(x[r][c]==0)
			    #    flag=0;
			    #	 break;
		        #else
			    #   if(x[r][c]!=0)
			    #     flag=0;
			    #	  break;	
			    j check_is_Diagonal
after_diagonal:
				addi $t7,$t7,1			#col_count+=1
				addi $t9,$t9,1			#new counter+=1
				addi $t8, $t3, 5					#col_count+5
				beq $t7,$t8, change_col_row_5
after_change_col_row_5:
				bne $t9, 25, loop_matrix5x5		#if new counter!=25 go to loop			

				j After_checkMatrix			



change_col_row_5:addi $t7, $t3,0		#initial column
				addi $t6,$t6,1			#row_count+=1
				j	after_change_col_row_5					

check_is_Diagonal:	
					beq $t6, $t7, diagonal
					j notDiagonal	

diagonal:			mult $t6,$t5		#get and print element
					mflo $t8
					add $t8,$t8,$t7
					li $t0,4
					mult $t8,$t0
					mflo $t8
					lw $t0, T($t8)
					j Print_num
After_print5:
					bne $t0, $zero, after_diagonal
					li $t1, 0
					j after_matrix

notDiagonal:		mult $t6,$t5		#get and print element
					mflo $t8
					add $t8,$t8,$t7
					li $t0,4
					mult $t8,$t0
					mflo $t8
					lw $t0, T($t8)
					beq $t0, $zero, after_diagonal
					li $t1, 0
					j after_matrix					





