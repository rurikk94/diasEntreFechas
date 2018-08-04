.data

fechaAtxt: .asciiz "Ingrese la fecha A $t0"
fechaBtxt: .asciiz "Ingrese la fecha B $t4"
finalizatxt: .asciiz "Finalizo el programa"
anofechaAtxt: .asciiz "La ano A es "
mesfechaAtxt: .asciiz "La mes A es "
diafechaAtxt: .asciiz "La dia A es "
anofechaBtxt: .asciiz "La ano B es "
mesfechaBtxt: .asciiz "La mes B es "
diafechaBtxt: .asciiz "La dia B es "
cantidadDiastxt: .asciiz "La cantidad de dias de diferencia es "


.text
.globl main
# __________________________________________________________________________________________
main:
# __________________________________________________________________________________________

 li $t6,1 # almacena en t6 un 1

 main1: #etiqueta main1

 beq $t6,$t6,ingresodatos # $t0=fechaA, $t4=fechaB | salta a ingresodatos
 volverMenuPrincipal:

 #en t0 guardamos la cantidad de dias de diferencia
 addi $t0,$zero,0 # inicializamos en 0

 # los datos quedan en las siguientes variables
 # CantidadDias t0
 # Fecha A Ano t1, Mes t2, Dia t3
 # Fecha B Ano t5, Mes t6, Dia t7
	beq $t4,$t4,condicionCalculoDias	

      
    calculoDias:
	#diasMaxMes=0;   
	addi $t8,$t8,0    #t8 guardamos diaMaxMes
	
		# colocamos v0 para que muestre un numero
		 sub $v0,$v0,$v0     # v0 = 0
		 addi $v0,$v0,1      # v0 = 1

		#dejamos en a0 el numero a mostrar t2
		 add $a0,$zero, $t3
		 syscall
	loopCalculoDias:
	
        # cantidadDias++;
        # diaA++;
         addi $t0,$t0,1
         addi $t3,$t3,1
		 
		 #calculo del dia maximo del mes

										verMesesAntesJulio:
										# if (mesA < 8)
											addi $t4,$zero,8
											slt $t4,$t2,$t4
											beq $t4,$zero,verMesesDespuesDeJulioB
											
											
											MesFebreroB:
											# si mesA = 2
											addi $t4,$zero,2
											bne $t2,$t4,sinoEsFebrero
											
											  
													# (((anoA % 4) == 0) && ((anoA % 100) != 0))

													# (anoA % 4) == 0
														 addi $t4,$zero,4
														 div $t1, $t4
														 mfhi $t4

														bne $t4, $zero, MesArevisaOrB   # si el resto (t4) es 0  revisa la otra condicion, sino revisa el OR

													 # (anoA % 100) != 0
													 addi $t4,$zero,100
													 div $t1, $t4
													 mfhi $t4

													 beq $t4, $zero, MesANoAnoBisiestoB   # si el resto (t4) no es 0 entonces el ano es bisiesto y salta a sumarle 29, sino revisa el OR
													 MesAanoBisiestoB:
																addi $t8,$zero,29        # establecemos el maximo como 29																
																beq $t4, $t4, revisarDias  # va a  sumar 1 mes al contador mesA (t2)

													 MesArevisaOrB:
														# ((anoA % 400) == 0)
														addi $t4,$zero,400
														div $t1, $t4
														mfhi $t4

														bne $t4, $zero, MesANoAnoBisiestoB   # si es igual a 0, el ano es bisiesto

																

														MesANoAnoBisiestoB:
																addi $t8,$zero,28        # establecemos el maximo como 28
																beq $t4, $t4, revisarDias  # va a  sumar 1 mes al contador mesA (t2)
											
										# Si no es febrero	

										sinoEsFebrero:
										# if (mesA % 2 != 0)
										 addi $t4,$zero,2
										 div $t2, $t4
										 mfhi $t4
										 beq $t4, $zero, establecerTreintaDiasB
										 # si el resto (t4) es 0 entonces el mes tiene 30 dias, sino le suma 31
														addi $t8,$zero,31        # establecemos el maximo como 31
														beq $t4,$t4,revisarDias
												establecerTreintaDiasB:
														addi $t8,$zero,30        # establecemos el maximo como 30
														beq $t4,$t4,revisarDias

										verMesesDespuesDeJulioB:
										# if (mesA > 7)
													# if (mesA % 2 == 0)
													 addi $t4,$zero,2
													 div $t2, $t4
													 mfhi $t4
													 bne $t4, $zero, sumarTreintaUnoDiasB
													 
													 # si el resto (t4) no es 0, entonces el mes tiene 31 dias, sino lo establece en 30
																	addi $t8,$zero,31        # establecemos el maximo como 31
																	beq $t4,$t4,revisarDias
															sumarTreintaUnoDiasB:
																	addi $t8,$zero,30        # establecemos el maximo como 31	
																	beq $t4,$t4,revisarDias
		
		 

					revisarDias:
					# if (31<diaA)
					#       diaA = 1;
					#       mesA++;
					add $t4,$zero,$t8	# t4 <- t8 diasMaxMes
					slt $t4,$t4,$t3     # si t4 diasMaxMes<diaA  ->  t4=1 sino t4=0
					
					beq $t4,$zero,condicionCalculoDias
								addi $t3,$zero,1
								addi $t2,$t2,1
								
					revisarMes:
					# if (12<MesA)
					#       MesA = 1;
					#       AnoA++;
					addi $t4,$zero,12	# t4 <- 12 diasMaxMes
					slt $t4,$t4,$t2     # si t4 diasMaxMes<diaA  ->  t4=1 sino t4=0
					
					beq $t4,$zero,condicionCalculoDias
								addi $t2,$zero,1
								addi $t1,$t1,1
					

    condicionCalculoDias:
    # while ((anoA<anoB) || (mesA <mesB) || (diaA < diaB))
	
        conAnoD:
            slt $t4,$t1,$t5                #si anoA < anoB        ->        t4=1    sino t4=0
            bne $t4,$zero,loopCalculoDias
        conMesD:
            slt $t4,$t2,$t6                #si mesA < mesB        ->        t4=1    sino t4=0
            bne $t4,$zero,loopCalculoDias
        conDiaD:
            slt $t4,$t3,$t7                #si diaA < diaB        ->        t4=1    sino t4=0
            bne $t4,$zero,loopCalculoDias



 beq $t6,$t6,imprimirCantidadDias
 casteoFinalizar:

 beq $t6,$t6,finaliza
 # __________________________________________________________________________________________
