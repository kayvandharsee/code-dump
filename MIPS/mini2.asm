	.data 
str:		.asciiz "Input a string 30 characters or less: "
int:		.asciiz "Input an integer greater than 0: "
shift:		.asciiz "Shifted string = "
buffer:		.space 31
buffer2:	.space 32
bufferSize:	.word 31
error1:		.asciiz "No input. Run again."
error2:		.asciiz "Wrong input. Run again"
newline:	.asciiz "\n"
negative:	.asciiz "-"
zero:		.asciiz "0"
openBracket:	.asciiz "["
closedBracket:	.asciiz "]"
shiftInt:	.space 32

	.text
	.globl __start
__start:
	la $a0, str		# Prints input message 1
	li $v0, 4
	syscall

	lw $t0, bufferSize	# Gets input
	la $a0, buffer
	add $a1, $t0, $zero
	li $v0, 8
	syscall
	
	la $t1, buffer		# stores initial address	
	lb $t2, newline
	lb $t3, ($t1)
	beq $t3, $t2, Error1	# checks for newline and sends to error
	li $t4, 0		# counter for newlineCheck
	addi $t0, $t0, -2	# char cap for newlineCheck

newlineCheck:			# if array is at limit, we need to add a newline
	beq $t0, $t4, newlineAdd
	addi $t1, $t1, 1	# increment byte pointer
	lb $t3, ($t1)
	beq $t3, $t2, Return	# checks if newline exist
	addi $t4, $t4, 1	# increment counter first as 0 index is not newline. count will help with shift
	j newlineCheck
	
Return:				# integer prompt begins
	la $a0, int		# asks for input for integer
	li $v0, 4
	syscall
	
	addi $t0, $t0, 2	# sets bufferSize temporary variable back to original value
	la $a0, shiftInt	# gets user input
	addi $a1, $t0, 1	# adds an extra bit for "-"
	li $v0, 8
	syscall
	
	la $t5, shiftInt	# checks if int is 0, negative, or \n respectively
	lb $t3, ($t5)
	lb $t6, zero
	lb $t7, negative
	beq $t3, $t6, Error2	
	beq $t3, $t7, Error2
	beq $t3, $t2, Error2

	li $t1, 0		# sert $a0 to zero
	li $t8, 0		# counter for overflow
	li $t9, 9		# max digits before overflow
	addi $t4, $t4, 1	# adds 1 to count to get string length
	
strToInt:
	beqz $t3, Outcome1		# breaks if value is null or newline which is the end
	beq $t3, $t2, Outcome2
	sub $t7, $t3, $t6	# subtracting ASCII 0 from ASCII char to get int value
	mul $t1, $t1, 10
	add $t1, $t1, $t7
	addi $t8, $t8, 1	# increment digit count
	addi $t5, $t5, 1	# shift to next digit
	lb $t3, ($t5)
	beq $t8, $t9, Remainder	# divide and get remainder to prevent overflow
	j strToInt
	
Outcome1:
	la $a0, newline		# need to add the newline first before flowing to outcome2
	li $v0, 4
	syscall	
		
Outcome2:
	div $t1, $t4
	mfhi $t1		# replace number with remainder

shiftByIndex:
	la $t3, buffer
	add $t3, $t3, $t1 	# shift byte of buffer to start of shift
	lb $t5, ($t3)
	
	la $t6, buffer2
	addi $t6, $t6, 1	# to keep space for square brackets
	li $t0, 0		# counter to end shiftLoop
	
shiftLoop:			# checks if string is copied, then checks if newline or null was reached
	beq $t0, $t4, End
	beq $t5, $t2, resetIndex
	beqz $t5, resetIndex
	sb $t5, ($t6)
	addi $t3, $t3, 1
	addi $t6, $t6, 1
	lb $t5, ($t3)
	addi $t0, $t0, 1
	j shiftLoop

End:
	lb $t7, closedBracket
	sb $t7, ($t6)
	
	addi $t6, $t6, 1
	sb $zero, ($t6)
	
	lb $t7, openBracket
	la $t6, buffer2
	sb $t7, ($t6)
	
	la $a0, shift
	li $v0, 4
	syscall
	
	la $a0, buffer2
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall
	
resetIndex:
	la $t3, buffer
	lb $t5, ($t3)
	j shiftLoop
	
Remainder:
	div $t1, $t4
	mfhi $t1		# replace 9 digit number with remainder
	li $t8, 2		# reset counter to two to prevent overflow, as remainder will never be more than 29
	j strToInt

Error2:
	la $a0, error2
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall

Error1:
	la $a0, error1		# prints error message and terminates
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall

newlineAdd:			# adds newline before integer prompt
	la $a0, newline
	li $v0, 4
	syscall
	j Return