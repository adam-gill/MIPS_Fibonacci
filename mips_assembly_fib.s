# Overall Program Functional Description:
# Print out N Fibonacci Numbers stored in an array


.data

array:          .space 200
strDescrpt:     .asciiz "This program will print out the fibonacci sequence with a length of your choosing.\n"
strDescrpt2:    .asciiz "The length of the sequence cannot be over 46 numbers or an overflow error will occur.\n\n\n"
strAsk:         .asciiz "Enter the number of fibonacci numbers you want to see in the sequence:\n"
strError:       .asciiz "Error: This fibonacci number will result in overflow error."
strNL:          .asciiz "\n"
strResult:      .asciiz "\nYour fibonacci sequence is: \n"




.globl main
.text


main:

    jal description         # jump and link to methods
    jal fib
    jal result


    li $v0, 10              # end program
    syscall


# print fibonacci sequence
    result:
        la $a1, array        # MUST INITIALIZE ARRAY ADDRESS BEFORE CALLING FIB
        loop2:
            
            lw $t2, 0($a1)

            li $v0, 1           # print fib number
            move $a0, $t2
            syscall

            li $v0, 4           # print new line
            la $a0, strNL
            syscall

            addi $a1, $a1, 4    # increment memory to get to next word
            addi $s1, $s1, -1   # decrement counter to print right amount of numbers   

            bgtz $s1, loop2    # loop if counter $s1 isn't zero

        jr $ra              # return to main




    fib:
        la $a1, array           # MUST INITIALIZE ARRAY ADDRESS BEFORE CALLING FIB
        li $t0, 1               # load 1 into $t0
        sw $t0, 0($a1)          # set 1st and 2nd word to $t0
        sw $t0, 4($a1)
        addi $s0, $s0, -2       # decrement counter by 2 to keep in in range

        loop:
            lw $t0, 0($a1)      # load word of memory 0 into $t0
            lw $t1, 4($a1)      # load word of memory 4 into $t1 

            add $t0, $t0, $t1   # add $t0 and $t1 and store into $t0

            sw $t0, 8($a1)      # store $t0 into memeory 8 (3rd word)

            addi $a1, $a1, 4    # increment by 4 bytes to next word        
            addi $s0, $s0, -1   # decrement counter by one to create every fibonacci number needed

            bgtz $s0, loop      # loop again if counter ($s0) isn't 0
            jr $ra              # return to main




# print desription and prompt
    description:
        li $v0, 4               # print description 1                                
        la $a0, strDescrpt
        syscall

        li $v0, 4               # print description 2                                  
        la $a0, strDescrpt2
        syscall

        li $v0, 4               # print statement to ask for input                       
        la $a0, strAsk
        syscall

        li $v0, 5               # takes input               
        syscall

        move $s0, $v0           # store sequence length 
        move $s1, $s0           # store sequence length
        bgt $v0, 46, error      # branch to error if input is over 46
        beqz $v0, end           # end program if user wants "0" fib numbers

        li $v0, 4               # prompt user to their sequence
        la $a0, strResult
        syscall

        jr $ra                  # return to main
    

    error:
        li $v0, 4               # print error message
        la $a0, strError
        syscall

        li $v0, 10              # end program
        syscall

    end:
        li $v0, 10              # end program if user entered 0
        syscall











