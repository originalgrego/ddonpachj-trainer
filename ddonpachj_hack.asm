 org  0
   incbin  "build\ddonpachj.bin"

 ; Skip crc
 org $005410
  bra $00541E
	
 ; Skip warning
 org $0054EC
  bra $005548