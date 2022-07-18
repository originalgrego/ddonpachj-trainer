lives_1p = $101965
lives_2p = $101967
machine_credit1 = $1013AB
chute_config = $101297
input_p1 = $d00000
input_p1_2 = $d00001
frame_counter = $101270
level = $101978
second_loop = $10197A
invincible = $102CCA
shot_power = $102CAD
laser_power = $102CAF
bomb_count = $102CB0
bomb_max = $102CB1
shot_power_2p = $102CED
laser_power_2p = $102CEF
bomb_count_2p = $102CF0
bomb_max_2p = $102CF1
rank = $101968
survival_time = $101970

max_bonus = $10192a
max_bonus_2 = $10192c
max_bonus_3 = $101924

max_bonus_2P = $101934
max_bonus_2_2P = $101936
max_bonus_3_2P = $10192E


; free_mem = $10AC00
menu_index = $10AC00
last_frame = $10AC04
last_input = $10AC08

string_pos_pointer_table_mem = $10AD00
string_table_mem = $10AC40

; Menu selection variables, each is one byte long
menu_sel_vars_start = $10F9A0
level_sel = $10F9A0	
loop_sel = $10F9A1
bee_sel = $10F9A2
shot_sel = $10F9A3
bomb_sel = $10F9A4
bonus_sel = $10F9A5
rank_sel = $10F9A6
in_pause = $10F9A7

skipped_to_stage = $10f900
stage_skip_count = $10f904
player_clicked_in = $10f908
maximum_applied = $10f90c
game_start_handled = $10f910

string_table_value_offset = $0C

menu_max_index = $07

b_input_up = $00
b_input_down = $01
b_input_left = $02
b_input_right = $03

b_input_b1 = $04
b_input_b2 = $05
b_input_b3 = $06
b_input_start = $07

input_up = $0001
input_down = $0002
input_left = $0004
input_right = $0008

input_b1 = $0010
input_b2 = $0020
input_b3 = $0040
input_start = $0080

full_rank_surv_time = $0001F800

 org  0
   incbin  "build\ddonpachj.bin"
   
 org $000B6C ;fix pause scroll clearing shot/bomb to 0/3
   jmp hijack_pause_scroll_return

 org $00616C ;defaults
   dc.b $00, $04, $00, $04, $06, $06
 
 org $002628
   jmp hijack_gameover_loop
   
 org $06BBCC
   dc.b "FREE PLAY     \\      "

 org $06BC0E
   dc.b "FREE PLAY     \\      "

 org $06BCA8
   dc.b "FREE PLAY     \\      "

 ; Skip crc
 org $005410
  bra $00541E
	  
 ; Enable pause/level scroll
 org $000b02
  nop
  nop

 ; Check for level skip/max bonus
 org $048668
   jmp hijack_game_start

;---------------------------------- 
; Player never lose invi
 org $006642
;  nop
;  nop

 org $000D8C
;  nop
;  nop
;  nop

 ; End of level do not set invi to FF
 org $00668e
;  dc.b $00, $01
; Player never lose invi
;---------------------------------- 

;---------------------------------- 
 org $00552E
  jmp hijack_warning_screen
  
 org $0045EA
  jmp hijack_credit_decrease_1 ;while in demo. return to 45F0, use D1
 
 org $004F42 
  jmp hijack_credit_decrease_2 ;while in player select. return to 4F48, use D0
  
 org $004BE2
  jmp hijack_credit_decrease_3 ;while in game. return to 4BEA, use D2
  
 ; Skip warning
 org $0054EC
 ; bra $00554e
  
 ; Do not delay drawing text on warning screen
 org $057626
   nop
   nop
 
 ; Do not display original warning
 org $575d0
   rts
;---------------------------------- 
 
 org $0063E8
  jmp hijack_initialize_player

 org $006442
  jmp hijack_initialize_player_shot
  
 org $036226
  jmp kill_big_bee
  
 org $04781C
  jmp hijack_player_weapon_select
  
 org $046D4C
  jmp hijack_player_weapon_select_2P
  