ingresodatos: # $t0=fechaA, $t4=fechaB
# __________________________________________________________________________________________
# pedimos el ingreso de la fecha A
# guardandola en $t0

# solicitamos el ingreso de la fecha A
# funcion escritura: $v0=4 , $a0 = @texto a escribir
#mostramos mensaje
 li $v0,4
 la $a0,fechaAtxt
 syscall
# leemos el numero
 addi $v0,$zero,5
 syscall
# guardamos el numero en $t0
 add $t0,$zero,$v0

# pedimos el ingreso de la fecha B
# guardando en $t4

#mostramos mensaje
 li $v0,4
 la $a0,fechaBtxt
 syscall
# leemos la fecha B
 addi $v0,$zero,5
 syscall
# guardamos la fecha B en $t4
 add $t4,$zero,$v0

 beq $t6,$t6,descomponerAnoA # $t0=fechaA
 casteoAnoA:

 beq $t6,$t6,descomponerDiaA # $t0=fechaA
 casteoDiaA:

 beq $t6,$t6,descomponerMesA # $t0=fechaA
 casteoMesA:


 beq $t6,$t6,descomponerAnoB # $t4=fechaA
 casteoAnoB:

 beq $t6,$t6,descomponerDiaB # $t4=fechaA
 casteoDiaB:

 beq $t6,$t6,descomponerMesB # $t4=fechaA
 casteoMesB:


 beq $t6,$t6,volverMenuPrincipal


# __________________________________________________________________________________________
descomponerAnoA:

# ya tenemos la fecha en $t0. utilizamos variables $t1,$t2,$t3

 # fechaA % 10000 = ano 31->LO

addi $t6,$zero,10000
div $t0, $t6
mflo $t1

#imprimimos el ano

#  li $v0,4
#  la $a0,anofechaAtxt
#  syscall

# colocamos v0 para que muestre un numero
# sub $v0,$v0,$v0     # v0 = 0
# addi $v0,$v0,1      # v0 = 1

#dejamos en a0 el numero a mostrar t1
# add $a0,$zero, $t1
#  syscall


#volvemos al main
 beq $t6,$t6,casteoAnoA


# __________________________________________________________________________________________
descomponerMesA:

# ((fechaA % 10000) - (fechaA % 100)) / 100 = Mes -> LO
# ((19650331 % 10000)  - (19650331 % 100)) /100 = Mes -> LO
# ((19650331 % 10000)  - Dia) /100 = Mes -> LO

addi $t6,$zero,10000    #t6 <- 10000
div $t0, $t6    # t0 / t6   19650331 / 10000 =  = 1965.0331
mfhi $t2    # t2 <- cociente anterior = 0331

