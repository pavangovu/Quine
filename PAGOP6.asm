#Name: 		Pavan Kumar Govu
#Professor: 	Dr. Ivor Page
#Course:	CS 3340.HN1 (CS^2 Honors Computer Architecture)
#Due Date:	01 May 2020
#Assignment:	Project 6

#note: make sure to enable 'Self-modifying code' before assembly
#instructions to check for completeness of all instruction types, etc.
	.text
	.globl main
	
	J toMain	
  	ADD $t0 $t1 $t2
  	ADDU $t3 $t4 $t5
 	ADDI $t8 $t9 32767
 	ADDIU $t8 $t9 -32768
 	AND $a0 $a1 $a2
 	OR $a1 $a2 $a3
 	ORI $s0 $s1 32767
 	XOR $s1 $s2 $s3
 	XORI $s1 $s2 32767
 	SUB $s3 $s4 $s5
 	SUBU $s5 $s6 $s7
 	LW $t0 0($a0)
	SW $t0 31767($a0)
	SRL $t0 $t1 31
	SRA $t0 $t1 1
 	SLL $t0 $t1 31
 	SLLV $t0 $t1 $t2
  	SLT $t0 $t1 $t1
 	SLTI $t0 $t1 17
 	SB $t0 0($a0)
 	NOP
 	MULT $t0 $t1
 	MULTU $t0 $t1
  	MFLO $t0
	MFHI $t0
	LUI $t0 32767
	LB $t0 0($a0)
	JR $t0
 	JR $ra
  	ADDI $sp $sp -4
   	JAL func
	func:
   	DIV $t0 $t1
   	DIVU $t0 $t1
   	BNE $t0 $t1 func
   	BEQ $t0 $t1 func
toMain:

#program begins here
main:	la $t0 0x00400000	#marks beginning of the program
	la $t1 closeAppend	#marks the end of program code
	
	li $v0 4
	la $a0 space
	syscall 		#print space for formatting purposes
	
loop: 	lw $a0 ($t0) 		#store instruction in $a0
	li $v0 34
	syscall 		#print hexadecimal adress of instruction
	
	li $v0 4 
	la $a0 colon
	syscall 		#print a colon
	la $a0 tab
	syscall 		#print a tab character
	
	lw $t5 ($t0) 		#store instruction in $t5
	srl $t5 $t5 26 		#opcode stored in $t5
	
	lw $t4 ($t0) 		#store instruction in $t4
	sll $t4 $t4 26
	srl $t4 $t4 26 		#func code stored in $t4
	
	lw $s7 ($t0) 		#for NOP detection
	
	
	li $t3 0
	beq $s7 $t3 isnopins 		#nop instruction is only zeroes
	beq $t5 $t3 rInstruction	#r-type instruction have an opcode of zero
	
	li $t3 2
	beq $t5 $t3 isjins		#jump instruction
	
	li $t3 3
	beq $t5 $t3 isjalins		#jump and link instruction
	
	j jInstruction			#j-type instructions
	
rInstruction:
	li $t3 00
	beq $t4 $t3 issllins
	
	li $t3 2
	beq $t4 $t3 issrlins		
	
	li $t3 3
	beq $t4 $t3 issrains
	
	li $t3 4
	beq $t4 $t3 issllvins
	
	li $t3 6
	beq $t4 $t3 issrlvins
	
	li $t3 8
	beq $t4 $t3 isjrins
	
	li $t3 12
	beq $t4 $t3 issyscallins
	
	li $t3 16
	beq $t4 $t3 ismfhiins
	
	li $t3 18
	beq $t4 $t3 ismfloins
	
	li $t3 24
	beq $t4 $t3 ismultins
	
	li $t3 25
	beq $t4 $t3 ismultuins
	
	li $t3 26
	beq $t4 $t3 isdivins
	
	li $t3 27
	beq $t4 $t3 isdivuins
	
	li $t3 32
	beq $t4 $t3 isaddins
	
	li $t3 33
	beq $t4 $t3 isadduins
	
	li $t3 34
	beq $t4 $t3 issubins
	
	li $t3 35
	beq $t4 $t3 issubuins
	
	li $t3 36
	beq $t4 $t3 isandins
	
	li $t3 37
	beq $t4 $t3 isorins
	
	li $t3 38
	beq $t4 $t3 isxorins
	
	li $t3 42
	beq $t4 $t3 issltins
	
	li $t3 43
	beq $t4 $t3 issltuins

