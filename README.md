# Maze Running Game (EMU8086)

This project is a maze running game developed using Assembly language in EMU8086.

## Features
- 3 difficulty levels:
  - Easy (20x20)
  - Medium (30x20)
  - Hard (40x20)
- Player movement using arrow keys
- Collision detection (cannot pass through walls)
- Time limit for each level
- Win and Lose conditions
- Replay option after game ends

## Technologies Used
- Assembly Language (8086)
- EMU8086 Emulator
- BIOS and DOS Interrupts (int 10h, int 21h, int 16h)

## Game Logic
- The maze is stored as character arrays
- Walls are represented by 'd'
- Empty paths are represented by 'o'
- Player is represented by '*'
- Exit is represented by 'x'

## How to Run
1. Open EMU8086
2. Load the `.asm` file
3. Compile and run
4. Select difficulty level
5. Play using arrow keys

## Author
İlknur Güner
