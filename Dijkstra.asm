.data
#matriz del grafo
#se declara infinito a 999

elNumeroEs: .asciiz "\nEl número es: "
desdeNodo: .asciiz " desde el nodo: "
txtEnd: .asciiz "\nPrograma Terminado"
matrizGrafo: .word 0,1,15,999,999,999, 1,0,4,999,10,999, 15,4,0,2,5,999, 999,999,2,0,1,88, 999,10,5,1,0,3, 999,999,999,88,3,0
EA .word 1,1,1,1,1,1
CH .word 999,999,999,999,999,999

.text
#se guarda matrizGrafo en $a1
la $t0, matrizGrafo
move $a1, $t0

#definimos a3 para el sp
move $a3, $sp

#variables Globales

add $s0, $zero, $zero #CA costo actual
addi $s1, $zero, 5 #Target
add $s2, $zero, $zero# ACT
add $s3, $zero, 999#inf
addi $s4, $zero, 1# uno

#el programa va aqui
FUNCION:
	add $a0, $zero, $s1
	jal GET_EA
	move $t0, $v0
	bne $s4, $t0, Salir#if EA[T]=1
	#parametros para SET_EA
	add $a0, $zero, $s2
	add $a1, $zero, $zero
	jal SET_EA#se configura  EA[act]=0
	add $t9 , $zero, $s3#CPM=inf
	add $t8 , $zero, $zero#pos=0
	#for(i=0;i<6;i++)
	add $t0, $zero, $zero#I=0
	addi $t5, $zero, 6#seis
	FOR_1:
		add $a0, $zero, $t0#Parametro I para get_EA
		GET_EA
		move $t1, $v0#T1=EA[i]
		bne $t1, $s4, ELSE_1
			#t2 = CP
			add $a0 , $zero, $s2
			add $a1, $zero, $t0
			GET_MATRIX_VAL
			move $t2, $v0
			add $t2, $t2, $s0#T2= CA+ M[ACT][i]
			#t3= CH[i]
			add $a0, $zero,$t0
			GET_CH
			move $t3, $v0
			blt  $t3, $t2 ELSE_2
				#a0 ya es i
				add $a1, $zero, $t2
				SET_CH
			ELSE_2:
			bgt $t2, $t9, ELSE_3
				add $t9, $zero, $2
				add $t8, $zero, $t0
			ELSE_3:
		ElSE_1:
	addi $t0, $t0, 1
	blt $t0, $t5, FOR_1
	add $s0, $zero,$t9#CA= CPM
	
	add $s2, $zero, $t8#ACT = posCPM
	
	#t7=EA[t]
	add $a0, $zero, $s1
	GET_EA
	move $t7, $v0
	beq $t7, $s4, FUNCION

j Print
	
	
	

#funcion para obtener el valor de de la matriz
# entrada $a0=A $a1=B, retorno en $v0
GET_MATRIX_VAL:
	la $t0, matrizGrafo#dir
	addi $t1, $zero , 6 #N
	mul $t1, $a1, $t1#NB
	add $t1, $t1, $a0# NB+A
	sll $t2, $t1, 2#el corrimiento
	add $t2, $t2, $t0#4*I+Dir 
	lw $t3 , 0($t2)
	move $v0, $t3#
	j $ra#return M[A][B]
#entrada EA[$a0] entra el valor dentro de los corchetes
GET_EA:
	la $t0, EA#dir
	sll $t1, $a0, 2#el corrimiento
	add $t2, $t1, $t0#4*I+Dir 
	lw $t3 , 0($t2)
	move $v0, $t3#
	j $ra#return M[A][B]

GET_CH:
	la $t0, CH#dir¡
	sll $t1, $a0, 2#el corrimiento
	add $t2, $t1, $t0#4*I+Dir 
	lw $t3 , 0($t2)
	move $v0, $t3#
	j $ra#return M[A][B]la $t0, matrizGrafo#dir
#retornan en $v0  el valor dentro del arreglos
#se setea el valor de EA[$a0]=$a1
SET_EA:
	la $t0, EA#dir
	sll $t1, $a0, 2#el corrimiento
	add $t2, $t1, $t0#4*I+Dir 
	sw $a1 , 0($t2)
	j $ra#return M[A][B]
#se setea el valor de CH[$a0]=$a1
SET_CH:
	la $t0, EA#dir
	sll $t1, $a0, 2#el corrimiento
	add $t2, $t1, $t0#4*I+Dir 
	sw $a1 , 0($t2)
	j $ra#return M[A][B]

Print:
	li $v0, 4 #Se carga 4 (texto) en $v0
	la $a0, elNumeroEs #Se carga el texto "El Numero es: " en $a0
	syscall #llamada al sistema
	li $v0, 1 #se carga 1 (numero) en v0
	move $a0, $t2 #se mueve $t2 a $a0
	syscall	#llamada al sistema

	li $v0, 4 #Se carga 4 (texto) en $v0
	la $a0, desdeNodo #Se carga el texto "desde el nodo: " en $a0
	syscall #llamada al sistema
	li $v0, 1 #se carga 1 (numero) en v0
	move $a0, $t3 #se mueve $t3 a $a0
	syscall	#llamada al sistema
	jr $ra	#volver al registro de jal





Salir:

li $v0, 4 #Se carga 4 (texto) en $v0
la $a0, txtEnd #Se carga el texto "Programa Terminado" en $a0
syscall #llamada al sistema
