input_p1 = $d00000
frame_counter = $101270
level = $101978
second_loop = $10197A
invincible = $102CCA

; free_mem = $10AC00
menu_index = $10AC00
last_frame = $10AC04
string_pos_pointer_table_mem = $10AC10
string_table_mem = $10AC40 ; Offset 48 bytes

 org  0
   incbin  "build\ddonpachj.bin"

 ; Skip crc
 org $005410
  bra $00541E
	  
 ; Enable pause/level scroll
 org $000b02
;  nop
;  nop

;---------------------------------- 
; Player never lose invi
 org $006642
  nop
  nop

 org $000D8C
  nop
  nop
  nop

 ; End of level do not set invi to FF
 org $00668e
  dc.b $00, $01
; Player never lose invi
;---------------------------------- 

;---------------------------------- 
 org $00552E
  jmp hijack_warning_screen

 ; Skip warning
 org $0054EC
 ; bra $00554e
  
 ; Do not delay drawing text on warning screen
 org $057626
   nop
   nop
   
 org $575d0
   rts
;---------------------------------- 

 org $000af2
;  dc.b $00, $00, $0b, $68
  
 org $000b68
;  dc.b $4e, $b9, $00, $04, $9b, $ec, $4e, $b9

 org $000b70
;  dc.b $00, $05, $6d, $d6

 org $000b74
;  dc.b $4e, $75

 org $049c0c
;  dc.b $00, $10, $f9, $00
 
 
 org $0063E8
;  jmp hijack_initialize_player

 org $00641E
;  jmp hijack_initialize_player_shot
  
  
 org $06b7cf
;  incbin  "config_text.bin"

;============================
; Free space
;============================
 org $098000

;---------------------------
hijack_warning_screen:
  moveq #$30, D0
  movea.l #string_pos_pointer_table_mem, A0
  movea.l #string_pos_pointer_table, A1
  bsr copy_mem

  moveq #$60, D0
  movea.l #string_table_mem, A0
  movea.l #string_table, A1
  bsr copy_mem

.redraw_menu
  move.w frame_counter, D0
  move.w D0, last_frame ; Store last frame count

  bsr draw_menu

  bsr handle_menu_inputs

.hijack_warning_loop
  move.w frame_counter, D0
  cmp.w last_frame, D0
  bne .redraw_menu

  bra .hijack_warning_loop

.exit
  jmp $00554E
;---------------------------

;---------------------------
handle_menu_inputs:
  ; Check inputs
  move.w input_p1, D0 
  not.w D0
  tst.w D0
  bne .exit

  rts
;---------------------------

;---------------------------
draw_menu:
  moveq #$5, D0

.draw_text_loop
  bsr draw_text
  dbra D0, .draw_text_loop

  rts
;---------------------------

;---------------------------
draw_text:
  movem.l D0-D3/A1, -(A7)
  andi.w  #$ff, D0
  lsl.w   #3, D0 ; Get offset into location/pointer table
  movea.l #string_pos_pointer_table_mem, A1 ; Vram location data/string pointer

  jmp $0575E0
;---------------------------

;---------------------------
hijack_initialize_player_shot:
  moveq #$04, D0
  move.b D0, $102CAD
  move.b D0, $102CAF
  move.b D0, invincible ; Make invincible
  
  jmp $006424
;---------------------------

;---------------------------
hijack_initialize_player:
  moveq   #$c, D5

.loop
  move.l  (A0)+, (A1)+ ; Initialize player data?
  dbra    D5, .loop
  
  moveq #$06, D5
  move.b D5, $102CB0 ; Bombs
  move.b D5, $102CB1
  
  jmp $0063F0
;---------------------------

;-----------------
copy_mem:
  move.b  (A1, D0.w), D1
  move.b  D1, (A0, D0.w)
  dbra D0, copy_mem
  rts
;-----------------

nibble_to_char:
  dc.b "0123456789ABCDEF"

max_value_table:
 dc.b $06, $01, $04, $06, $0F, $00

; Each entry 8 bytes
string_pos_pointer_table:
level_pos_pointer:
  dc.b $C0, $00, $02, $88, $00, $10, $AC, $40
loop_pos_pointer:
  dc.b $C4, $00, $02, $80, $00, $10, $AC, $50
shot_pos_pointer:
  dc.b $C4, $00, $02, $78, $00, $10, $AC, $60
bomb_pos_pointer:
  dc.b $C4, $00, $02, $70, $00, $10, $AC, $70
bonus_pos_pointer:
  dc.b $C4, $00, $02, $68, $00, $10, $AC, $80
exit_pos_pointer:
  dc.b $C4, $00, $02, $60, $00, $10, $AC, $90

; Each entry is 16 bytes long
string_table:
level_string:
  dc.b "      LEVEL 0 \\\\"
loop_string:
  dc.b "       LOOP 0 \\\\"
shot_string:
  dc.b "       SHOT 4 \\\\"
bomb_string:
  dc.b "       BOMB 6 \\\\"
bonus_string:
  dc.b "      BONUS 15\\\\"  
exit_string:
  dc.b "       EXIT   \\\\"  
