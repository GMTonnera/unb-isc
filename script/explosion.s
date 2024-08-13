.text
EXPLOSION:
addi sp, sp, -8
sw ra, 4(sp)
la t0, BATIDA
la t1, M_EXPLOSION
sw t1, (t0)
jal P_MUS
addi s9, s9, -10
mv s2, zero
beqz s4, draw_explosion1 
explosion_loop:
    la t0, carros
    mv t1, zero
    mv t2, zero
    check_all_cars:
        beq t1, s4, end_check_all_cars
        lw t3, (t0)
        lw t3, (t3)
        beqz t3, next_car6
        addi t1, t1, 1
        lw t3, (t0)
        lw t3, 4(t3)
        li t4, -16
        bgt t3, t4, next_car6
        addi t2, t2, 1 
        next_car6:
            addi t0, t0 4
            j check_all_cars
end_check_all_cars:
    beq t2, s4, draw_explosion1
    mv a0, s5    
    jal DRAW_BACKGROUND
    jal UPDATE_ENEMIES_POSITIONS
    jal DRAW_ENEMIES
    la t1, explosion1
    li t2, 13
    li t3, 12
    draw_explosion1_with_cars:
        mv a0, t1
        mv a1, t2
        mv a2, t3
        jal DRAW_EXPLOSION
    li a7, 32
    li a0, 20
    ecall
    j explosion_loop
draw_explosion1:
    mv a0, s5    
    jal DRAW_BACKGROUND
    la a0, explosion1
    li a1, 13
    li a2, 12
    jal DRAW_EXPLOSION
    li a7, 32
    li a0, 1000
    ecall
draw_explosion:
    mv a0, s5    
    jal DRAW_BACKGROUND
    la a0, explosion2
    li a1, 16
    li a2, 15
    jal DRAW_EXPLOSION
    li a7, 32
    li a0, 1000
    ecall
    mv a0, s5    
    jal DRAW_BACKGROUND
    la a0, explosion3
    li a1, 16
    li a2, 13
    jal DRAW_EXPLOSION
    li a7, 32
    li a0, 1000
    ecall

    la t0, vidas
    sb zero, (t0)    
    lw ra, 4(sp)
    addi sp, sp, 8
    j DEATH_SCREEN

DRAW_EXPLOSION:
# a0 --> Endereço da imagem
# a1 --> Altura da imagem
# a2 --> Comprimento da imagem
li t0, 0xFF000000
mul t5, s6, s1
add t5, t5, s0
add t5, t5, t0
mul t6, a1, s6
add t6, t6, a2
add t6, t6, t5
addi a0, a0, 8
mv s10, zero
draw_explosion_loop:
    bge t5, t6, end_draw_explosion
    lb s11, (a0)
    sb s11, (t5)
    addi t5, t5, 1
    addi a0, a0, 1
    addi s10, s10, 1
    beq s10, a2, reset_count_draw_explosion
    j draw_explosion_loop
    reset_count_draw_explosion:
        mv s10, zero
        neg s11, a2
        add s11, s6, s11
        add t5, t5, s11
        j draw_explosion_loop
end_draw_explosion:
    ret