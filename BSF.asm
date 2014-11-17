.data
#matriz del grafo
#se declara infinito a 999

laResp: .asciiz "\nLa respuesta es: "
desdeNodo: .asciiz " desde el nodo: "
txtEnd: .asciiz "\nPrograma Terminado"
matrizGrafo: .word 0,1,15,999,999,999,999,999, 1,0,4,999,5,999,999,999, 15,4,0,2,57,999,1,999, 999,999,2,0,1,88,999,999, 999,5,57,1,0,3,999,999, 999,999,999,88,3,0,999,999, 999,999,1,999,999,999,0,8, 999,999,999,999,999,999,8,0
EA: .word 1,1,1,1,1,1,1,1
CH: .word 999,999,999,999,999,999,999,999

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
addi $s5, $zero, 8#MAX = 8

#el programa va aqui
FUNCION:
	add $a0, $zero, $s1	#$a0=Target
	jal GET_EA	#get EA[target]
	move $t0, $v0
	bne $s4, $t0, Salir#if EA[T]=1
	#parametros para SET_EA
	add $a0, $zero, $s2#$a0=ACT
	
	add $a1, $zero, $zero#$a1=0
	jal SET_EA#se configura  EA[act]=0
	
	add $t9 , $zero, $s3#CPM=inf
	add $t8 , $zero, $zero#pos=0
	#for(i=0;i<6;i++)
	add $t0, $zero, $zero#I=0
	addi $t5, $zero, 6#seis
	FOR_1:
		add $a0, $zero, $t0#Parametro I para get_EA
		jal GET_EA
		move $t1, $v0#T1=EA[i]
		bne $t1, $s4, ELSE_1
			#SET_CH
			#CH[actual] = inf
			#CH[$a0]=$a1
			add $a0, $zero, $s2#$a0=ACT
			add $a1, $zero, $s3#$a1=inf
			jal SET_CH#set CH[actual] = inf
			#t2 = CP
			add $a0 , $zero, $s2#$a0= ACT
			add $a1, $zero, $t0#$a1= i
			jal GET_MATRIX_VAL
			move $t2, $v0
			add $t2, $t2, $s0#CP=T2= CA+ M[ACT][i]
			#t3= CH[i]
			add $a0, $zero,$t0#$a0=i
			jal GET_CH
			move $t3, $v0
			ble  $t3, $t2 ELSE_2
			#blt  $t3, $t2 ELSE_2
				
				add $a0, $zero, $t0#$a0=i
				add $a1, $zero, $t2
				jal SET_CH#set costo hacia
			ELSE_2:
			bge $t2, $t9, ELSE_3
			#bgt $t2, $t9, ELSE_3
				add $t9, $zero, $t2
				add $t8, $zero, $t0
			ELSE_3:
		ELSE_1:
	addi $t0, $t0, 1
	blt $t0, $t5, FOR_1
	#CA=buscarMinimo(); ---> $v0 = min
	jal FIND_MIN
	add $s0, $zero,$v0#CA= min
	#add $s0, $zero,$t9#CA= CPM
	
	add $s2, $zero, $t8#ACT = posCPM
	
	#t7=EA[t]
	add $a0, $zero, $s1
	jal GET_EA
	move $t7, $v0
	beq $t7, $s4, FUNCION

#se obtiene el ultimo valor de CH
addi $a0, $zero, 5
jal GET_CH
move $t2, $v0#T1=EA[i]
jal Print
j Salir
	

#funcion para obtener el valor de de la matriz
# entrada $a0=A $a1=B, retorno en $v0
GET_MATRIX_VAL:
	#la $t0, matrizGrafo#dir
	#addi $t1, $zero , 6 #N
	#mul $t1, $a1, $t1#NB
	#add $t1, $t1, $a0# NB+A
	#sll $t2, $t1, 2#el corrimiento
	#add $t2, $t2, $t0#4*I+Dir 
	#lw $t3 , 0($t2)
	#move $v0, $t3#
	#j $ra#return M[A][B]
	
	la $a2, matrizGrafo#dir
	
	addi $a3, $zero , 6 #N
	mul $a3, $a1, $a3#NB
	add $a3, $a3, $a0# NB+A
	
	sll $a3, $a3, 2#el corrimiento
	add $a3, $a3, $a2#4*I+Dir
	lw $a1 , 0($a3)
	move $v0, $a1# 
	
	jr $ra#return M[A][B]
	
	
#entrada EA[$a0] entra el valor dentro de los corchetes
GET_EA:
	#la $t0, EA#dir
	#sll $t1, $a0, 2#el corrimiento
	#add $t2, $t1, $t0#4*I+Dir 
	#lw $t3 , 0($t2)
	#move $v0, $t3#
	#j $ra#
	la $a2, EA#dir
	sll $a0, $a0, 2#el corrimiento
	add $a0, $a0, $a2#4*I+Dir
	lw $a1 , 0($a0)
	move $v0, $a1# 
	jr $ra#return EA[$a0]

GET_CH:
	#la $t0, CH#dir�
	#sll $t1, $a0, 2#el corrimiento
	#add $t2, $t1, $t0#4*I+Dir 
	#lw $t3 , 0($t2)
	#move $v0, $t3#
	#j $ra#
	la $a2, CH#dir
	sll $a0, $a0, 2#el corrimiento
	add $a0, $a0, $a2#4*I+Dir
	lw $a1 , 0($a0)
	move $v0, $a1# 
	jr $ra#return null
	
#retornan en $v0  el valor dentro del arreglos

#se setea el valor de EA[$a0]=$a1
SET_EA:
	la $a2, EA#dir
	sll $a0, $a0, 2#el corrimiento
	add $a0, $a0, $a2#4*I+Dir 
	sw $a1 , 0($a0)
	jr $ra#return null
#se setea el valor de CH[$a0]=$a1
SET_CH:
	la $a2, CH#dir
	sll $a0, $a0, 2#el corrimiento
	add $a0, $a0, $a2#4*I+Dir 
	sw $a1 , 0($a0)
	jr $ra#return null
	
FIND_MIN:
	add $t5, $zero, $s3	#$t5 = 999
	add $t6, $zero, $zero	#$t6 = 0
	move $t7, $ra	#guardamos el antiguo valor de $ra
	FOR:
		add $a0, $zero, $t6	#Parametro I para get_CH
		jal GET_CH
		move $t4, $v0	#$t4=CH[i]
		bge $t4, $t5, ELSE	#if(CH[i]<999)
			add $t5, $zero, $t4	#$t5 = CH[i]
		ELSE:
	addi $t6, $t6, 1
	blt $t6, $s5, FOR
	move $v0, $t5#	se guarda en v0 el valor de t5
	move $ra, $t7	#devolvemos el valor de $ra de antes de GET_CH
	jr $ra	
STACK_LOAD:
	lw $v0 0($sp)
	addi $sp, $sp, 4
	jr $ra
STACK_STORE:
	addi $sp, $sp, -4
	sw $a0 0($sp)
	jr $ra
		
Print:
	li $v0, 4 #Se carga 4 (texto) en $v0
	la $a0, laResp #Se carga el texto "La Respuesta es: " en $a0
	syscall #llamada al sistema
	li $v0, 1 #se carga 1 (numero) en v0
	move $a0, $t2 #se mueve $t2 a $a0
	syscall	#llamada al sistema
	jr $ra	#volver al registro de jal

Salir:

li $v0, 4 #Se carga 4 (texto) en $v0
la $a0, txtEnd #Se carga el texto "Programa Terminado" en $a0
syscall #llamada al sistema
