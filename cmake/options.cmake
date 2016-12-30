# Use SymtabAPI or SymLite?
option (LIGHTWEIGHT_SYMTAB "Use lightweight symtab interface for ParseAPI, ProcControl, and Stackwalker; disables DyninstAPI build" OFF)

# Use ParseAPI analysis in Stackwalker?
option (SW_ANALYSIS_STEPPER "Use ParseAPI-based analysis stepper in Stackwalker" ON)

option (BUILD_TARBALLS "Build Dyninst package tarballs. Requires git archive, tar, gzip." OFF)
option (BUILD_RTLIB_32 "Build 32-bit runtime library on mixed 32/64 systems" OFF)

option(BUILD_RTLIB "Building runtime library (can be disabled safely for component-level builds)" ON)
option(BUILD_DOCS "Build manuals from LaTeX sources" ON)

option(ELF_ON_WINDOWS "Enable the ability to load ELFs on Windows" OFF)

# Some global on/off switches
if (LIGHTWEIGHT_SYMTAB)
add_definitions (-DWITHOUT_SYMTAB_API -DWITH_SYMLITE)
else()
add_definitions (-DWITH_SYMTAB_API -DWITHOUT_SYMLITE)
endif()

if (SW_ANALYSIS_STEPPER)
add_definitions (-DUSE_PARSE_API)
endif()

if (ELF_ON_WINDOWS)
add_definitions (-DELF_ON_WINDOWS)
add_definitions (-D__USE_MINGW_ANSI_STDIO=1)
add_definitions (-D_POSIX=1)
endif()

message(STATUS "Options set")
