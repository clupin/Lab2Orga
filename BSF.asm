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
	#EA[$a0]=$a1
	add $a0, $zero, $s2
	add $a1, $zero, $zero
	jal SET_EA	#se configura  EA[act]=0
	#if(EA[target]==0)
	#obtener EA[target] EA[$a0]
	add $a0, $zero, $s1
	jal GET_EA
	move $t0, $v0 #guarda en $t0=EA[target]
	
	beq $t0, $zero, ELSE_1
	jal UPDATE_CH	#guarda en CH los valores desde la posicion actual
	jal FIND_MIN	#v0 valor minimo, v1 posicion valor minimo
	move $t0, $v0	#$t0=$v0
	move $t1, $v1	#$t1=$v1
	#if(valor de FIND_MIN == 999)
	bne $s3, $t0, ELSE_2
	#devolverse
	jal STACK_LOAD
	#en v0 esta el valor de STACK_LOAD
	sub $s0, $s0, $v0	#CA-=v0
	jal STACK_LOAD
	#en v0 esta la posicion de STACK_LOAD
	add $s2, $zero, $v0	#seteamos en actual la posicion de v0
	j FUNCION
	
	ELSE_2:
	#STACK_STORE actual
	add $a0,$zero,$s2	#a0 = actual
	jal STACK_STORE
	add $a0,$zero,$t0	#a0 = valor de FIND_MIN
	jal STACK_STORE
	add $s2, $zero, $t1	#actual=minPOS
	add $s0, $s0, $t0	#CA+=minVAL
	#funcion(actual, target)
	j FUNCION	
	ELSE_1:
	
	add $a0, $zero, $s0
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
	FOR_FM:
		add $a0, $zero, $t6	#Parametro I para get_CH
		jal GET_CH
		move $t4, $v0	#$t4=CH[i]
		bge $t4, $t5, ELSE	#if(CH[i]<999)
			add $t5, $zero, $t4	#$t5 = CH[i]
			move $v1, $t6
		ELSE:
	addi $t6, $t6, 1
	blt $t6, $s5, FOR_FM
	move $v0, $t5#	se guarda en v0 el valor de t5
	move $ra, $t7	#devolvemos el valor de $ra de antes de GET_CH
	jr $ra	#v0 valor minimo, v1 posicion valor minimo
UPDATE_CH:
	add $t6, $zero, $zero	#$t6 = 0 = i
	move $t7, $ra	#guardamos el antiguo valor de $ra
	FOR_UP:
		add $a0, $zero, $s2
		add $a1, $zero, $t6#M[ACT][i]
		jal GET_MATRIX_VAL
		move $t5, $v0
		#if(EA[i]=1)
		add $a0, $zero, $t6	#Parametro I para get_EA
		jal GET_EA
		move $t4, $v0	#$t4=EA[i]
		bne $t4, $s4 ELSE_update1
			#$a0=$t5
			move $a0, $t6
			move $a1, $t5
			jal SET_CH
		ELSE_update1:
	addi $t6, $t6 ,1
	blt $t6, $s5, FOR_UP
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
