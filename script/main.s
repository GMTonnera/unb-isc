.include "MACROSv21.s"
.data
# Música e efeitos sonoros
.include "songs.data"
# Imagens
.include "imgs_data/carro.data"
.include "imgs_data/death_screen.data"
.include "imgs_data/background.data"
.include "imgs_data/background2.data"
.include "imgs_data/carro_amarelo.data"
.include "imgs_data/explosion1.data"
.include "imgs_data/explosion2.data"
.include "imgs_data/explosion3.data"
.include "imgs_data/life.data"
.include "imgs_data/gasolina.data"
.include "imgs_data/main_menu.data"
.include "imgs_data/seta.data"
# Strings desenhadas na tela durante o jogo
string1: .string "FUEL"
string2: .string "SCORE"

# String desenhadas no main menu
string3: .string "FASE 1"
string4: .string "FASE 2" 

# Strings desenhadas na death screen
string5: .string "TRY AGAIN"
string6: .string "MAIN MENU"

# Posição do indicador no main menu
seta_pos1: .word 116, 169
seta_pos2: .word 116, 183
seta_pos_atual: .word seta_pos1

# Endereço para salvar s8 que é alterada em alguma SysCall
save_s8: .word 0

# Estado do jogo
game_state: .byte 0

# Possibilita a criação de novos carros ou não
pode_criar: .byte 0

# Posição dos carros inimigos na tela
carro1: .word 0,0,0,0
carro2: .word 0,0,0,0
carro3: .word 0,0,0,0
carro4: .word 0,0,0,0
carro5: .word 0,0,0,0
carro6: .word 0,0,0,0
carro7: .word 0,0,0,0
carro8: .word 0,0,0,0
carro9: .word 0,0,0,0
carro10: .word 0,0,0,0
carro11: .word 0,0,0,0
carro12: .word 0,0,0,0
carro13: .word 0,0,0,0
carro14: .word 0,0,0,0
carro15: .word 0,0,0,0
carro16: .word 0,0,0,0
carro17: .word 0,0,0,0
carro18: .word 0,0,0,0
carro19: .word 0,0,0,0
carro20: .word 0,0,0,0

# Ponteiros das posições dos carros inimigos
carros: .word carro1, carro2, carro3, carro4, carro5,
carro6, carro7, carro8, carro9, carro10, carro11, 
carro12, carro13, carro14, carro15, carro16, carro17,
carro18, carro19, carro20

# Vidas
vidas: .byte 0

# Posição da gasolina
gasolina_pos: .word 0, 0, 0, 0

# Rate de craição dos carros
rate_craiacao_carros: .byte 0

# Rate de craição da gasolina
rate_craiacao_gasolina: .byte 0

# Background atual
background_atual: .word 0

.text
# Menu principal
MAIN_MENU:
li s6, 320
la t0, seta_pos1
la t1, seta_pos_atual
sw t0, (t1)
while_true_main_menu:
    # Executar loop enquanto o game_state for 0
    la t0, game_state
    lb t0, (t0)
    bnez t0, set_up_lvl1
    
    # Desenhar o main menu
    jal DRAW_MAIN_MENU
    
    # Obter input
    jal GET_INPUT
    
    # Administrar input
    mv a0, a1
    jal HANDLE_MAIN_MENU_INPUT
    
    # Aplicar delay
    jal MAIN_DELAY
    
    j while_true_main_menu

# Se game_state = 1, fazer o set up para a fase 1
set_up_lvl1:
    li t1, 1
    bne t0, t1, set_up_lv2
    # Número de vidas = 3
    la t0, vidas
    li t1, 3
    sb t1, (t0)
    # Rate de criação de carros = 5
    la t0, rate_craiacao_carros
    li t1, 5
    sb t1, (t0)
    # Rate de criação da gasolina = 17
    la t0, rate_craiacao_gasolina
    li t1, 17
    sb t1, (t0)
    # Background atual
    la t0, background_atual
    la t1, background2
    sw t1, (t0)
    # Resetar inimigos
    jal RESET_ENEMIES
    # Resetar gasolina
    jal DELETE_FUEL
    # Resetar variável pode criar
    la t0, pode_criar
    sb zero, (t0)
    
    jal SCREEN_TRANSITION
    j MAIN_LOOP

