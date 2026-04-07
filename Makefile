#**************************************************************************************************
#
#   raylib makefile for Desktop platforms, Raspberry Pi, Android and HTML5
#
#   Copyright (c) 2013-2019 Ramon Santamaria (@raysan5)
#
#   This software is provided "as-is", without any express or implied warranty. In no event
#   will the authors be held liable for any damages arising from the use of this software.
#
#   Permission is granted to anyone to use this software for any purpose, including commercial
#   applications, and to alter it and redistribute it freely, subject to the following restrictions:
#
#     1. The origin of this software must not be misrepresented; you must not claim that you
#     wrote the original software. If you use this software in a product, an acknowledgment
#     in the product documentation would be appreciated but is not required.
#
#     2. Altered source versions must be plainly marked as such, and must not be misrepresented
#     as being the original software.
#
#     3. This notice may not be removed or altered from any source distribution.
#
#**************************************************************************************************

.PHONY: all clean

# Define required raylib variables
PROJECT_NAME       ?= game
RAYLIB_VERSION     ?= 5.0.0
RAYLIB_PATH        ?= third_party/raylib

# Define compiler path on Windows
COMPILER_PATH      ?= C:/raylib/w64devkit/bin

# Define default options
PLATFORM           ?= PLATFORM_DESKTOP

DESTDIR ?= /usr/local
RAYLIB_INSTALL_PATH ?= $(DESTDIR)/lib
RAYLIB_H_INSTALL_PATH ?= $(DESTDIR)/include

RAYLIB_LIBTYPE        ?= STATIC
BUILD_MODE            ?= RELEASE
USE_EXTERNAL_GLFW     ?= FALSE
USE_WAYLAND_DISPLAY   ?= FALSE

# Separate library paths for desktop and web
RAYLIB_LIB_DESKTOP ?= $(RAYLIB_PATH)/lib_desktop
RAYLIB_LIB_WEB     ?= $(RAYLIB_PATH)/lib_web

ifeq ($(PLATFORM),PLATFORM_DESKTOP)
    ifeq ($(OS),Windows_NT)
        PLATFORM_OS=WINDOWS
        export PATH := $(COMPILER_PATH):$(PATH)
    else
        UNAMEOS=$(shell uname)
        ifeq ($(UNAMEOS),Linux)
            PLATFORM_OS=LINUX
        endif
        ifeq ($(UNAMEOS),Darwin)
            PLATFORM_OS=OSX
        endif
    endif
endif
ifeq ($(PLATFORM),PLATFORM_RPI)
    PLATFORM_OS=LINUX
endif

RAYLIB_RELEASE_PATH ?= $(RAYLIB_PATH)/src

EXAMPLE_RUNTIME_PATH   ?= $(RAYLIB_RELEASE_PATH)

CC = g++

ifeq ($(PLATFORM),PLATFORM_WEB)
    CC = emcc
endif

MAKE = mingw32-make

ifeq ($(PLATFORM_OS),LINUX)
    MAKE = make
endif
ifeq ($(PLATFORM_OS),OSX)
    MAKE = make
endif

CFLAGS += -Wall -std=c++14 -D_DEFAULT_SOURCE -Wno-missing-braces
ifeq ($(BUILD_MODE),DEBUG)
    CFLAGS += -g -O0
else
    CFLAGS += -s -O1
endif

ifeq ($(PLATFORM),PLATFORM_DESKTOP)
    ifeq ($(PLATFORM_OS),WINDOWS)
        CFLAGS += $(RAYLIB_PATH)/src/raylib.rc.data
    endif
endif

ifeq ($(PLATFORM),PLATFORM_WEB)
    CFLAGS += -Os -s USE_GLFW=3 -s TOTAL_MEMORY=33554432 -s ALLOW_MEMORY_GROWTH -s ASSERTIONS=1
endif

RAYLIB_RELEASE_PATH 	?= $(RAYLIB_PATH)/src

EXAMPLE_RUNTIME_PATH   ?= $(RAYLIB_RELEASE_PATH)

INCLUDE_PATHS = -I. -I$(RAYLIB_PATH)/src -I$(RAYLIB_PATH)/src/external

LDFLAGS = -L. -Lthird_party

# Use separate library directory based on platform
ifneq ($(wildcard $(RAYLIB_LIB_DESKTOP)/.*),)
    LDFLAGS += -L$(RAYLIB_LIB_DESKTOP)
