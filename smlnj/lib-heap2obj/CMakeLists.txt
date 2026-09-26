# CMake configuration for the heap2obj library
#
# COPYRIGHT (c) 2025 The Fellowship of SML/NJ (https://smlnj.org)
# All rights reserved.
#

set(SRCS
  heap2obj.cpp)

# the public interface of the library
#
set(INCLUDE_DIR ${PROJECT_SOURCE_DIR}/smlnj/include)
set(HDRS
  ${INCLUDE_DIR}/heap2obj.hpp)

add_library(Heap2Obj STATIC ${SRCS})
add_library(smlnj-llvm::Heap2Obj ALIAS Heap2Obj)

target_sources(Heap2Obj
  PUBLIC
    FILE_SET HEADERS
    BASE_DIRS ${INCLUDE_DIR}
    FILES ${HDRS})

# the public header needs C++17 (std::string_view), which the headers
# target provides; the private include directory holds the generated
# smlnj/config.h
#
target_link_libraries(Heap2Obj
  PUBLIC smlnj-llvm-headers
  PRIVATE smlnj-llvm-cxx-options)
target_include_directories(Heap2Obj PRIVATE ${SMLNJ_LLVM_CONFIG_INCLUDE_DIR})

# the LLVM component libraries that we depend on
#
llvm_map_components_to_libnames(LLVM_LIBS ${LLVM_TARGETS_TO_BUILD})
target_link_libraries(Heap2Obj PUBLIC ${LLVM_LIBS})

if (SMLNJ_LLVM_INSTALL)
  install(TARGETS Heap2Obj
    EXPORT smlnj-llvmTargets
    ARCHIVE DESTINATION ${SMLNJ_LLVM_INSTALL_LIBDIR}
    FILE_SET HEADERS DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
endif()