# Se game_state = 2, fazer o set up para a fase 2
set_up_lv2:
    # Número de vidas = 1
    la t0, vidas
    li t1, 1
    sb t1, (t0)
    # Rate de criação de carros = 4
    la t0, rate_craiacao_carros
    li t1, 4
    sb t1, (t0)
    # Rate de criação da gasolina = 17
    la t0, rate_craiacao_gasolina
    li t1, 17
    sb t1, (t0)
    # Background atual
    la t0, background_atual
    la t1, background
    sw t1, (t0)
    # Resetar inimigos
    jal RESET_ENEMIES
    # Resetar gasolina
    jal DELETE_FUEL
    # Resetar variável pode criar
    la t0, pode_criar
    sb zero, (t0)

    jal SCREEN_TRANSITION
    j MAIN_LOOP

# Main loop do jogo
MAIN_LOOP:
# s0 --> Posição x do carro (0-319)
# s1 --> Posição y do carro (0-239)
# s2 --> Velocidade d0 carro (número de linhas
# que o carro anda por iteração do main loop)
# s3 --> Número de pixels da tela 
# s4 --> Número de inimigos na tela
# s5 --> Distorção do background
# s6 --> Comprimento da tela em pixels
# s7 --> Altura da tela
# s8 --> Conta quantos backgrounds o player
#        percorreu até o momento
# s9 --> Combustível   
    
    # Carregar os registradores de acordo com a lista acima
    li s0, 122
    li s1, 177
    mv s2, zero
    li s3, 76800
    mv s4, zero
    mv s5, zero
    li s6, 320
    li s7, 240
    mv s8, zero
    li s9, 100
    la t0, D_BG_MUSIC
	la t1, M_BG		
	sw t1, 0(t0)	
	jal a0, ST_MUS

# Início do main loop
main_loop:		
    # Verificar condições de derrota
    jal MAIN_CHECK_LOSE
    li t0, 1
    beq a2, t0, derrota
    li t0, 2
    bne a2, t0, start_main_loop
    addi s2, s2, -1
    
    start_main_loop: 
        # Tocar música
        jal P_MUS
        
        # Desenhar background e objetos
        jal MAIN_DRAW
        
        # Obter input
        jal GET_INPUT
        
        # Administrar input
        mv a0, a1
        jal HANDLE_INPUT
        mv a0, zero
        
        # Verificar se é para gerar inimigos de acordo com o rate_craiacao_carros
        check_generate_enemeis:
            la t0, pode_criar
            lb t0, (t0)
            bnez t0, check_generate_fuel
            beqz s8, check_generate_fuel
            la t0, rate_craiacao_carros
            lb t0, (t0)
            rem t0, s8, t0
            beqz t0, main_generate_enemies
            j check_generate_fuel
            # Se sim, gerar inimigos
            main_generate_enemies:
                li t0, 17
                bge s4, t0, check_generate_fuel
                li a7, 42
                li a1, 2               
                ecall
                addi t5, a0, 2
                mv t6, zero
                generate_enemies_forloop:
                    li t0, 10
                    beq s4, t0, return_main_generate_enemies
                    beq t6, t5, return_main_generate_enemies
                    jal GENERATE_ENEMY
                    addi t6, t6, 1
                    j generate_enemies_forloop
                return_main_generate_enemies:
                    addi s8, s8, 1
                    j check_generate_fuel
        
        # Verificar se é para gerar combustível de acordo com o rate_craiacao_gasolina
        check_generate_fuel:
            beqz s8, check_update_enemeis
            la t0, rate_craiacao_gasolina
            lb t0, (t0)
            rem t0, s8, t0
            beqz t0, main_generate_fuel
            j check_update_enemeis
            # Se sim, gerar combustível
            main_generate_fuel:
                jal GENERATE_FUEL
                addi s8, s8, 1
                j check_update_enemeis
        
        # Verificar se há inimigos na tela
        check_update_enemeis:
            bnez s4, main_update_enemies
            j check_update_fuel
            # Se sim, atualizar suas posições
            main_update_enemies:
                jal CHECK_CARS_COLLISION
                jal UPDATE_ENEMIES_POSITIONS
                bne a1, zero, batida
                j check_update_fuel
                batida:
                    mv s2, zero
                j check_update_fuel
        
        # Verificar se há gasolina na tela
        check_update_fuel:
            la t0, gasolina_pos
            lw t0, (t0)
            bnez t0, main_update_fuel
            j end_main_loop
            # Se sim, atualizar sua posição
            main_update_fuel:
                jal UPDATE_FUEL_POS
                jal CHECK_COLLECT_FUEL
                j end_main_loop
        
        end_main_loop:
            # Fazer a distorção do background
            jal MAIN_IMAGE_DISTORCION
            
            # Aplicar o delay do loop
            jal MAIN_DELAY
            
            j main_loop
    
    # Executado quando uma das codições de derrota são alcaçadas 
    derrota:
        # Animação da explosão
        jal EXPLOSION
        
        # Animação de transição de tela
        jal SCREEN_TRANSITION
        
        # Deth screen
        j DEATH_SCREEN