jInstruction:
	li $t3 4
	beq $t5 $t3 isbeqins
	
	li $t3 5
	beq $t5 $t3 isbneins
	
	li $t3 8
	beq $t5 $t3 isaddiins
	
	li $t3 9
	beq $t5 $t3 isaddiuins
	
	li $t3 10
	beq $t5 $t3 issltiins
	
	li $t3 11
	beq $t5 $t3 issltiuins
	
	li $t3 12
	beq $t5 $t3 isandiins
	
	li $t3 13
	beq $t5 $t3 isoriins
	
	li $t3 14
	beq $t5 $t3 isxoriins

	li $t3 15
	beq $t5 $t3 isluiins
	
	li $t3 32
	beq $t5 $t3 islbins
	
	li $t3 35
	beq $t5 $t3 islwins
	
	li $t3 40
	beq $t5 $t3 issbins
	
	li $t3 43
	beq $t5 $t3 isswins

	
issllins:	li $v0 4
		la $a0 slllabel
		syscall
		#I know that it's an add instruction
		#Add is an R type (0)
		li $t7 0
		j printRegister
		#jumpt to register function
		j next
	
isnopins:	li $v0 4
		la $a0 noplabel
		syscall 
		#li $t7 0
		#j printRegister
		j next
		
isjins:		li $v0 4
		la $a0 jlabel
		syscall 
		li $t7 2
		j printRegister
		j next
	
issrlins:	li $v0 4
		la $a0 srllabel
		syscall 
		li $t7 0
		j printRegister
		j next
		
isjalins:	li $v0 4
		la $a0 jallabel
		syscall 
		li $t7 2
		j printRegister
		j next
		
issrains:	li $v0 4
		la $a0 sralabel
		syscall 
		li $t7 0
		j printRegister
		j next
		
isbeqins:	li $v0 4
		la $a0 beqlabel
		syscall 
		li $t7 1
		j printRegister
		j next
		
issllvins:	li $v0 4
		la $a0 sllvlabel
		syscall 
		li $t7 0
		j printRegister
		j next
		
isbneins:	li $v0 4
		la $a0 bnelabel
		syscall 
		li $t7 1
		j printRegister
		j next
		
issrlvins:	li $v0 4
		la $a0 srlvlabel
		syscall 
		li $t7 0
		j printRegister
		j next
		
isaddiins:	li $v0 4
		la $a0 addilabel
		syscall 
		li $t7 0
		j printRegister
		j next
		
isjrins:	li $v0 4
		la $a0 jrlabel
		syscall 
		li $t7 0
		j printRegister
		j next
		
isaddiuins:	li $v0 4
		la $a0 addiulabel
		syscall 
		li $t7 1
		j printRegister
		j next
		
issltiins:	li $v0 4
		la $a0 sltilabel
		syscall 
		li $t7 1
		j printRegister
		j next
		
issltiuins:	li $v0 4
		la $a0 sltiulabel
		syscall
		li $t7 1
		j printRegister 
		j next

isandiins:	li $v0 4
		la $a0 andilabel
		syscall 
		li $t7 1
		j printRegister
		j next
		
issyscallins:	li $v0 4
		la $a0 syscalllabel
		syscall 
		li $t7 0
		j printRegister
		j next
		
isoriins:	li $v0 4
		la $a0 orilabel
		syscall 
		li $t7 1
		j printRegister
		j next
		
isxoriins:	li $v0 4
		la $a0 xorilabel
		syscall 
		li $t7 1
		j printRegister
		j next
		
isluiins:	li $v0 4
		la $a0 luilabel
		syscall 
		li $t7 1
		j printRegister
		j next
		
ismfhiins:	li $v0 4
		la $a0 mfhilabel
		syscall 
		li $t7 0
		j printRegister
		j next
		
ismfloins:	li $v0 4
		la $a0 mflolabel
		syscall 
		li $t7 0
		j printRegister
		j next
		
