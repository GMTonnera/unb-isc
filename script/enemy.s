.text
# Desenha os inimigos na tela
DRAW_ENEMIES:
li t0, 0xFF000000
la t1, carros
mv t2, zero 
draw_enemies_loop:    
    beq t2, s4, end_draw_enemies
    lw t3, (t1)
    lw t4, (t3)
    beqz t4, next_car3
    lw t5, 4(t3)
    mul t5, t5, s6
    add t4, t4, t5
    add t4, t4, t0
    lw t5, 8(t3)
    lw t6, 12(t3)
    mul t6, t6, s6
    add t5, t5, t6
    add t5, t5, t0
    la t3, carro_amarelo
    addi t3, t3, 8
    mv t6, zero 
    auxiliary_loop2:
        bge t4, t5, end_auxiliary_loop2
        blt t4, t0, jump3
        lb s11, (t3)
        sb s11(t4)
        addi t3, t3, 1
        addi t4, t4, 1
        addi t6, t6, 1
        li s11, 7
        beq t6, s11, reset_count_draw_enemies
        j auxiliary_loop2
        reset_count_draw_enemies:
            mv t6, zero
            addi t4, t4, 313
            j auxiliary_loop2
        jump3:
            addi t3, t3, 7
            addi t4, t4, 320
            j auxiliary_loop2
    end_auxiliary_loop2:
        addi t2, t2, 1
        addi t1, t1, 4
        j draw_enemies_loop
    next_car3:
        addi t1, t1, 4
        j draw_enemies_loop
end_draw_enemies:
    ret

# Cria um inimigo
GENERATE_ENEMY:
la t0, pode_criar
li t1, 1
sb t1, (t0)
li t0, 10
beq s4, t0, the_end_generate_enemy
li t1, 1
while_generate_enemy:
    beq t1, zero, generate_enemy_start     
    li a7, 42
    li a1, 87               
    ecall
    addi a0, a0, 93
    la t0, carros
    addi t2, t0, 40
    check_xpos:
        beq t0, t2, generate_enemy_start
        lw t3, (t0)
        lw t3, 8(t3)
        blt t3, a0, next_car10
        addi a0, a0, 14
        ble t3, a0, while_generate_enemy
        addi a0, a0, -14
        next_car10:
            addi t0, t0, 4
            j check_xpos
generate_enemy_start:
    la t0, carros
    generate_enemy_loop:
        lw t1, (t0)
        lw t1, (t1)
        beq t1, zero, end_generate_enemy
        addi t0, t0, 4
        j generate_enemy_loop
end_generate_enemy:
    lw t1, (t0)
    sw a0, (t1)
    li t2, -16
    sw t2, 4(t1)
    addi t2, a0, 7
    sw t2, 8(t1)
    li t2, -1
    sw t2, 12(t1)
    addi s4, s4, 1
the_end_generate_enemy:
    ret

# Atualiza a posição dos inimigos na tela
UPDATE_ENEMIES_POSITIONS:
addi sp, sp, -8
sw ra, 4(sp)
li t0, 9
sub t0, s2, t0
#blez t0, fim_update_enemies_positions
la t1, carros
mv t2, zero
loop_update_enemies_positions:
    beq t2, s4, fim_update_enemies_positions
    lw t3, (t1)
    lw t4, (t3)
    beqz t4, next_car
    lw t4, 4(t3)
    bgt t4, s7, delete_enemy
    lw t4, 4(t3)
    add t4, t4, t0
    sw t4, 4(t3)
    lw t4, 12(t3)
    add t4, t4, t0
    sw t4, 12(t3)
    addi t1, t1, 4
    addi t2, t2, 1
    j loop_update_enemies_positions
    delete_enemy:
        lw t3, (t1)
        mv a0, t3
        jal DELETE_ENEMY
        j loop_update_enemies_positions
    next_car:
        addi t1, t1, 4
        j loop_update_enemies_positions
        	   
fim_update_enemies_positions:
    lw ra, 4(sp)
    addi sp, sp, 8
    ret

# Deleta um inimigo
DELETE_ENEMY:
# a0 --> Endereço do carro a ser deletado
la t0, pode_criar
sb zero, (t0)
sw zero, (a0)
sw zero, 4(a0)
sw zero, 8(a0)
sw zero, 12(a0)
addi s4, s4, -1
ret