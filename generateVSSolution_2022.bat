@echo off
mkdir msvc64
cmake -S . -B ./msvc64 -G "Visual Studio 17 2022" -A x64