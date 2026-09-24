# CMake configuration for the cfgc tool
#
# COPYRIGHT (c) 2024 The Fellowship of SML/NJ (https://smlnj.org)
# All rights reserved.
#

set(SRCS
  main.cpp)

add_executable(cfgc ${SRCS})
add_executable(smlnj-llvm::cfgc ALIAS cfgc)

target_link_libraries(cfgc PRIVATE smlnj-llvm-cxx-options)
target_include_directories(cfgc PRIVATE ${SMLNJ_LLVM_CONFIG_INCLUDE_DIR})
target_link_libraries(cfgc PRIVATE smlnj-llvm::CFGCodeGen)

if (SMLNJ_LLVM_INSTALL)
  install(TARGETS cfgc
    EXPORT smlnj-llvmTargets
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
endif()
