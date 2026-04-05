# PongRaylibCPP

A classic Pong game built with **C++** and **Raylib**, developed as a hands-on project to learn the C++ language from scratch.

![Raylib](https://img.shields.io/badge/Raylib-v5.5-darkgreen?style=flat-square)
![C++](https://img.shields.io/badge/C++-17-blue?style=flat-square)
![Platform](https://img.shields.io/badge/Platform-Windows-lightgrey?style=flat-square)

---

## 🎓 Tutorial Reference

This project was initially built by following the tutorial below, then expanded with my own modifications and improvements:

- [Pong Game with C++ and Raylib - Beginner Tutorial – by Programming With Nick](https://www.youtube.com/watch?v=VLJlTaFvHo4)

---

## Controls

| Input | Action |
|---|---|
| ↑ Arrow / D-Pad Up | Move paddle up |
| ↓ Arrow / D-Pad Down | Move paddle down |

---

## 🚀 How to Run

### Requirements
- [w64devkit](https://github.com/skeeto/w64devkit) (GCC for Windows) or any MinGW toolchain
- `mingw32-make` available in your PATH

### Steps
1. Clone the repository:
   ```bash
   git clone --recursive --depth=1 https://github.com/GuilhermeAQN/PongRaylibCPP.git
   cd PongRaylibCPP

2. Compile Raylib with SDL2 support:
cd third_party/raylib/src
mingw32-make clean
mingw32-make PLATFORM=PLATFORM_DESKTOP_SDL
cd ../../..
3. Build and run the game:
make
.\game.exe

---

## 🛠️ Development Environment

  - **Language:** C++ 14
  - **IDE:** VS Code with C/C++ extension
  - **Graphics Library:** [Raylib v5.5](https://www.raylib.com/) (compiled with SDL2)
  - **Key C++ concepts applied:**
    - Nested structs and encapsulation
    - Struct inheritance (`CpuPaddle` extends `Paddle`)
    - References and const correctness
    - Variables, functions and scope
    - Conditionals and game loop
    - Gamepad input with SDL2 vibration

---

## 📁 Project Structure

```
PongRaylibCPP/
  ├── src/
  │   └── main.cpp          # Full game source code
  ├── third_party/
  │   ├── SDL2              # Gamepad input and vibration support
  │   └── raylib            # Graphics rendering and window management
  ├── Makefile              # Build configuration
  └── README.md
```

---

## 🎯 Purpose

This project was built to learn C++ through practical game development. Raylib was chosen for its simplicity, allowing me to focus on C++ fundamentals rather than low-level graphics boilerplate.

---
## 📚 Useful Resources

- [Raylib Official Website](https://www.raylib.com/)
- [Raylib Cheatsheet v5.5](https://www.raylib.com/cheatsheet/cheatsheet.html)
- [W3Schools C++](https://www.w3schools.com/cpp/)
- [cppreference.com](https://en.cppreference.com/)

---

*Developed by [Guilherme Nogueira](https://github.com/GuilhermeAQN)*

---

## 📸 Screenshot

> <img width="1285" height="829" alt="image" src="https://github.com/user-attachments/assets/37b7ad1a-963d-4811-bf2d-a26677214bf3" />

---
