.text
# Retorna o valor da tecla precionada em a1
GET_INPUT:
li t1, 0xFF200000			
lw t0, 0(t1)				
andi t0, t0, 0x0001			
beq t0, zero, fim_get_input 
lw a1, 4(t1)
fim_get_input: 	
    ret

# Administra os inputs durante o main loop
HANDLE_INPUT:
# a0 --> Input (Valor da tecla precionada)
# t0 --> Comparador          
addi sp, sp, -8
sw ra, 4(sp)
acelerar:	
    li t0, 120	
    bne a0, t0, mover_l
    li t0, 12
    beq s2, t0, fim_handle_input
    addi s2, s2, 12                
    j fim_handle_input	
mover_l:	
    li t0, 97
    bne a0, t0, mover_r
    li a0, -4 
    jal CHECK_CARS_COLLISION
    bne a1, zero, stop_car
    addi s0, s0, -4
    jal CHECK_SIDEWALK_COLLISION
    bne a1, zero, explosion
    j fim_handle_input	
mover_r:	
    li t0, 100
    bne a0, t0, fim_handle_input
    li a0, 2   
    jal CHECK_CARS_COLLISION
    bne a1, zero, stop_car
    addi s0, s0, 2
    jal CHECK_SIDEWALK_COLLISION
    bne a1, zero, explosion
    j fim_handle_input
stop_car: 
    mv s2, zero
    j fim_handle_input
explosion:
    jal EXPLOSION
fim_handle_input:
    lw ra, 4(sp)
    addi sp, sp, 8
    ret