ismultins:	li $v0 4
		la $a0 multlabel
		syscall
		li $t7 0
		j printRegister
		j next
		
ismultuins:	li $v0 4
		la $a0 multulabel
		syscall
		li $t7 0
		j printRegister 
		j next
		
isdivins:	li $v0 4
		la $a0 divlabel
		syscall 
		li $t7 0
		j printRegister
		j next
		
isdivuins:	li $v0 4
		la $a0 divulabel
		syscall 
		li $t7 0
		j printRegister
		j next
		
islbins:	li $v0 4
		la $a0 lblabel
		syscall 
		li $t7 1
		j printRegister
		j next
		
isaddins:	li $v0 4
		la $a0 addlabel
		syscall 
		li $t7 0
		j printRegister
		j next

isadduins:	li $v0 4
		la $a0 addulabel
		syscall 
		li $t7 0
		j printRegister
		j next
		
issubins:	li $v0 4
		la $a0 sublabel
		syscall 
		li $t7 0
		j printRegister
		j next
		
islwins:	li $v0 4
		la $a0 lwlabel
		syscall 
		li $t7 1
		j printRegister
		j next

issubuins:	li $v0 4
		la $a0 subulabel
		syscall 
		li $t7 0
		j printRegister
		j next
		
isandins:	li $v0 4
		la $a0 andlabel
		syscall 
		li $t7 0
		j printRegister
		j next
		
isorins:	li $v0 4
		la $a0 orlabel
		syscall 
		li $t7 0
		j printRegister
		j next
		
isxorins:	li $v0 4
		la $a0 xorlabel
		syscall 
		li $t7 0
		j printRegister
		j next
		
issbins:	li $v0 4
		la $a0 sblabel
		syscall 
		li $t7 1
		j printRegister
		j next
		
issltins:	li $v0 4
		la $a0 sltlabel
		syscall 
		li $t7 0
		j printRegister
		j next
		
isswins:	li $v0 4
		la $a0 swlabel
		syscall 
		li $t7 1
		j printRegister
		j next
		
issltuins:	li $v0 4
		la $a0 sltulabel
		syscall 
		li $t7 0
		j printRegister
		j next

printRegister:
la $a0 tab
syscall # print tab character

lw $t9 ($t0)
beqz $t7, rType#R type
beq $t7, 1, iType#if $t7
beq $t7, 2, jType

rType:
	li $v0 4
	andi $a0, $t9, 63488
	srl $t6, $a0, 11
	la $t8, registerArray
addi $s0, $0, 4
	mult $t6, $s0
	mflo $s1
	add $t8, $t8, $s1
	lw $a0, 0($t8)
	syscall
	la $a0 comma
	syscall
	#la $a0 tab
	#syscall
	andi $a0, $t9, 65011712
	srl $t6, $a0, 21
	la $t8, registerArray
	addi $s0, $0, 4
	mult $t6, $s0
	mflo $s1
	add $t8, $t8, $s1
	lw $a0, 0($t8)
	syscall
	la $a0 comma
	syscall
	#la $a0 tab
	#syscall
	andi $a0, $t9, 2031616
	srl $t6, $a0, 16
	la $t8, registerArray
addi $s0, $0, 4
	mult $t6, $s0
	mflo $s1
	add $t8, $t8, $s1
	lw $a0, 0($t8)
	syscall
	j next
	
iType:
	li $v0 4
	andi $a0, $t9, 65011712
	srl $t6, $a0, 21
	la $t8, registerArray
addi $s0, $0, 4
	mult $t6, $s0
	mflo $s1
	add $t8, $t8, $s1
	lw $a0, 0($t8)
	syscall
	la $a0 comma
	syscall
	#la $a0 tab
	#syscall
	andi $a0, $t9, 2031616
	srl $t6, $a0, 16
	la $t8, registerArray
addi $s0, $0, 4
	mult $t6, $s0
	mflo $s1
	add $t8, $t8, $s1
	lw $a0, 0($t8)
	syscall
	la $a0 comma
	syscall
	#la $a0 tab
	#syscall
	andi $t6, $t9, 65535
	li $v0 1
	move $a0 $t6
	syscall
	j next
	
