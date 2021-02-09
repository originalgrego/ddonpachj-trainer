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