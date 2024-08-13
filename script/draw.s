.text
# Desenha o jogador na tela
DRAW_CAR:
li t0, 16		        
li t1, 12		        
li t2, 320
li t3, 0xFF000000
mul t4, t2, s1
add t4, t4, s0          
add t3, t3, t4          
add t4, t3, t1          
mul t5, t2, t0          
add t4, t4, t5          
la t5, carro		    
addi t5, t5, 8		    
mv t6, zero
loop: 	
    bgt t3, t4, fora		    
    lb s11, 0(t5)		        
    sb s11, 0(t3)		        
    addi t3, t3, 1		        
    addi t5, t5, 1              
    addi t6, t6, 1              
    beq t6, t1, c_row           
    j loop
    c_row:	
        add t3, t3, t2              
        sub t3, t3, t1              
        mv t6, zero                 
        j loop                      
fora:   
    ret

# Desenha o background da fase atual
DRAW_BACKGROUND:
li t1, 0xFF000000
li t2, 0xFF012C00
la t3, background_atual		
lw t3, (t3)
addi t3, t3, 8          
add t4, t3, s3		    
sub t4, t4, a0			
mv  t6, t1				
add t5, t1, a0			
loop2: 	
    bge t6, t5, fora2	    
	lw s11,0(t4)		
	sw s11,0(t6)		
	addi t6, t6, 4		
	addi t4, t4, 4
	j loop2		
fora2:	
    add t6, t1, a0			
	mv t4, t3				
loop3: 	
    bge t6, t2, fora3		
	lw s11, 0(t4)			
	sw s11, 0(t6)			
	addi t6, t6, 4			
	addi t4, t4, 4
	j loop3					
fora3:	
    ret


# Desenha as vidas na tela
DRAW_LIFES:
la t0, vidas
lb t0, (t0)
mv t1, zero
li t2, 1
draw_lifes_loop:
    beq t1, t0, end_draw_lifes
    li t3, 0xFF000000
    addi t3, t3, 37
    mul t4, t2, s6
    add t3, t3, t4
    la t4, life
    addi t4, t4, 8
    li t5, 15
    mul t5, t5, s6
    addi t5, t5, 8
    add t5, t5, t3
    mv t6, zero
    auxiliary_loop3:
        bge t3, t5, end_auxiliary_loop3
        lb s11, (t4)
        sb s11, (t3)
        addi t4, t4, 1
        addi t3, t3, 1
        addi t6, t6, 1
        li s11, 8
        beq t6, s11, reset_count_draw_lifes
        j auxiliary_loop3
        reset_count_draw_lifes:
            mv t6, zero
            addi t3, t3, 312
            j auxiliary_loop3
    end_auxiliary_loop3:
        addi t2, t2, 16
        addi t1, t1, 1
        j draw_lifes_loop
end_draw_lifes:
    ret

# Desenha a qunatidade de gasolina restante e o score na tela
DRAW_INTERFACE:
# As ecalls que desenham números e strings na tela
# Alteram o registrador s8. Portanto, é necessário
# salvar seu valor antes de chamá-las.
la t0, save_s8
sw s8, (t0)

li a7, 104  
la a0, string1 
li a1, 245
li a2, 200
li a3, 0x0000ff
ecall
li a7, 104  
la a0, string2 
li a1, 245
li a2, 10
li a3, 0x0000ff
ecall 

li a7, 101
mv a0, s9
li a1, 248
li a2, 212
li a3, 0x0000ff
ecall
la t0, save_s8
lw s8, (t0)
li a7, 101
mv a0, s8
li a1, 252
li a2, 22
li a3, 0x0000ff
ecall
la t0, save_s8
lw s8, (t0)
ret