jType:
	li $v0 1
	andi $t6, $t9, 67108863
	sll $t6, $t6, 2
	move $a0 $t6

	syscall
	j next
	 #5 bits after code for register one
	 	#print register
	 #next 5 for second register
	 	#print register
	 #next 5 for third register
	 	#print register	 	

		#5 bits after op code for register one 
		#andi with 000..11.00
		#srl 21
		

			#print register
		#next 5 bits register two
			#print register
		#last 16 bits immediate
			#print directly using $v0
			
#jr $ra
	 
	
next: 	li $v0 4
	#la $a0 colon
	#syscall	        #Print a colon
	#la $a0 space
	#syscall		#pring a space
	la $a0 newLine
	syscall
	
	addi $t0 $t0 4 	#Increment t0
	bne $t0 $t1 loop
	
	
gracefulExit: 	li $v0 10
	syscall	
	
closeAppend: 	nop	

#symbols used for various branches
.data
colon:		.asciiz ": "
comma:		.asciiz ", "
space:		.asciiz " "
tab: 		.asciiz "\t"
newLine:	.asciiz "\n "
addlabel: 	.asciiz "add" 
addilabel: 	.asciiz "addi"
addiulabel: 	.asciiz "addiu"
addulabel: 	.asciiz "addu"
andlabel: 	.asciiz "and"
andilabel: 	.asciiz "andi"
beqlabel:       .asciiz "beq"
bnelabel:	.asciiz "bne"
divlabel:	.asciiz "div"
divulabel:	.asciiz "divu"
jlabel:		.asciiz "j"
jallabel:	.asciiz "jal"
jrlabel: 	.asciiz "jr"
lblabel: 	.asciiz "lb"
luilabel:	.asciiz "lui"
lwlabel: 	.asciiz "lw"
mfhilabel:	.asciiz "mfhi"
mflolabel:	.asciiz "mflo"
multlabel:	.asciiz "mult"
multulabel:	.asciiz "multu"
noplabel:	.asciiz "nop"
orlabel: 	.asciiz "or"
orilabel:	.asciiz "ori"
sblabel:	.asciiz "sb"
slllabel:	.asciiz "sll"
sltlabel:	.asciiz "slt"
sltilabel:	.asciiz "slti"
sltiulabel:	.asciiz "sltiu"
sltulabel:	.asciiz "sltu"
sllvlabel:	.asciiz "sllv"
sralabel: 	.asciiz "sra"
srllabel: 	.asciiz "srl"
srlvlabel:	.asciiz "srlv"
sublabel:	.asciiz "sub"
subulabel:	.asciiz "subu"
swlabel:	.asciiz "sw"
syscalllabel:	.asciiz "syscall"
xorlabel:	.asciiz "xor"
xorilabel:	.asciiz "xori"

zero:		.asciiz "$zero"
at:		.asciiz "$at"
v0: 		.asciiz "$v0"
v1:		.asciiz "$v1"
a0:		.asciiz "$a0"
a1:		.asciiz "$a1"
a2:		.asciiz "$a2"
a3:		.asciiz "$a3"
t0:		.asciiz "$t0"
t1:		.asciiz "$t1"
t2:		.asciiz "$t2"
t3:		.asciiz "$t3"
t4:		.asciiz "$t4"
t5:		.asciiz "$t5"
t6:		.asciiz "$t6"
t7:		.asciiz "$t7"
s0:		.asciiz "$s0"
s1:		.asciiz "$s1"
s2:		.asciiz "$s2"
s3:		.asciiz "$s3"
s4:		.asciiz "$s4"
s5:		.asciiz "$s5"
s6:		.asciiz "$s6"
s7:		.asciiz "$s7"
t8:		.asciiz "$t8"
t9:		.asciiz "$t9"
k0:		.asciiz "$k0"
k1:		.asciiz "$k1"
gp:		.asciiz "$gp"
sp:		.asciiz "$sp"
fp:		.asciiz "$fp"
ra:		.asciiz "$ra"

#discovered the magic of arrays
registerArray: 	.word 	zero, at, v0, v1, a0, a1, a2, a3, t0, t1, t2, t3, t4, t5, t6, t7, s0, s1, s2, s3, s4, s5, s6, s7, t8, t9, k0, k1, gp, sp, fp, ra