endif
ifneq ($(wildcard $(RAYLIB_PATH)/src/.*),)
    LDFLAGS += -L$(RAYLIB_PATH)/src
endif

ifeq ($(PLATFORM),PLATFORM_DESKTOP)
    ifeq ($(PLATFORM_OS),WINDOWS)
        LDLIBS = -lraylib -lSDL2 -lSDL2main -lopengl32 -lgdi32 -lwinmm -lXInput9_1_0
    endif
    ifeq ($(PLATFORM_OS),LINUX)
        LDLIBS = -lraylib -lGL -lm -lpthread -ldl -lrt
        LDLIBS += -lX11
    endif
    ifeq ($(PLATFORM_OS),OSX)
        LDLIBS = -lraylib -framework OpenGL -framework OpenAL -framework Cocoa -framework IOKit
    endif
endif

ifeq ($(PLATFORM),PLATFORM_RPI)
    LDLIBS = -lraylib -lbrcmGLESv2 -lbrcmEGL -lpthread -lrt -lm -lbcm_host -ldl
endif

ifeq ($(PLATFORM),PLATFORM_WEB)
    LDLIBS = $(RAYLIB_RELEASE_PATH)/libraylib.bc
endif

# Define a recursive wildcard function
rwildcard=$(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2) $(filter $(subst *,%,$2),$d))

SRC_DIR = src
OBJ_DIR = obj

SRC = $(call rwildcard, *.cpp, *.h)
OBJS ?= $(SRC_DIR)/main.cpp

ifeq ($(PLATFORM),PLATFORM_ANDROID)
    MAKEFILE_PARAMS = -f Makefile.Android
    export PROJECT_NAME
    export SRC_DIR
else
    MAKEFILE_PARAMS = $(PROJECT_NAME)
endif

# Web build configuration
WEB_BUILD_DIR = build/web
WEB_RAYLIB = $(RAYLIB_PATH)/src
EMSDK_PATH ?= C:/raylib/emsdk
EMSCRIPTEN_PATH ?= $(EMSDK_PATH)/upstream/emscripten

# Web build target
web:
	@echo [Web] Compiling raylib for web...
	rm -f $(RAYLIB_RELEASE_PATH)/*.o $(RAYLIB_RELEASE_PATH)/libraylib.a
	$(MAKE) -C $(WEB_RAYLIB) PLATFORM=PLATFORM_WEB EMSDK_PATH=$(EMSDK_PATH) EMSCRIPTEN=$(EMSCRIPTEN_PATH) EMCC=$(EMSCRIPTEN_PATH)/emcc.bat PYTHON_PATH=C:/Users/gui_g/AppData/Local/Python/pythoncore-3.14-64
	@echo [Web] Building game...
	$(EMSCRIPTEN_PATH)/emcc $(OBJS) -o $(WEB_BUILD_DIR)/index.html -I. -I$(RAYLIB_PATH)/src -L$(RAYLIB_LIB_WEB) -lraylib -Os -s USE_GLFW=3 -s TOTAL_MEMORY=33554432 -DPLATFORM_WEB -s ALLOW_MEMORY_GROWTH -s ASSERTIONS=1 -s ASYNCIFY -s 'ASYNCIFY_IMPORTS=["InitWindow","WaitTime"]' -s FORCE_FILESYSTEM=1 --preload-file "$(abspath sounds)@/sounds" -s EXPORTED_RUNTIME_METHODS='["FS","HEAPF32"]' -s STACK_SIZE=200000 --shell-file build/web_shell.html
	@echo [Web] Done! Output: $(WEB_BUILD_DIR)/$(PROJECT_NAME).html

# Default target entry (desktop only)
all: $(PROJECT_NAME)

$(PROJECT_NAME): $(OBJS)
	$(CC) -o $(PROJECT_NAME)$(EXT) $(OBJS) $(CFLAGS) $(INCLUDE_PATHS) $(LDFLAGS) $(LDLIBS) -D$(PLATFORM)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	$(CC) -c $< -o $@ $(CFLAGS) $(INCLUDE_PATHS) -D$(PLATFORM)

clean:
ifeq ($(PLATFORM_OS),WINDOWS)
	rm -f *.o *.exe
else
	find . -type f -executable -delete
	rm -f *.o
endif
	@echo Cleaning done
