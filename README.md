# Digital System Dance Machine

A Verilog-based digital rhythm game using FSM logic, LFSR arrow generation, dot-matrix display control, button inputs, and seven-segment score output.

## Overview

This project implements a simple dance-machine-style game for a digital systems course. The system displays a random arrow direction on an 8x8 dot matrix. The player presses the corresponding button to score points. Correct inputs increase the score, while incorrect inputs decrease the score and increase the mistake counter.

The game speed increases as the score gets higher. The system enters a win state when the target score is reached and enters a lose state after too many incorrect inputs.

This was a team course project. My main contribution included system design, Verilog implementation, game logic, display control, and final integration.

## Features

- Four-direction arrow display: up, down, left, and right
- FSM-based game state control
- LFSR-based pseudo-random arrow generation
- Dot-matrix row scanning and display output
- Button input detection
- Seven-segment score display
- Score update logic
- Difficulty scaling based on score
- Win and lose states

## System Logic

The game is implemented using a finite state machine with six states:

- `up`
- `down`
- `left`
- `right`
- `win`
- `lose`

The arrow direction is generated using an LFSR. The dot matrix displays the current arrow, and the button input is checked against the current state. The score is shown using two seven-segment displays.

If the player reaches the target score, the system enters the `win` state and displays a smiley face `:)` on the dot matrix. If the player makes too many incorrect inputs, the system enters the `lose` state and displays a sad face `:(` on the dot matrix.

## I/O Signals

| Signal | Description |
|---|---|
| `clk` | System clock |
| `reset` | Active-low reset |
| `btn[3:0]` | Button inputs for right, up, down, and left |
| `dot_row[7:0]` | Dot matrix row output |
| `dot_col[7:0]` | Dot matrix column output |
| `out_1[6:0]` | Seven-segment display for ones digit |
| `out_2[6:0]` | Seven-segment display for tens digit |

## Demo

Demo video: [Demo Video](https://drive.google.com/file/d/1FZu4MLLmtBf9C9jL4qG2Cu9v9fy7Grtr/view?usp=drive_link)
