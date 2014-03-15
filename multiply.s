#   multiply.s
#   D. Reuben Tanner
#   CS 441
#   3/14/14

    .data
limit:          .word    16               # declare storage for limit of multiplier or multiplicand
multiplier1:    .word    29               # declare storage for multiplier
multiplicand1:  .word    -31              # declare storage for multiplicand
multiplier2:    .word    -29              # declare storage for multiplier
multiplicand2:  .word    -31              # declare storage for multiplicand
multiplier3: 	.word    29        	      # declare storage for multiplier
multiplicand3:  .word    31               # declare storage for multiplicand
    

    .text
#__start:
    
    lw $a0, multiplier1			# move positive multiplier as an argument to multiply
    lw $a1, multiplicand1		# move negative multiplicand as an argument to multiply
    jal multiply                # call multiply
    
    add $v0, $zero, $zero		# zeroing out return register per instructions
    lw $a0, multiplier2			# move negative multiplier as an argument to multiply
    lw $a1, multiplicand2		# move negative multiplicand as an argument to multiply
    jal multiply                # call multiply
    
    add $v0, $zero, $zero		# zeroing out return register per instructions
    lw $a0, multiplier3			# move positive multiplier as an argument to multiply
    lw $a1, multiplicand3		# move positive multiplicand as an argument to multiply
    jal multiply                # call multiply
    
    addi $v0, $zero, 10			# prepare exit
    syscall    	  			    # exit
    
multiply:
    addi $sp, $sp, 24           # make stack space
    sw $s0, 0($sp)              # store save variables
    sw $s1, 4($sp)              # store save variables
    sw $s2, 8($sp)              # store save variables
    sw $s3, 12($sp)             # store save variables
    sw $s4, 16($sp)             # store save variables
    sw $ra, 20($sp)             # store ra
    
    jal abs_val				    # convert multiplier
    move $s0, $v0			    # positive multiplier
    move $s1, $v1			    # sign of multiplier (1 if negative, 0 if positive)
       
    move $a0, $a1 	            # load multiplicand
    jal abs_val				    # convert multiplicand
    move $s2, $v0			    # positive multiplicand
    move $s3, $v1			    # sign of multiplicand (1 if negative, 0 if positive)
    
    move $t0, $s0               # move multiplier into temporary variable
    move $t1, $s2               # move multiplicand into temporary variable
    lw $t2, limit               # load limit 
    
    bge $t1, $t0, skipswap		# whichever one is bigger, we want to be the multiplicand
    move $t3, $t1			    # if the multiplier is smaller than the multiplicand, swap them
    move $t1, $t0			    # swap
    move $t0, $t3			    # swap
    skipswap:				    # in both cases, the multipler is now in $t0 and multiplicand in $t1
    add $t4, $zero, $zero		# zero out the product register
    
    #now, they are both positive and the multiplicand is greater than or equals to the multiplier
    loop:
    andi $t5, $t0, 1			# bit mask the multipler to see if the LSB is a 1
    beq $t5, $zero, shifts		# if it's not a 1, just go do the shifts and decrement the counter
    add $t4, $t4, $t1			# if it is a 1, sum the product and the multiplicand
    shifts:
    sll $t1, $t1, 1			    # shift the multiplicand left
    srl $t0, $t0, 1			    # shift the multiplier right
    addi $t2, $t2, -1			# decrement the counter
    bne $t2, $zero, loop		# if we haven't multiplied all 16 bits, keep looping
    
    move $v0, $t4			    # move product to return register
    
    add $s4, $s1, $s3			# 0 means both positive, 1 means one was negative, 2 means both negative so number should be positive
        
    addi $s1, $zero, 1			# prepare a register with a 1 for comparison
    bne $s1, $s4, sign			# if the added signs are equal to 1, we need to negate this product
    nor $v0, $v0, $zero			# flip bits
    addi $v0, $v0, 1			# add 1
    sign:
      
    lw $s0, 0($sp)              # restore save variables
    lw $s1, 4($sp)              # restore save variables
    lw $s2, 8($sp)              # restore save variables
    lw $s3, 12($sp)             # restore save variables
    lw $s4, 16($sp)             # restore save variables
    lw $ra, 20($sp)             # restore ra
    addi $sp, $sp, -24          # restore stack space

    jr $ra                      # return to main

abs_val:
    move $v0, $a0               # number to convert
    add $v1, $zero, $zero		# assume number is positive, if it's not the return sign will be taken care of
    bgt $v0, $zero, skip        # if it's not negative, don't convert it
    addi $v1, $zero, 1			# this number is negative, we must remember its sign
    nor $v0, $v0, $zero         # flip the bits
    addi $v0, $v0, 1            # add 1, no need to check for overflow since we are dealing with 16 bit numbers
    skip:
    jr $ra                      # return 