# Menu que aparece quando o player morre.
DEATH_SCREEN:
    la t0, seta_pos1
    la t1, seta_pos_atual
    sw t0, (t1)
    while_true_death_screen:
        jal DRAW_DEATH_SCREEN
        jal GET_INPUT
        mv a0, a1
        jal HANDLE_DEATH_SCREEN_INPUT
        li t0, 1
        beq a1, t0, back_to_set_up
        li t0, 2
        beq a1, t0, back_to_main_menu
        jal MAIN_DELAY
        j while_true_death_screen
    back_to_set_up:
        la t0, game_state
        lb t0, (t0)
        li t1, 1
        bne t0, t1, set_up_lv2
        j set_up_lvl1
    back_to_main_menu:
    	la t0, game_state
    	sb zero, (t0)
    	j MAIN_MENU

# Chama as funções que desenham o background, o player, carros
# inimigos, a gasolina e a interface.
MAIN_DRAW:
    addi sp, sp, -8
	sw ra, 4(sp)
    mv a0, s5
    jal DRAW_BACKGROUND
    jal DRAW_LIFES
    jal DRAW_INTERFACE
    beqz s4, desenhar_gasolina
    jal DRAW_ENEMIES
    desenhar_gasolina:
        la t0, gasolina_pos
        lw t0, (t0)
        beqz t0, desenhar_player
        jal DRAW_FUEL
    desenhar_player:
        jal DRAW_CAR
    lw ra, 4(sp)
	addi sp, sp, 8
    ret

# calcula a distorção da imagem do próximo frame
MAIN_IMAGE_DISTORCION:
    mv a1, zero
    li t0, 320
    mul t0, t0, s2
    add s5, s5, t0
    bge s5, s3, resetar_imagem
    ret
    resetar_imagem:
        mv s5, zero
        addi s8, s8, 1
        addi s9, s9, -1
        ret

# Verifica as condições de derrota 
MAIN_CHECK_LOSE:
la t0, vidas
lb t0, (t0)
beqz t0, lose1
beqz s9, lose2
mv a2, zero
j return_main_check_lose     
lose1:
    li a2, 1
    j return_main_check_lose
lose2:
    blez s2, lose1
    li a2, 2
return_main_check_lose:
    ret

# Aplica um delay para a imagem parar de piscar.
MAIN_DELAY:
li a7, 32
li a0, 20
ecall
ret

# Desenha o main menu
DRAW_MAIN_MENU:
li t1, 0xFF000000
li t2, 0xFF012C00
la t3, main_menu		
addi t3, t3, 8          
draw_main_menu_background: 	
    beq t1, t2, draw_strings	    
	lw t4,0(t3)		
	sw t4,0(t1)		
	addi t1, t1, 4		
	addi t3, t3, 4
	j draw_main_menu_background
draw_strings:
    li a7, 104  
    la a0, string3 
    li a1, 130
    li a2, 170
    li a3, 0x0000ff
    ecall
    li a7, 104  
    la a0, string4
    li a1, 130
    li a2, 184
    li a3, 0x0000ff
    ecall
    la t0, seta_pos_atual
    lw t0, (t0)
    lw t1, 4(t0)
    mul t1, t1, s6
    lw t2, (t0)
    add t1, t1, t2
    li t2, 0xFF000000
    add t1, t1, t2
    la t0, seta
    addi t0, t0, 8
    li t2, 9
    mul t2, t2, t2
    add t2, t2, t0
    mv t5, zero
draw_seta:
	bge t0, t2, end_draw_main_menu
	lb t4, (t0)
	sb t4, (t1)
	addi t1, t1, 1
	addi t0, t0, 1
	addi t5, t5, 1
	li t6, 9
	beq t5, t6, reset_count_draw_seta
	j draw_seta
	reset_count_draw_seta:
		mv t5, zero
		add t1, t1, s6
		addi t1, t1, -9
		j draw_seta
end_draw_main_menu:
ret


