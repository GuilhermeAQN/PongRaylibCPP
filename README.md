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

### ⚙️ Setup

Clone the repository **recursively** to pull raylib and SDL2 from submodules:

```bash
git clone --recursive --depth=1 https://github.com/GuilhermeAQN/PongRaylibCPP.git
cd PongRaylibCPP
```

> Already cloned without `--recursive`? Run:
> ```bash
> git submodule update --init --recursive
> ```

---

### 📦 Requirements

| Tool | Purpose | Required? |
|---|---|---|
| `g++` (MinGW or w64devkit) | C++ compiler | ✅ Yes |
| `mingw32-make` | Build system | ✅ Yes (comes with w64devkit) |

**Don't have these?**
- Download [w64devkit](https://github.com/skeeto/w64devkit) — extract anywhere and add `w64devkit/bin` to your PATH.
- Or use any MinGW distribution (MSYS2, TDM-GCC, etc.) — as long as `g++` and `mingw32-make` work in your terminal.

> **Note:** All libraries (compiled Raylib and SDL2) are already included in `third_party/`. You do **not** need to install or compile them separately — unless you want to rebuild Raylib for a different platform.

---

### ▶️ Desktop Build

```bash
make
.\game.exe
```

---

### 🔧 Makefile Options

| Variable | Default | Description |
|---|---|---|
| `COMPILER_PATH` | `C:/raylib/w64devkit/bin` | Path to `g++` and tools (`?=`, can be overridden) |
| `RAYLIB_PATH` | `third_party/raylib` | Path to raylib source and libs |
| `PLATFORM` | `PLATFORM_DESKTOP` | Target platform |
| `BUILD_MODE` | `RELEASE` | `DEBUG` or `RELEASE` |

**Override example:**

```bash
make COMPILER_PATH=C:/my/path/w64devkit/bin
make BUILD_MODE=DEBUG
```

**Targets:**

| Command | What it does |
|---|---|
| `make` | Build desktop |
| `make clean` | Remove compiled files |
| `make web` | Build for web (requires Emscripten SDK) |

---

### 🌐 Web Build *(optional)*

> ⚠️ Requires the [Emscripten SDK](https://emscripten.org/docs/getting_started/downloads.html) configured on your machine. Skip this section if you don't have it.

```bash
make web
```

Then open the result in a browser:

```bash
# Serve locally
python -m http.server 8000 --directory build/web
```

Or open `build/web/index.html` directly in your browser.

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