sub $t2,$t2,$t3 #t2 - t3 = lo anterior - dia    0331 - 31 = 0300

addi $t6,$zero,100  #t6 <- 100
div $t2, $t6    #t2 / t6        0300 / 100
mflo $t2

#imprimimos el mes

#  li $v0,4
#  la $a0,mesfechaAtxt
#  syscall

# colocamos v0 para que muestre un numero
# sub $v0,$v0,$v0     # v0 = 0
# addi $v0,$v0,1      # v0 = 1

#dejamos en a0 el numero a mostrar t2
# add $a0,$zero, $t2
# syscall


#volvemos al ingreso datos
 beq $t6,$t6,casteoMesA


# __________________________________________________________________________________________
descomponerDiaA:

# fechaA % 100 = dia      19650331 % 100 = 31  31->HI

addi $t6,$zero,100
div $t0, $t6
mfhi $t3

#imprimimos el dia

#  li $v0,4
#  la $a0,diafechaAtxt
#  syscall

# colocamos v0 para que muestre un numero
# sub $v0,$v0,$v0     # v0 = 0
# addi $v0,$v0,1      # v0 = 1

#dejamos en a0 el numero a mostrar t3
# add $a0,$zero, $t3
#  syscall


#volvemos al ingreso datos
 beq $t6,$t6,casteoDiaA


# __________________________________________________________________________________________
descomponerAnoB:

# ya tenemos la fecha en $t0. utilizamos variables $t1,$t2,$t3

 # fechaA % 10000 = ano 31->LO

addi $t6,$zero,10000
div $t4, $t6
mflo $t5

#imprimimos el ano

#  li $v0,4
#  la $a0,anofechaBtxt
#  syscall

# colocamos v0 para que muestre un numero
# sub $v0,$v0,$v0     # v0 = 0
# addi $v0,$v0,1      # v0 = 1

#dejamos en a0 el numero a mostrar t5
# add $a0,$zero, $t5
#  syscall


#volvemos al main
 beq $t6,$t6,casteoAnoB


# __________________________________________________________________________________________
descomponerMesB:

# ((fechaB % 10000) - (fechaB % 100)) / 100 = Mes -> LO
# ((19650331 % 10000)  - (19650331 % 100)) /100 = Mes -> LO
# ((19650331 % 10000)  - Dia) /100 = Mes -> LO

addi $t0,$zero,10000    #t0 <- 10000
div $t4, $t0    # t4 / t0   19650331 / 10000 =  = 1965.0331
mfhi $t6    # t6 <- cociente anterior = 0331

sub $t6,$t6,$t7 #t6 - t7 = lo anterior - dia    0331 - 31 = 0300

addi $t0,$zero,100  #t6 <- 100
div $t6, $t0    #t2 / t0        0300 / 100
mflo $t6

#imprimimos el mes

#  li $v0,4
#  la $a0,mesfechaBtxt
#  syscall

# colocamos v0 para que muestre un numero
# sub $v0,$v0,$v0     # v0 = 0
# addi $v0,$v0,1      # v0 = 1

#dejamos en a0 el numero a mostrar t6
# add $a0,$zero, $t6
#  syscall


#volvemos al ingreso datos
 beq $t6,$t6,casteoMesB



# __________________________________________________________________________________________
descomponerDiaB:

# fechaB % 100 = dia      19650331 % 100 = 31  31->HI

addi $t0,$zero,100
div $t4, $t0
mfhi $t7

#imprimimos el dia

#   li $v0,4
#   la $a0,diafechaBtxt
#   syscall

# colocamos v0 para que muestre un numero
# sub $v0,$v0,$v0     # v0 = 0
# addi $v0,$v0,1      # v0 = 1

#dejamos en a0 el numero a mostrar t7
# add $a0,$zero, $t7
# syscall


#volvemos al ingreso datos
 beq $t6,$t6,casteoDiaB


 # __________________________________________________________________________________________
imprimirCantidadDias:

#imprimimos el dia

 li $v0,4
 la $a0,cantidadDiastxt
 syscall

 # colocamos v0 para que muestre un numero
 sub $v0,$v0,$v0    # v0 = 0
 addi $v0,$v0,1     # v0 = 1

 #dejamos en a0 el numero a mostrar t0
 add $a0,$zero, $t0
 syscall

 beq $t6,$t6,casteoFinalizar    #volvemos al menu


 # __________________________________________________________________________________________
finaliza:

 li $v0,4
 la $a0,finalizatxt
 syscall

 addi $v0,$zero,10
 syscall