; org $0045A0
;  jmp hijack_player_weapon_select_entry

 org $04CC8C
  jmp hijack_2nd_loop_test
  
 org $000B56
  jmp hijack_pause_loop

 org $009E9A
  jmp shinugayoi
 


;============================
; Free space
;============================
 ;org $098000
 org $097c00

;---------------------------
hijack_player_weapon_select:
  moveq #$01, D0
  move.b D0, player_clicked_in

  move.b  #$20, ($72,A6)
  move.b  #$0, ($73,A6)
  andi.b  #$fb, $102cc9.l
  
  jmp $047830
;---------------------------

;---------------------------
hijack_player_weapon_select_2P:
  moveq #$01, D0
  move.b D0, player_clicked_in

  move.b  #$20, ($72,A6)
  move.b  #$0, ($73,A6)
  andi.b  #$fb, $102d09.l
  
  jmp $046d60
;---------------------------

  
;---------------------------
kill_big_bee:
  move.l  #$c4e00280, ($1a,A5) ; Original big bee autodestruct/destruct timer values

  tst.b bee_sel
  beq .big_bee_continue
  move.l  #$00e00280, ($1a,A5)

.big_bee_continue
  move.l  #$140000, ($1e,A5)
  jmp $036236  
;---------------------------

;---------------------------
hijack_game_start:

  ;jsr $58f0c.l; ;draw frame?
  
  move.b game_start_handled, D5
  bne .game_start_exit
  
  move.b player_clicked_in, D5
  beq .game_start_exit
  
  move.b stage_skip_count, D5
  cmpi.b #$03, D5
  bne .check_skip

    tst.b maximum_applied
    bne .check_skip

      move.b #$01, maximum_applied

      movem.l D0-D7/A0-A1, -(A7)
	
      tst.b lives_1p
	  beq .max_apply_2p 

      moveq #$00, D0
      move.b bonus_sel, D0
            
      move.w D0, max_bonus
      move.w D0, max_bonus_2

      subi #$01, D0
     
      moveq #$00, D1
      
.bonus_loop
      addi #$16, D1 
      dbra D0, .bonus_loop
      
      move.w D1, max_bonus_3
      
      move.w  max_bonus_3, D0
      jsr     $576b6.l ; Update score?

      ;move.l  D2, $101926.l
  
      jsr $59090 ; Call maximum prep method

.max_apply_2p

      tst.b lives_2p
	  beq .max_apply_finish
	  
      moveq #$00, D0
      move.b bonus_sel, D0
            
      move.w D0, max_bonus_2P
      move.w D0, max_bonus_2_2P

      subi #$01, D0
     
      moveq #$00, D1
      
.bonus_loop_2P
      addi #$16, D1 
      dbra D0, .bonus_loop_2P
      
      move.w D1, max_bonus_3_2P
      
      move.w  max_bonus_3_2P, D0
      jsr     $576b6.l ; Update score?

      ;move.l  D2, $101926.l
  
      jsr $590B4 ; Call maximum prep method

.max_apply_finish

      movem.l (A7)+, D0-D7/A0-A1

.check_skip
  cmpi.b #$04, D5
  beq .do_skip

.increment_start_count
  addi.b #$01, D5
  move.b D5, stage_skip_count
  bra .game_start_check_handled
    
.do_skip

  tst.b skipped_to_stage
  bne .game_start_check_handled

    move.b #$01, skipped_to_stage
    
    moveq #$0, D5
    move.b level_sel, D5
    move.w D5, level
    
    jsr $1fa40.l ; End level

.game_start_check_handled
  tst.b skipped_to_stage
  beq .game_start_exit

  tst.b maximum_applied
  beq .game_start_exit

  move.b #$01, game_start_handled

.game_start_exit

  jsr $57dae.l

  jmp $48626
;---------------------------

;---------------------------
hijack_warning_screen:

  moveq #$40, D0
  movea.l #string_pos_pointer_table_mem, A0
  movea.l #string_pos_pointer_table, A1
  bsr copy_mem

  moveq #$00, D0
  move.b #$80, D0
  movea.l #string_table_mem, A0
  movea.l #string_table, A1
  bsr copy_mem

  moveq #menu_max_index, D0
  movea.l #menu_sel_vars_start, A0
  movea.l #default_value_table, A1
  bsr copy_mem

  moveq #$0, D0
  bsr draw_credit

  moveq #$1, D0
  bsr draw_credit

  moveq #$2, D0
  bsr draw_credit

  moveq #$3, D0
  bsr draw_credit

