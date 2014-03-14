#multiplying things
    .data
limit:        .word    16                # declare storage for limit of multiplier or multiplicand
multiplier:    .word    2                # declare storage for multiplier
multiplicand:    .word    4                # declare storage for multiplicand    

    .text
#__start:
    lw    $a0, multiplier                # load multiplier into $t0
    lw    $a1, multiplicand            # load multiplicand into $t1
    lw    $a2, limit                # load limit into $t2
    j multiply                    # call multiply
            
multiply:
    addi $sp, $sp, 16                # make stack space
    sw $s0, 0($sp)                    # store save variables...just in case
    sw $s1, 4($sp)                    # store save variables...just in case
    sw $s2, 8($sp)                    # store save variables...just in case
    sw $s3, 12($sp)                    # store save variables...just in case
    
    move $t0, $a0                    # move multiplier into temporary variable
    move $t1, $a1                    # move multiplicand into temporary variable
    move $t2, $a2                    # move limit into temporary variable
    
    # convert both numbers to positive, storing their signs and returning them in their twos complement form
    # 
    loop:
    

    lw $s0, 0($sp)                    # restore save variables
    lw $s1, 4($sp)                    # restore save variables
    lw $s2, 8($sp)                    # restore save variables
    lw $s3, 12($sp)                    # restore save variables
    addi $sp, $sp, -16                # restore stack space