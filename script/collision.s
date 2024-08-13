.text
# Verifica se o jogador colidiu com uma 
# das extremidades da rua
CHECK_SIDEWALK_COLLISION:
# a1 --> Retorno. Retorna 0 se colidir com a calçada
#        e 1 caso contrário;
li t0, 93
ble s0, t0, colisao
li t0, 175
bge s0, t0, colisao
li a1, 0
j end_check_sidewalk_collision
colisao:
    li a1, 1
end_check_sidewalk_collision:
    ret 

# Verifica se o jogador colidiu com um
# dos carros inimigos.
CHECK_CARS_COLLISION:
# a1 --> Retorno. Retorna 0 se colidir com a calçada
#        e 1 caso contrário;
mv t6, zero
beqz s2, true_end
addi t0, s0, 12
addi t1, s1, 16
la t2, carros
mv t3, zero
check_cars_collision_loop:
    beq t3, s4, check_cars_collision_end
    lw t4, (t2)
    lw t5, (t4)
    beqz t5, next_car4
    collision1:
        lw t5, (t4)
        bgt t5, t0, collision2 
        bgt s0, t5, collision2
        lw t5, 4(t4) 
        bgt t5, t1, collision2 
        bgt s1, t5, collision2
        li t6, 1
        j check_cars_collision_end
    collision2:
        lw t5, 8(t4) 
        bgt t5, t0, collision3 
        bgt s0, t5, collision3
        lw t5, 12(t4)  
        bgt t5, t1, collision3 
        bgt s1, t5, collision3
        li t6, 1
        j check_cars_collision_end
    collision3:
        lw t5, (t4) 
        bgt t5, t0, collision4
        bgt s0, t5, collision4
        lw t5, 12(t4) 
        bgt t5, t1, collision4 
        bgt s1, t5, collision4
        li t6, 1
        j check_cars_collision_end
    collision4:
        lw t5, 8(t4)
        bgt t5, t0, no_collision
        bgt s0, t5, no_collision
        lw t5, 4(t4)  
        bgt t5, t1, no_collision
        bgt s1, t5, no_collision
        li t6, 1
        j check_cars_collision_end
    no_collision:
        mv t6, zero
        addi t3, t3, 1
        addi t2, t2, 4
        j check_cars_collision_loop
    next_car4:
        addi t2, t2, 4
        j check_cars_collision_loop
check_cars_collision_end:
    li t0, 1
    beq t0, t6, take_damage
    j true_end
take_damage:
    addi s9, s9, -10
    mv s2, zero
    la t0, vidas
    lb t1, (t0)
    addi t1, t1, -1
    sb t1, (t0)
    la t0, BATIDA
    la t1, M_COLLISION
    sw t1, (t0)
true_end:
    mv a1, t6
    ret


