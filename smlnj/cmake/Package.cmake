# CMake package generation for smlnj-llvm
#
# COPYRIGHT (c) 2025 The Fellowship of SML/NJ (https://www.smlnj.org)
# All rights reserved.
#
# This file generates the `smlnj-llvm` CMake package for both the build tree
# and the install tree, so that clients can use `find_package(smlnj-llvm CONFIG)`.
# The exported targets depend on the LLVM component libraries, which are
# exported by LLVM's own package (in the same tree), so the package
# configuration file loads that package first.  The location of LLVM's
# package is recorded relative to the package's prefix, so the installed
# package is relocatable.
#

include(CMakePackageConfigHelpers)

set(_config_in "${CMAKE_CURRENT_LIST_DIR}/smlnj-llvmConfig.cmake.in")

# --- install tree ---
#
set(_install_dir "${CMAKE_CURRENT_BINARY_DIR}/smlnj/cmake/install")

# LLVM's installed package directory (relative to the install prefix)
set(SMLNJ_LLVM_LLVM_CMAKE_DIR "${LLVM_INSTALL_PACKAGE_DIR}")

configure_package_config_file(${_config_in}
  "${_install_dir}/smlnj-llvmConfig.cmake"
  INSTALL_DESTINATION "${SMLNJ_LLVM_INSTALL_CMAKEDIR}"
  PATH_VARS SMLNJ_LLVM_LLVM_CMAKE_DIR)

write_basic_package_version_file(
  "${_install_dir}/smlnj-llvmConfigVersion.cmake"
  VERSION ${PROJECT_VERSION}
  COMPATIBILITY SameMajorVersion)

install(EXPORT smlnj-llvmTargets
  NAMESPACE smlnj-llvm::
  DESTINATION "${SMLNJ_LLVM_INSTALL_CMAKEDIR}"
  COMPONENT smlnj-llvm-cmake-exports)

install(FILES
  "${_install_dir}/smlnj-llvmConfig.cmake"
  "${_install_dir}/smlnj-llvmConfigVersion.cmake"
  DESTINATION "${SMLNJ_LLVM_INSTALL_CMAKEDIR}"
  COMPONENT smlnj-llvm-cmake-exports)

# --- build tree ---
#
# This allows a client to use the build tree without installing it, by
# pointing `smlnj-llvm_DIR` at the package directory.  LLVM generates its
# build-tree package in `<llvm-binary-dir>/lib/cmake/llvm`.
#
set(_build_pkg_dir "lib${LLVM_LIBDIR_SUFFIX}/cmake/smlnj-llvm")

# LLVM's build-tree package directory (relative to our binary directory)
set(SMLNJ_LLVM_LLVM_CMAKE_DIR "llvm/lib${LLVM_LIBDIR_SUFFIX}/cmake/llvm")

configure_package_config_file(${_config_in}
  "${CMAKE_CURRENT_BINARY_DIR}/${_build_pkg_dir}/smlnj-llvmConfig.cmake"
  INSTALL_DESTINATION "${_build_pkg_dir}"
  INSTALL_PREFIX "${CMAKE_CURRENT_BINARY_DIR}"
  PATH_VARS SMLNJ_LLVM_LLVM_CMAKE_DIR)

write_basic_package_version_file(
  "${CMAKE_CURRENT_BINARY_DIR}/${_build_pkg_dir}/smlnj-llvmConfigVersion.cmake"
  VERSION ${PROJECT_VERSION}
  COMPATIBILITY SameMajorVersion)

export(EXPORT smlnj-llvmTargets
  NAMESPACE smlnj-llvm::
  FILE "${CMAKE_CURRENT_BINARY_DIR}/${_build_pkg_dir}/smlnj-llvmTargets.cmake")

unset(_config_in)
unset(_install_dir)
unset(_build_pkg_dir)
unset(SMLNJ_LLVM_LLVM_CMAKE_DIR)
