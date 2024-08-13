.text
# Cria uma gasolina
GENERATE_FUEL:
la t0, gasolina_pos
lw t0, (t0)
bnez t0, end_generate_fuel
li t1, 1
while_generate_fuel:
	beq t1, zero, end_generate_fuel     
    li a7, 42
    li a1, 87               
    ecall
    addi a0, a0, 93
    la t0, carros
    addi t2, t0, 40
    check_xpos2:
        beq t0, t2, end_generate_fuel
        lw t3, (t0)
        lw t3, 8(t3)
        blt t3, a0, next_car9
        addi a0, a0, 16
        ble t3, a0, while_generate_fuel
        addi a0, a0, -16
        next_car9:
            addi t0, t0, 4
            j check_xpos2 
end_generate_fuel:
    la t0, gasolina_pos
    sw a0, (t0)
    li t2, -15
    sw t2, 4(t0)
    addi t2, a0, 9
    sw t2, 8(t0)
    li t2, -1
    sw t2, 12(t0)
    ret

# Deleta o combustível
DELETE_FUEL:
la t0, gasolina_pos
sw zero, (t0)
sw zero, 4(t0)
sw zero, 8(t0)
sw zero, 12(t0)
ret

# Verifica se o jogador coletou a gasolina
CHECK_COLLECT_FUEL:
addi sp, sp, -8
sw ra, 4(sp)
addi t0, s0, 12
addi t1, s1, 16
la t2, gasolina_pos
collect1:
    lw t3, (t2)
    bgt t3, t0, collect2 
    bgt s0, t3, collect2
    lw t3, 4(t2) 
    bgt t3, t1, collect2 
    bgt s1, t3, collect2
    li t4, 1
    j check_cars_collect_end
collect2:
    lw t3, 8(t2) 
    bgt t3, t0, collect3 
    bgt s0, t3, collect3
    lw t3, 12(t2)  
    bgt t3, t1, collect3 
    bgt s1, t3, collect3
    li t4, 1
    j check_cars_collect_end
collect3:
    lw t3, (t2) 
    bgt t3, t0, collect4
    bgt s0, t3, collect4
    lw t3, 12(t2) 
    bgt t3, t1, collect4 
    bgt s1, t3, collect4
    li t4, 1
    j check_cars_collect_end
collect4:
    lw t3, 8(t2)
    bgt t3, t0, check_cars_collect_end
    bgt s0, t3, check_cars_collect_end
    lw t3, 4(t2)  
    bgt t3, t1, check_cars_collect_end
    bgt s1, t3, check_cars_collect_end
    li t4, 1
check_cars_collect_end:
    li t0, 1
    beq t0, t4, add_fuel
    j true_end2
    add_fuel:
        addi s9, s9, 10
        jal DELETE_FUEL
    true_end2:
        lw ra, 4(sp)
        addi sp, sp, 8
        ret

# Atualiza a posição da gasolina na tela
UPDATE_FUEL_POS:
addi sp, sp, -8
sw ra, 4(sp)
li t0, 9
sub t0, s2, t0
la t1, gasolina_pos
lw t4, 4(t1)
bgt t4, s7, delete_fuel
add t4, t4, t0
sw t4, 4(t1)
lw t4, 12(t1)
add t4, t4, t0
sw t4, 12(t1)
j fim_update_fuel_pos
delete_fuel:
    jal DELETE_FUEL      	   
fim_update_fuel_pos:
    lw ra, 4(sp)
    addi sp, sp, 8
    ret

# Desenha a gasolina na tela
DRAW_FUEL:
li t0, 15		        
li t1, 9
li t2, 0xFF000000
la t3, gasolina_pos
lw t4, 4(t3)
mul t4, s6, t4
lw t5, (t3)
add t4, t4, t5                    
add t4, t4, t2
mul t3, t0, s6
add t3, t3, t1
add t3, t3, t4
la t5, gasolina		    
addi t5, t5, 8		    
mv t6, zero
loop5: 	
    bgt t4, t3, fora5	
    blt t4, t2, jump4
    lb s11, 0(t5)		
    sb s11, 0(t4)		
    addi t4, t4, 1		
    addi t5, t5, 1      
    addi t6, t6, 1      
    beq t6, t1, c_row2  
    j loop5
    c_row2:	
        add t4, t4, s6  
        sub t4, t4, t1  
        mv t6, zero     
        j loop5
   jump4:
   	addi t5, t5, 9
   	add t4, t4, s6
   	j loop5                      
fora5:   
    ret