; set initial menu item to exit
  move.b #$07, menu_index
  bsr update_menu_selection
  




.redraw_menu
  move.w frame_counter, D0
  move.w D0, last_frame ; Store last frame count

  bsr draw_menu

  bsr handle_menu_inputs
  tst.b D0
  bne .exit

.menu_wait_loop
  move.w frame_counter, D0
  cmp.w last_frame, D0
  bne .redraw_menu

  bra .menu_wait_loop

.exit
  bsr prep_menu_results 

  bsr freeplay_patch

  jmp $00554E
;---------------------------


freeplay_patch:

  move.b chute_config, D0
  lsr.b #$04, D0
  
  cmpi.b #$0C, D0
  beq .freeplay_enable
  cmpi.b #$03, D0
  beq .freeplay_enable
  cmpi.b #$0F, D0
  beq .freeplay_enable
  rts
  
 .freeplay_enable:
  
  move.b #$09, machine_credit1  
 
  rts  

;---------------------------
prep_menu_results:
  
  move.b bonus_sel, D0
  cmpi.b #$01, D0
  bne .menu_results_dont_incr_bonus
  move.b #$02, bonus_sel
  
.menu_results_dont_incr_bonus

  move.b level_sel, D0
  beq .menu_results_dont_skip

  sub.b #$01, D0
  move.b D0, level_sel
  bra .menu_results_check_maximum

.menu_results_dont_skip
  move.b #$01, skipped_to_stage
  move.b #$FF, level_sel ; set to FF if starting on stage 1
  
.menu_results_check_maximum
  tst.b bonus_sel
  bne .menu_results_exit
  
  move.b #$01, maximum_applied

.menu_results_exit
  rts
;---------------------------

;---------------------------
handle_menu_inputs:
  ; Check inputs
  move.w last_input, D1

  move.w input_p1, D0 
  not.w D0
  move.w D0, last_input ; Store current input as last

  eor.w D0, D1 ; Fresh input
  and.w D0, D1 ; Was a press not a release
  
  btst #b_input_up, D1
  beq .input_check_down

    move.b menu_index, D0
    subi.b #$01, D0
    bpl .menu_index_ok

    moveq #menu_max_index, D0
    
.menu_index_ok
    move.b D0, menu_index
    
    bsr update_menu_selection
    
    bra .input_exit

.input_check_down
  btst #b_input_down, D1
  beq .input_check_left  
  
    move.b menu_index, D0
    addi.b #$01, D0
    cmpi.b #menu_max_index, D0
    ble .menu_index_ok

    moveq #$00, D0

    bra .menu_index_ok

.input_check_left
  btst #b_input_left, D1
  beq .input_check_right
  
    moveq #$00, D0
    move.b menu_index, D0
    movea.l #menu_sel_vars_start, A0
    movea.l #max_value_table, A1
    moveq #$00, D1
    move.b (A0, D0), D1 ; Get selection
    subi.b #$01, D1
    bpl .selected_value_ok

    move.b (A1, D0), D1 ; Load max value
   
.selected_value_ok
    move.b D1, (A0, D0)
    
    bsr update_menu_value
    
    bra .input_exit    

.input_check_right
  btst #b_input_right, D1
  beq .input_check_button

    moveq #$00, D0
    move.b menu_index, D0
    movea.l #menu_sel_vars_start, A0
    movea.l #max_value_table, A1
    
    moveq #$00, D2
    move.b (A1, D0), D2 ; Get max value
    
    moveq #$00, D1
    move.b (A0, D0), D1 ; Get selection
    addi.b #$01, D1
    cmp.b D1, D2
    bge .selected_value_ok

    moveq #$00, D1

    bra .selected_value_ok

