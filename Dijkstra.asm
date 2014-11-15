.data
#matriz del grafo
#se declara infinito a 999

elNumeroEs: .asciiz "\nEl número es: "
desdeNodo: .asciiz " desde el nodo: "
txtEnd: .asciiz "\nPrograma Terminado"
matrizGrafo: .word 0,1,15,999,999,999, 1,0,4,999,10,999, 15,4,0,2,5,999, 999,999,2,0,1,88, 999,10,5,1,0,3, 999,999,999,88,3,0
EA .word 0,0,0,0,0,0
CH .word 999,999,999,999,999,999

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

#funcion para obtener el valor de de la matriz
# entrada $a0=A $a1=B, retorno en $v0
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
