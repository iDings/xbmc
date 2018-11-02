#.rst:
# FindLuajit
# -----------
# Finds the LuaJIT library
#
# This will define the following variables::
#
# LUAJIT_FOUND - system has LuaJIT
# LUAJIT_INCLUDE_DIRS - the LuaJIT include directory
# LUAJIT_LIBRARIES - the LuaJIT libraries
#
# and the following imported targets::
#
#   LuaJIT::LuaJIT - The LuaJIT library

if(PKG_CONFIG_FOUND)
  pkg_check_modules(PC_LUAJIT luajit QUIET)
endif()

find_path(LUAJIT_INCLUDE_DIR NAMES luajit.h
                             PATHS ${PC_LUAJIT_INCLUDEDIR})
# XXX:always static library?
find_library(LUAJIT_LIBRARY NAMES ${PC_LUAJIT_STATIC_LIBRARIES}
                            PATHS ${PC_LUAJIT_STATIC_LIBRARIESLIBDIR})

set(LUAJIT_VERSION ${PC_LUAJIT_VERSION})

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Luajit
                                  REQUIRED_VARS LUAJIT_LIBRARY LUAJIT_INCLUDE_DIR
                                  VERSION_VAR LUAJIT_VERSION)

if(LUAJIT_FOUND)
  set(LUAJIT_INCLUDE_DIRS ${LUAJIT_INCLUDE_DIR})
  set(LUAJIT_LIBRARIES ${LUAJIT_LIBRARY})
  list(APPEND LUAJIT_DEFINITIONS -DHAS_LUA=1)

  if(NOT TARGET LuaJIT::LuaJIT)
    add_library(LuaJIT::LuaJIT UNKNOWN IMPORTED)
    set_target_properties(LuaJIT::LuaJIT PROPERTIES
                                          IMPORTED_LOCATION "${LUAJIT_LIBRARY}"
                                          INTERFACE_INCLUDE_DIRECTORIES "${LUAJIT_INCLUDE_DIR}")
  endif()
endif()

mark_as_advanced(LUAJIT_INCLUDE_DIR LUAJIT_LIBRARY)