.input_check_button
  btst #b_input_b1, D1
  beq .input_exit
  
  move.b menu_index, D0
  cmpi.b #menu_max_index, D0
  bne .input_exit

  moveq #$01, D0 ; Exit menu
  rts

.input_exit
  moveq #$00, D0
  rts
;---------------------------

;---------------------------
update_menu_value:
    moveq #$00, D0
    move.b menu_index, D0

    moveq #string_table_value_offset, D2    
    movea.l #menu_sel_vars_start, A0
    movea.l #nibble_to_char, A1
    movea.l #string_table_mem, A2
    
    moveq #$00, D1
    move.b (A0, D0), D1 ; Get selection


; adjust level and loop display values

	cmpi.b #$02, D0
	bcc .skip_add
	addi.b #$01, D1
	
.skip_add

    
    rol #$4, D0 ; Get item offset into string_table_mem
    add.w D2, D0 ; Offset to value

	move.b (A1, D1), D1 ; Load char
	move.b D1, (A2, D0)
    
  rts
;---------------------------

;---------------------------
update_menu_selection:
  moveq #$0, D1
  moveq #menu_max_index, D0
  move.b #$C4, D2
  movea.l #string_pos_pointer_table_mem, A0

.update_selection_loop
  move.w D0, D1
  rol #$3, D1
  move.b D2, (A0, D1.w)

  dbra D0, .update_selection_loop

  move.b #$C0, D2

  moveq #$0, D1
  move.b menu_index, D1
  rol #$3, D1
  move.b D2, (A0, D1.w)

  rts
;---------------------------

;---------------------------
draw_menu:
  moveq #menu_max_index, D0

.draw_text_loop
  bsr draw_text
  dbra D0, .draw_text_loop

  rts
;---------------------------

;---------------------------
draw_credit:
  movea.l #credits_string_pos_pointer_table, A1 ; Vram location data/string pointer
  bra draw_text_impl
;---------------------------

;---------------------------
draw_text:
  movea.l #string_pos_pointer_table_mem, A1 ; Vram location data/string pointer
  bra draw_text_impl
;---------------------------

;---------------------------
draw_text_impl:
  movem.l D0-D3/A1, -(A7)
  andi.w  #$ff, D0
  lsl.w   #3, D0 ; Get offset into location/pointer table

  jmp $0575E0
;---------------------------

;---------------------------
hijack_initialize_player_shot:
  ; Update other shot variables
  move.l  (A2,D0.w), (A4) 
  move.l  (A3,D0.w), ($4,A4) 
  
;  move.b game_start_handled, D0
;  bne .init_p_shot_continue

;  move.b player_clicked_in, D0
;  beq .init_p_shot_continue  

;  moveq #$01, D0
;  move.b D0, invincible ; Make invincible

  moveq #$00, D0
  move.b shot_sel, D0
  ;move.b D0, shot_power
  ;move.b D0, laser_power
  move.b D0, ($21, A6)
  move.b D0, ($23, A6)

  rol.b #$1, D0

  add.w  D0, $101856.l
  add.w  D0, $10185a.l

.init_p_shot_continue  
  jmp $00644C
;---------------------------

;---------------------------
hijack_initialize_player:
  moveq   #$c, D5

.loop
  move.l  (A0)+, (A1)+ ; Initialize player data?
  dbra    D5, .loop

  move.b game_start_handled, D5
  ;bne .init_player_exit
  bne .rank_not_selected

  moveq #$00, D5
  move.b loop_sel, D5
  move.w D5, second_loop

  move.b rank_sel, D5
  beq .rank_not_selected

  move.l #full_rank_surv_time, D5
  move.l D5, survival_time


.rank_not_selected
  move.b bomb_sel, D5
  ;move.b D5, bomb_count
  move.b D5, (-$1A, A1)

  cmpi.b #$03, D5
  bge .init_player_continue

  move.b #$03, D5
  tst.b bonus_sel
  beq .init_player_continue
  
  move.b D5, (-$1A, A1) ; set bomb to 3 if bonus > 0

