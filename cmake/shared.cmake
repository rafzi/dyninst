set (DYNINST_MAJOR_VERSION 9)
set (DYNINST_MINOR_VERSION 2)
set (DYNINST_PATCH_VERSION 0)

# Debugging
# set(Boost_DEBUG 1)

set (SOVERSION "${DYNINST_MAJOR_VERSION}.${DYNINST_MINOR_VERSION}")
set (LIBVERSION "${SOVERSION}.${DYNINST_PATCH_VERSION}")
set (DYNINST_VERSION "${LIBVERSION}")

if (LIGHTWEIGHT_SYMTAB)
  set(SYMREADER symLite)
else()
  set(SYMREADER symtabAPI)
endif()

# Link libraries privately when possible
function (target_link_private_libraries target)
  if(${CMAKE_VERSION} VERSION_LESS "2.8.7")
    target_link_libraries (${target} ${ARGN})
  else()
    target_link_libraries (${target} LINK_PRIVATE ${ARGN})
  endif()
endfunction ()

set(ALL_DYNINST_TARGETS "" CACHE INTERNAL "")

function (dyninst_library target)
  add_library (${target} ${SRC_LIST})
  target_link_private_libraries (${target} ${ARGN})
  FILE (GLOB headers "h/*.h" "${CMAKE_CURRENT_BINARY_DIR}/h/*.h")
  set (ACTUAL_TARGETS ${target})
  set (ALL_TARGETS "${ARGN};${target}")
  if(${ENABLE_STATIC_LIBS})
    set (ACTUAL_TARGETS ${ACTUAL_TARGETS} ${target}_static)
    add_library (${target}_static STATIC ${SRC_LIST})
  endif()
  message(STATUS "Building ${ACTUAL_TARGETS}...")
  set_target_properties (${ACTUAL_TARGETS} PROPERTIES PUBLIC_HEADER "${headers}")
  set_target_properties (${ACTUAL_TARGETS} PROPERTIES LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
  set_target_properties (${target} PROPERTIES SOVERSION ${SOVERSION} VERSION ${LIBVERSION} CLEAN_DIRECT_OUTPUT 1)
  set (INSTALL_TARGETS ${ACTUAL_TARGETS})
  foreach (dep ${ARGN})
    message(STATUS "Processing dependent target ${dep}...")
    if(TARGET ${dep})
        get_target_property(dep_dir ${dep} LIBRARY_OUTPUT_DIRECTORY)
        if(EXISTS ${dep_dir} AND IS_DIRECTORY ${dep_dir})
          message(STATUS "Found dependency location ${dep_dir}")
          install(SCRIPT ${dep_dir}/cmake_install.cmake)
        endif()
    endif()
  endforeach()
  install (TARGETS ${INSTALL_TARGETS}
    EXPORT ${target}Targets
    COMPONENT ${target}
    RUNTIME DESTINATION ${INSTALL_LIB_DIR}
    LIBRARY DESTINATION ${INSTALL_LIB_DIR}
    ARCHIVE DESTINATION ${INSTALL_LIB_DIR}
    PUBLIC_HEADER DESTINATION ${INSTALL_INCLUDE_DIR})
  add_custom_target(${target}-install
    DEPENDS ${target}
    COMMAND "${CMAKE_COMMAND}" -P "${CMAKE_CURRENT_BINARY_DIR}/cmake_install.cmake"
    )
  set(ALL_DYNINST_TARGETS "${ALL_DYNINST_TARGETS};${target}" CACHE INTERNAL "")
  install (EXPORT ${target}Targets
    DESTINATION "${INSTALL_CMAKE_DIR}")
  configure_file("${DYNINST_ROOT}/cmake/${PROJECT_NAME}Config.cmake.in" "${PROJECT_BINARY_DIR}/${CMAKE_FILES_DIRECTORY}/${PROJECT_NAME}Config.cmake" @ONLY)
  configure_file("${DYNINST_ROOT}/cmake/${PROJECT_NAME}ConfigVersion.cmake.in" "${PROJECT_BINARY_DIR}/${CMAKE_FILES_DIRECTORY}/${PROJECT_NAME}ConfigVersion.cmake" @ONLY)
  install (FILES
    "${PROJECT_BINARY_DIR}/${CMAKE_FILES_DIRECTORY}/${PROJECT_NAME}Config.cmake"
    "${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/${PROJECT_NAME}ConfigVersion.cmake"
    DESTINATION "${INSTALL_CMAKE_DIR}")
endfunction()



#Change to switch between libiberty/libstdc++ demangler
#set(USE_GNU_DEMANGLER 1)

set (CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${DYNINST_ROOT}/cmake/Modules")
include (${DYNINST_ROOT}/cmake/platform.cmake)
if (NOT ${PROJECT_NAME} MATCHES DyninstRT)
include (${DYNINST_ROOT}/cmake/packages.cmake)
endif()
include (${DYNINST_ROOT}/cmake/cap_arch_def.cmake)
include (${DYNINST_ROOT}/cmake/visibility.cmake)
include (${DYNINST_ROOT}/cmake/warnings.cmake)
include (${DYNINST_ROOT}/cmake/options.cmake)
include (${DYNINST_ROOT}/cmake/optimization.cmake)

set (BUILD_SHARED_LIBS ON)

set (INSTALL_LIB_DIR lib CACHE PATH "Installation directory for libraries")
set (INSTALL_INCLUDE_DIR include CACHE PATH "Installation directory for header files")
set (INSTALL_CMAKE_DIR lib/cmake/${PROJECT_NAME} CACHE PATH "Installation directory for CMake files")
set (INSTALL_DOC_DIR share/doc CACHE PATH "Installation directory for manuals")

# Make the above absolute paths if necessary
foreach (p LIB INCLUDE CMAKE)
  set (var INSTALL_${p}_DIR)
  if (NOT IS_ABSOLUTE "${${var}}")
     set (${var} "${CMAKE_INSTALL_PREFIX}/${${var}}")
  endif()
endforeach()

if(PLATFORM MATCHES nt OR PLATFORM MATCHES windows)
  if (CMAKE_C_COMPILER_VERSION VERSION_GREATER 19)
    add_definitions(-D_SILENCE_STDEXT_HASH_DEPRECATION_WARNINGS=1)
  else()
    add_definitions(-Dsnprintf=_snprintf)
  endif()
endif()

set (USE_CXX11_ABI "" CACHE STRING "Override the default GNU C++11 ABI setting")
if (NOT ("${USE_CXX11_ABI}" STREQUAL ""))
  if (${USE_CXX11_ABI})
    add_definitions(-D_GLIBCXX_USE_CXX11_ABI=1)
  else()
    add_definitions(-D_GLIBCXX_USE_CXX11_ABI=0)
  endif()
endif()

#
# DyninstConfig.cmake

file (RELATIVE_PATH REL_INCLUDE_DIR "${INSTALL_CMAKE_DIR}" "${INSTALL_INCLUDE_DIR}")

# For the install tree
set (CONF_INCLUDE_DIRS "\${DYNINST_CMAKE_DIR}/${REL_INCLUDE_DIR}")

# set default configuration type

if (NOT CMAKE_BUILD_TYPE)
   set (CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING 
       "Choose the build type (None, Debug, Release, RelWithDebInfo, MinSizeRel)" FORCE)
endif()
