SET ROM_DIR=roms

rem assumes build\ includes ddonpachj.bin created from u27.bin + u26.bin interleaved
rem use "combine-roms u27.bin u26.bin ddonpachj.bin" to create

mkdir build\out

del build\ddonpachj_hack.bin
copy build\ddonpachj.bin build\ddonpachj_hack.bin

Asm68k.exe /p ddonpachj_hack.asm, build\ddonpachj_hack.bin

java -jar RomMangler.jar split ddonpachj_out_split.cfg build\ddonpachj_hack.bin

del %ROM_DIR%\ddonpachj.zip

java -jar RomMangler.jar zipdir build\out %ROM_DIR%\ddonpachj.zip

pause