# Admistra o input no main menu
HANDLE_MAIN_MENU_INPUT:
li t0, 32
bne a0, t0, tecla_s
la t0, seta_pos_atual
lw t0, (t0)
la t1, seta_pos1
bne t0, t1, pos2
la t0, game_state
li t1, 1
sb t1, (t0)
j end_handle_main_menu_input
pos2:
    la t0, game_state
    li t1, 2
    sb t1, (t0)
    j end_handle_main_menu_input
tecla_s:
    li t0, 115
    bne a0, t0, tecla_w
    la t0, seta_pos2
    la t1, seta_pos_atual
    sw t0, (t1)
    j end_handle_main_menu_input
tecla_w:
    li t0, 119
    bne a0, t0, end_handle_main_menu_input
    la t0, seta_pos1
    la t1, seta_pos_atual
    sw t0, (t1)
    j end_handle_main_menu_input
end_handle_main_menu_input:
    ret

SCREEN_TRANSITION:
li a7, 32
li a0, 300
ecall
li t1, 0xFF000000
li t2, 0xFF012C00       
draw_screen_trasition: 	
    beq t1, t2, end_draw_screen_trasition	    	
	sw zero,0(t1)		
	addi t1, t1, 4		
	addi t3, t3, 4
	j draw_screen_trasition
end_draw_screen_trasition:
    li a7, 32
    li a0, 1000
    ecall
    ret

DRAW_DEATH_SCREEN:
li t1, 0xFF000000
li t2, 0xFF012C00
la t3, death_screen		# Endereço do background
addi t3, t3, 8          # Endereço do primeiro pixel do background
draw_death_screen_background: 	
    beq t1, t2, draw_strings2	    
	lw t4,0(t3)		
	sw t4,0(t1)		
	addi t1, t1, 4		
	addi t3, t3, 4
	j draw_death_screen_background
draw_strings2:
    li a7, 104  
    la a0, string5 
    li a1, 130
    li a2, 170
    li a3, 0x0000ff
    ecall
    li a7, 104  
    la a0, string6
    li a1, 130
    li a2, 184
    li a3, 0x0000ff
    ecall
	
la t0, seta_pos_atual
lw t0, (t0)
lw t1, 4(t0)
mul t1, t1, s6
lw t2, (t0)
add t1, t1, t2
li t2, 0xFF000000
add t1, t1, t2
la t0, seta
addi t0, t0, 8
li t2, 9
mul t2, t2, t2
add t2, t2, t0
mv t5, zero
draw_seta2:
	bge t0, t2, end_draw_death_screen
	lb t4, (t0)
	sb t4, (t1)
	addi t1, t1, 1
	addi t0, t0, 1
	addi t5, t5, 1
	li t6, 9
	beq t5, t6, reset_count_draw_seta2
	j draw_seta2
	reset_count_draw_seta2:
		mv t5, zero
		add t1, t1, s6
		addi t1, t1, -9
		j draw_seta2
end_draw_death_screen:
ret

HANDLE_DEATH_SCREEN_INPUT:
# a1 --> Retorno (se a1 == 1, retornar ao main loop)
li t0, 32
bne a0, t0, tecla_s2
la t0, seta_pos_atual
lw t0, (t0)
la t1, seta_pos1
bne t0, t1, s_pos2
li a1, 1
j end_handle_death_screen_input
s_pos2:
    la t0, game_state
    sb zero, (t0)
    li a1, 2
    j end_handle_death_screen_input
tecla_s2:
    li t0, 115
    bne a0, t0, tecla_w2
    la t0, seta_pos2
    la t1, seta_pos_atual
    sw t0, (t1)
    mv a1, zero
    j end_handle_death_screen_input
tecla_w2:
    li t0, 119
    bne a0, t0, end_handle_death_screen_input
    la t0, seta_pos1
    la t1, seta_pos_atual
    sw t0, (t1)
    mv a1, zero
    j end_handle_death_screen_input
end_handle_death_screen_input:
    ret

RESET_ENEMIES:
la t0, carros
li t1, 80
add t1, t1, t0
loop_reset_enemies:
    beq t0, t1, end_reset_enemies
    lw t2, (t0)
    sw zero, (t2)
    sw zero, 4(t2)
    sw zero, 8(t2)
    sw zero, 12(t2)
    addi t0, t0, 4
    j loop_reset_enemies
end_reset_enemies:



.include "draw.s"
.include "input.s"
.include "fuel.s"
.include "enemy.s"
.include "sound.s"
.include "collision.s"
.include "explosion.s"
.include "SYSTEMv21.s"
