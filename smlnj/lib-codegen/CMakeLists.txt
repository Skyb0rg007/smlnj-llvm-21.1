# CMake configuration for the Codegen Library
#
# COPYRIGHT (c) 2024 The Fellowship of SML/NJ (https://smlnj.org)
# All rights reserved.
#

set(SRCS
  asdl-integer.cpp
  asdl.cpp
  cfg-codegen.cpp
  cfg-init.cpp
  cfg-prim-codegen.cpp
  cfg.cpp
  cm-registers.cpp
  context.cpp
  c-types-codegen.cpp
  lambda-var.cpp
  mc-gen.cpp
  object-file.cpp
  objfile-stream.cpp
  overflow.cpp
  target-info.cpp)

# the public interface of the library
#
set(INCLUDE_DIR ${PROJECT_SOURCE_DIR}/smlnj/include)
set(HDRS
  ${INCLUDE_DIR}/asdl/asdl.hpp
  ${INCLUDE_DIR}/asdl/asdl-integer.hpp
  ${INCLUDE_DIR}/asdl/asdl-stream.hpp
  ${INCLUDE_DIR}/asdl/config.h
  ${INCLUDE_DIR}/cfg.hpp
  ${INCLUDE_DIR}/cm-registers.hpp
  ${INCLUDE_DIR}/context.hpp
  ${INCLUDE_DIR}/lambda-var.hpp
  ${INCLUDE_DIR}/object-file.hpp
  ${INCLUDE_DIR}/objfile-stream.hpp
  ${INCLUDE_DIR}/target-info.hpp)

add_library(CFGCodeGen STATIC ${SRCS})
add_library(smlnj-llvm::CFGCodeGen ALIAS CFGCodeGen)

target_sources(CFGCodeGen
  PUBLIC
    FILE_SET HEADERS
    BASE_DIRS ${INCLUDE_DIR}
    FILES ${HDRS})

# enable debug messages
if (SMLNJ_DEBUG_CODEGEN)
  message(STATUS "Code-generator debug messages enabled")
  target_compile_definitions(CFGCodeGen PRIVATE DEBUG_CODEGEN)
endif()

# the public headers include LLVM headers, so clients need the LLVM headers
# too; the private include directory holds the generated smlnj/config.h
#
target_link_libraries(CFGCodeGen
  PUBLIC smlnj-llvm-headers
  PRIVATE smlnj-llvm-cxx-options)
target_include_directories(CFGCodeGen PRIVATE ${SMLNJ_LLVM_CONFIG_INCLUDE_DIR})

# the LLVM component libraries that we depend on; these are public, since
# clients must link against them (and their include directories are needed
# by our public headers).
#
llvm_map_components_to_libnames(LLVM_LIBS ${LLVM_TARGETS_TO_BUILD} passes runtimedyld)
target_link_libraries(CFGCodeGen PUBLIC ${LLVM_LIBS})

if (SMLNJ_LLVM_INSTALL)
  install(TARGETS CFGCodeGen
    EXPORT smlnj-llvmTargets
    ARCHIVE DESTINATION ${SMLNJ_LLVM_INSTALL_LIBDIR}
    FILE_SET HEADERS DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
endif()
