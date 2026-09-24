# CMake configuration for SML/NJ LLVM with JWA patches
#
# COPYRIGHT (c) 2024 The Fellowship of SML/NJ (https://www.smlnj.org)
# All rights reserved.
#

## Generate the "smlnj/config.h" header
#
# This header is private to the libraries and tools in this directory; it
# is neither installed nor part of the public interface of the libraries.
#

# determine the operating system
#
if (CMAKE_SYSTEM_NAME STREQUAL "Darwin")
  set(SMLNJ_OPSYS_DARWIN ON)
elseif (CMAKE_SYSTEM_NAME STREQUAL "Linux")
  set(SMLNJ_OPSYS_LINUX ON)
else ()
  message(FATAL_ERROR "unsupported operating system ${CMAKE_SYSTEM_NAME}")
endif()

# the architecture that we are building for (determined by the top-level
# CMakeLists.txt file)
#
if (SMLNJ_LLVM_HOST_TARGET STREQUAL "X86")
  set(SMLNJ_ARCH_AMD64 ON)
elseif (SMLNJ_LLVM_HOST_TARGET STREQUAL "AArch64")
  set(SMLNJ_ARCH_ARM64 ON)
endif()

# determine the enabled code-generation targets
#
foreach(T IN LISTS LLVM_TARGETS_TO_BUILD)
  if(T STREQUAL "X86")
    message(STATUS "enable X86 target")
    set(SMLNJ_ENABLE_X86 ON)
  elseif(T STREQUAL "AArch64")
    message(STATUS "enable ARM64 target")
    set(SMLNJ_ENABLE_ARM64 ON)
  else()
    message(FATAL_ERROR "unknown target architecture ${T}")
  endif()
endforeach()

# the directory that holds the generated header; the libraries and tools
# add it to their private include paths.
#
set(SMLNJ_LLVM_CONFIG_INCLUDE_DIR ${CMAKE_CURRENT_BINARY_DIR}/include)

configure_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/config/config.h.cmake
  ${SMLNJ_LLVM_CONFIG_INCLUDE_DIR}/smlnj/config.h
  @ONLY)

## The libraries and tools
#
add_subdirectory(lib-codegen)
add_subdirectory(lib-heap2obj)
add_subdirectory(heap2obj)

if (SMLNJ_CFGC_BUILD)
  message(STATUS "cfgc tool enabled.")
  add_subdirectory(cfgc)
endif()
