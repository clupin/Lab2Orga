.data
#matriz del grafo
#se declara infinito a 999

elNumeroEs: .asciiz "\nEl número es: "
desdeNodo: .asciiz " desde el nodo: "
txtEnd: .asciiz "\nPrograma Terminado"
matrizGrafo: .word 0,9,5,0,0,0,0,0,0,0 ,0,0,0,1,3,0,0,0,0,0 ,0,0,0,0,4,9,0,0,0,0 ,0,0,0,0,0,0,1,3,0,0 ,0,0,0,0,0,0,8,1,6,0 ,0,0,0,0,0,0,0,3,7,0 ,0,0,0,0,0,0,0,0,0,4 ,0,0,0,0,0,0,0,0,0,4 ,0,0,0,0,0,0,0,0,0,1 ,0,0,0,0,0,0,0,0,0,0

.text
#se guarda matrizGrafo en $a1
la $t0, matrizGrafo
move $a1, $t0

#definimos a3 para el sp
move $a3, $sp

#variables
add $t0, $zero, $zero #indice fila
add $t1, $zero, $zero #indice columna
add $t2, $zero, $zero #costo
add $t3, $zero, $zero #origen
add $t5, $zero, $zero #

#Algoritmo de Dijkstra
#se lee la primera posicion de matrizGrafo
lw $t4, 0($a1)
#se guarda la posicion inicial (0,0)
add $t2, $t2, $t4
#se guarda el origen, como es la posicion inicial es 0
add $t3, $t3, $t0

#funcion para obtener el valor de de la matriz
# entrada $a0 $a1
GET_MATRIX_VAL:
	la $t0, matrizGrafo#dir
	addi $t1, $zero , 6 #N
	mul $t1, $a1, $t1#NB
	add $t1, $t1, $0# NB+A
	sll $t2, $t1, 2#el corrimiento
	add $t2, $t2, $t0#4*I+Dir 
	lw $t3 , 0($t2)
	move $v0, $t3#
	j $ra#return M[A][B]

FOR_FILA:
	jal Print
	beq $t1, 9, END_FOR_FILA
	#se cambia el valor del costo, al costo correspondiente a la posicion en la fila
	#se lee la posicion $t0 de matrizGrafo
	sll $t6, $t0, 2
	add $t6, $t6, $a1
	lw $t4, 0($t6)
	add $t2, $zero, $t6
	add $t3, $zero, $t0
	
	#sw $t0, 0($t5)
	addi $t1, $t1, 1	#fila++
	
	j FOR_FILA
	
END_FOR_FILA:
j Salir

Guardar:
	addi $sp, $sp, -8 	# crea espacio para guardar los dato
	sw $t2, 0($sp)		# guarda el costo
	sw $t3, 4($sp)		# guarda el origen
	j Print

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
