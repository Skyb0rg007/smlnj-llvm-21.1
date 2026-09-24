# CMake configuration for the heap2obj executable
#
# COPYRIGHT (c) 2025 The Fellowship of SML/NJ (https://smlnj.org)
# All rights reserved.
#

set(SRCS
  main.cpp)

add_executable(heap2obj ${SRCS})
add_executable(smlnj-llvm::heap2obj ALIAS heap2obj)

target_link_libraries(heap2obj PRIVATE smlnj-llvm-cxx-options)
target_link_libraries(heap2obj PRIVATE smlnj-llvm::Heap2Obj)

if (SMLNJ_LLVM_INSTALL)
  install(TARGETS heap2obj
    EXPORT smlnj-llvmTargets
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR})
endif()
