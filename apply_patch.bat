SET ROM_DIR=C:\Users\grego\Desktop\MAME\roms

del build\ddonpachj_hack.bin
copy build\ddonpachj.bin build\ddonpachj_hack.bin

Asm68k.exe /p ddonpachj_hack.asm, build\ddonpachj_hack.bin

java -jar RomMangler.jar split ddonpachj_out_split.cfg build\ddonpachj_hack.bin

del %ROM_DIR%\ddonpachj.zip

java -jar RomMangler.jar zipdir build\out %ROM_DIR%\ddonpachj.zip

pause