.init_player_continue  
  ;move.b D5, bomb_max
  move.b D5, (-$19, A1)
  
  tst.b in_pause
  beq .init_player_exit
  
  move.b #$06, D5  ; set bomb to 6 if in pause
  move.b D5, (-$1A, A1)
  move.b D5, (-$19, A1)  
  
.init_player_exit
  jmp $0063F0
;---------------------------

;-----------------
copy_mem:
  move.b  (A1, D0.w), D1
  move.b  D1, (A0, D0.w)
  dbra D0, copy_mem
  rts
;-----------------


.reset_to_menu
  jmp $0052F6

hijack_gameover_loop:

  move.b input_p1_2, D1  ;reset if P1 Start is pressed during game over
  cmpi.b #$7F, D1
  beq .reset_to_menu

  move.b #$00, game_start_handled  ;prepare variables
  move.b #$00, stage_skip_count
  move.b #$00, player_clicked_in
  move.b #$00, maximum_applied
  jsr .menu_results_check_maximum
   
  move.b level_sel, D1
  cmpi.b #$FF, D1
  beq .skip_set_go1 ; stage select is 1st stage

  ; else stage select is 1+
  move.b #$00, skipped_to_stage
  bra .skip_set_go2
  
.skip_set_go1

  move.b #$01, skipped_to_stage
  
.skip_set_go2
  
  jmp $002636

hijack_credit_decrease_1: ; use D1

  move.b chute_config, D1
  lsr.b #$04, D1
  
  cmpi.b #$0C, D1
  beq .skip_credit_dec1
  cmpi.b #$03, D1
  beq .skip_credit_dec1
  cmpi.b #$0F, D1
  beq .skip_credit_dec1
  
  subq.w #$1, $1013aa.l
  
 .skip_credit_dec1:
  jmp $0045F0
 
hijack_credit_decrease_2: ; use D0

  move.b chute_config, D0
  lsr.b #$04, D0
  
  cmpi.b #$0C, D0
  beq .skip_credit_dec2
  cmpi.b #$03, D0
  beq .skip_credit_dec2
  cmpi.b #$0F, D0
  beq .skip_credit_dec2
  
  sub.w D7, $1013aa.l

 .skip_credit_dec2:
  jmp $004F48

hijack_credit_decrease_3: ; use D2

  move.w (A1), $1013ac.l

  move.b chute_config, D2
  lsr.b #$04, D2
  
  cmpi.b #$0C, D2
  beq .skip_credit_dec3
  cmpi.b #$03, D2
  beq .skip_credit_dec3
  cmpi.b #$0F, D2
  beq .skip_credit_dec3

  sub.w D1, (A1)
  
 .skip_credit_dec3:
  jmp $004BEA
  
  
hijack_pause_scroll_return:

  move.b player_clicked_in, D0
  cmpi.b #$01, D0
  beq .max_shot_bomb_after_scroll
  bra .return_pause_scroll
  
 .max_shot_bomb_after_scroll:
  
  move.b lives_1p, D0
  cmpi.b #$00, D0
  beq .check_2p_lives

  moveq #$00, D0
  move.b #$04, D0
  move.b D0, shot_power
  move.b D0, laser_power
  move.b #$06, D0
  move.b D0, bomb_count
  move.b D0, bomb_max
    
 .check_2p_lives:
 
  move.b lives_2p, D0
  cmpi.b #$00, D0
  beq .return_pause_scroll

  moveq #$00, D0
  move.b #$04, D0
  move.b D0, shot_power_2p
  move.b D0, laser_power_2p
  move.b #$06, D0
  move.b D0, bomb_count_2p
  move.b D0, bomb_max_2p
  
 .return_pause_scroll:

  move.b #$00, in_pause
  jmp $000B1E  

;hijack_player_weapon_select_entry:
  ;moveq #$00, D1
  ;cmpi.w #$1, D7
  ;jmp $0045A6

hijack_2nd_loop_test:
  tst.b loop_sel
  beq .second_loop_continue
  ; second loop set
  jmp $4cc94

.second_loop_continue:   
  tst.w $10197a.l
  jmp $4cc92

hijack_pause_loop:
  move.b #$01, in_pause
  move.w #$01, $100F48.l
  jmp $b5e

