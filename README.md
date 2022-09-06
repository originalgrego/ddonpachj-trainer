Dodonpachi Trainer v1.11 by alamone
Latest version will be posted at http://alamone.net/

This is a minor update to the v1.03 DDP trainer by Grego available at:
https://github.com/originalgrego/ddonpachj-trainer

Instructions:

Apply the IPS patches to the ORIGINAL u26.bin and u27.bin roms.

Original MD5: 
u26.bin: aa78566c48732e386cc2765b34f1e5fe
u27.bin: 5c67e9da4bee96e86628e0075e1817e6

Patched MD5:
u26.bin: bb61f462730a9cede6124ec9866d684c
u27.bin: 232b515839842cf9692785c153c59740

MAME: ZIP the patched u26.bin and u27.bin roms as ddonpachj.zip and place in your ROMS folder.
      You can specify the game directly (e.g. mame ddonpachj) to ignore CRC32 check.

PCB: Program the patched u26 and u27 roms onto blank ROMS and swap onto your PCB.

MiSTer: Copy "DoDonPachi (Trainer v1.11).mra" to "/media/fat/_Arcade" folder
        ZIP the patched u26.bin and u27.bin roms as "ddptr.zip"
        Copy "ddptr.zip" into "/media/fat/games/mame" folder

Compared to v1.03, the v1.11 patch does the following:
- Applies stage and loop select for credits beyond the 1st credit.
- Allows you to reset the game (return to the trainer menu) by pressing 1P Start during the game over screen.
- Allows you to select "FREE PLAY" in the configuration / test menu.  FREE PLAY replaces the 3 COIN 1 CREDIT option.
- Change display of "Stage" and "Loop" to start from 1 instead of 0.
- Default menu options are set to standard defaults (shot 0, bomb 3, max bonus 0).
- Cursor set to "EXIT" by default.
- Using stage scroll (C+up/down while in pause - 2P Start) now sets shot power=4, bomb=6. Originally power=0, bomb=3.
- Fix graphical bug (blank frame) when selecting Loop 2 Stage 1.
- Fix bugs related to playing on 2P side.
- Speed up text on 1st and 2nd loop endings, "shinu ga yoi" text, and end credits (hold any button on 1P side).

Changelog:
v1.11: Released 8/24/2022:
       Fixed MiSTer mra file to fix audio issue.
       Changed "shinu ga yoi" speed up to use buttons instead.

v1.10: Released 7/21/2022:
       Add first and second loop ending text and ending credits speedup feature (hold any button on 1P side).
       Fix bug incorrectly setting max bonus.
       Fix bug allowing value to be changed for "EXIT" menu item.

v1.09: Released 7/17/2022:
       Add "shinu ga yoi" text speedup feature.

v1.08: Released 7/17/2022:
       Bugfix.

v1.07: Released 7/7/2022:
       Relocate patch code offset and restore credit screen.
       Using stage scroll (C+up/down while in pause - 2P Start) now sets shot power=4, bomb=6.

v1.06: Released 7/6/2022:
       Reduce patch size to fix compatibility issue with PCB and MiSTer.
       Add files and instructions for MiSTer usage.

v1.05: Released 7/4/2022:
       Fix bug where stage select is applied on demo play.
       Fix bug where stage select to 1-1 and 2-1 causes 2nd+ credit to skip to 1-2 and 2-2.
       Change display of "Stage" and "Loop" to start from 1 instead of 0.
       Change default values to standard defaults (shot 0, bomb 3, max bonus 0).
       Cursor set to "EXIT" by default.

v1.04: Released 7/2/2022:
       Preserve stage/loop select after 2nd+ credit.
       Reset / return to trainer menu by pressing 1P Start at game over screen.


Original readme below:

# ddonpachj-trainer

Trainer mod for the japanese dodonpachi release.

## Legal:
 
Created by Grego

Distributed under GNU General Public License v3: https://www.gnu.org/licenses/gpl-3.0.html

## How to use this trainer:

MiSTer FPGA - Download the MRA file from the releases folder, the patch is contained within the MRA, place it in your MRA directory and start playing!

Emulator - Within the releases folder is an ips_patch folder, apply the patches to their respective program rom file (u26.bin & u27.bin), and copy them back into your ddponachj zip.

Real Hardware - Follow emulator directions then burn u26.bin and u27.bin onto eeproms and place in their respective sockets.

## Settings Descriptions:

Do note that all values expressed in this trainer are from 0 to X, instead of 1 to X. 

Level: The stage you wish to practice. In this game (Dodonpachi), there are 13 stages in total across 2 "parts" of the game.

Loop: Some games continue to progress - even after you defeat the so called "final boss" in the last stage - via rolling over to the first stage with increased difficulty. This game is one of them; upon finishing stage 6, you will - provided specific conditions are met -  be taken back to stage 1 but on the 2nd "loop" a.k.a. "round". This 2nd loop has a hidden 7th stage that contains 2 bosses.

Kill Bee: In stage 7 of loop 2, the first boss you face is "Final Demonic Weapon" aka "Big Bee"/"Kouryuu". If this "Kill Bee" flag is set to 1, Kouryuu will immediately die before they have a chance to fire at you, allowing you to automatically face the game's true final boss: Hibachi.

Shot: The strength of your weapons, of which there are 4 tiers (0 being the weakest and 3 being the strongest).

Bomb: How many bombs you have stored (the B icons on the bottom of the screen).

Max Bonus: One of Dodonpachi's unique scoring elements is the concept of the maximum bonus: if a bomb is picked up when your bomb stock is already filled, a "MAXIMUM" banner will scroll on top of the stock, with your score automatically increasing a fixed number of points every frame. The value set here determines the strength of this bonus; a higher value means more points per frame. Note however that using a bomb or dying will interrupt this bonus until another bomb can be obtained (with a full stock present beforehand).

Max Rank: The concept of "rank" is a form of dynamic difficulty, in that the game reacts to the performance of the player and their actions, starting from a pre-determined value. If this flag is set, the game's rank will start at the highest possible value (63).

Exit: Return to the game and play with the settings selected.

## Special Thanks

Mark_MSX and The Electric Underground - Funding and emotional support

Serrara Mayfield - Big Bee skip suggestions and documentation

Olifante - Reverse engineering rank calculations and providing assistance
