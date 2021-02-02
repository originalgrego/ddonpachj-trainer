input_p1 = $d00000
frame_counter = $101270
level = $101978
second_loop = $10197A
invincible = $102CCA

 org  0
   incbin  "build\ddonpachj.bin"

 ; Skip crc
 org $005410
  bra $00541E
	
 ; Skip warning
 org $0054EC
 ; bra $00554e
  
 ; Do not delay drawing text on warning screen
 org $057626
;   nop
;   nop
  
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
 


 org $00552E
;  jmp hijack_warning_screen

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

hijack_warning_screen:
  move.w input_p1, D0 
  not.w D0
  tst.w D0
  bne .exit

  bra hijack_warning_screen

.exit
  jmp $00554E

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