shinugayoi:
  tst.b loop_sel
  beq .normal_shinugayoi ; selected first loop
  
  move.b level_sel, D0
  cmpi #$05, D0
  bne .normal_shinugayoi ; selected level other than 6

.fast_shinugayoi
  move.l #fast_shinugayoi_table, D0
  bra .shinugayoi_end

.normal_shinugayoi
  move.l #$9fa0, D0

.shinugayoi_end
  move.l D0, ($6, A6)
  jmp $9ea2
  
nibble_to_char:
  dc.b "0123456789ABCDEF"

max_value_table:
  dc.b $06, $01, $01, $04, $06, $09, $01, $00

default_value_table:
  dc.b $00, $00, $00, $00, $03, $00, $00, $00

; Each entry 8 bytes
; Layout: CC CC PP PP AA AA AA AA
; C - Tile config/properties
; P - Vram position
; A - String address
string_pos_pointer_table:
level_pos_pointer:
  dc.b $C0, $00, $02, $88, $00, $10, $AC, $40
loop_pos_pointer:
  dc.b $C4, $00, $02, $80, $00, $10, $AC, $50
bee_pos_pointer:
  dc.b $C4, $00, $02, $78, $00, $10, $AC, $60
shot_pos_pointer:
  dc.b $C4, $00, $02, $70, $00, $10, $AC, $70
bomb_pos_pointer:
  dc.b $C4, $00, $02, $68, $00, $10, $AC, $80
bonus_pos_pointer:
  dc.b $C4, $00, $02, $60, $00, $10, $AC, $90
rank_pos_pointer:
  dc.b $C4, $00, $02, $58, $00, $10, $AC, $A0
exit_pos_pointer:
  dc.b $C4, $00, $02, $50, $00, $10, $AC, $B0

; Each entry is 16 bytes long
string_table:
level_string:
  dc.b "      LEVEL 1 \\\\"
loop_string:
  dc.b "       LOOP 1 \\\\"
bee_string:
  dc.b "   KILL BEE 0 \\\\"
shot_string:
  dc.b "       SHOT 0 \\\\"
bomb_string:
  dc.b "       BOMB 3 \\\\"
bonus_string:
  dc.b "  MAX BONUS 0 \\\\"  
rank_string:
  dc.b "   MAX RANK 0 \\\\"  
exit_string:
  dc.b "       EXIT   \\\\"  

credits_string_pos_pointer_table:
  dc.b $C0, $00, $02, $98
  dc.l credit_1
  dc.b $C0, $00, $02, $40
  dc.l credit_2
  dc.b $C0, $00, $02, $30
  dc.l credit_3
  dc.b $C0, $00, $02, $28
  dc.l credit_4

credits_string_table:
credit_1:
  dc.b "DODONPACHI TRAINER 1.09\\\\"
credit_2:
  dc.b "REVISED BY ALAMONE.\\\\"
credit_3:
  dc.b "ORIGINAL BY GREGO. FUNDED\\\\"
credit_4:
  dc.b "BY ELECTRIC UNDERGROUND\\\\"

fast_shinugayoi_table:
  dc.w $0001, $0001, $0001, $0001, $0001, $0001, $0001, $0001
  dc.w $0001, $0001, $0001, $0001, $0001, $0001, $0001, $0001
  dc.w $0001, $0001, $0001, $0001, $0001, $0001, $0001, $0001
  dc.w $0001, $0001, $0001, $0001, $0001, $0001, $0001, $0001
  dc.w $0001, $0001, $0001, $0001, $0001, $0001, $0001, $0001
  dc.w $0001, $0001, $0001, $0001, $0001, $0001, $0001, $0001
  dc.w $0001, $0001, $0001, $0001, $0001, $0001, $0001, $0001
  dc.w $0001, $0001, $0001, $0001, $0001, $0001, $0001, $0001
  dc.w $0001, $0001, $0001, $0001, $0001, $0001, $0001, $0001
  dc.w $0001, $0001, $0001, $0001, $0001, $0001, $0001, $0001
  dc.w $0001, $0001, $0001, $FFFF, $0001
  