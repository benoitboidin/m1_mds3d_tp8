#----------------------------------------------------------------
# Generated CMake target import file.
#----------------------------------------------------------------

# Commands may need to know the format version.
set(CMAKE_IMPORT_FILE_VERSION 1)

# Import target "::glbinding" for configuration ""
set_property(TARGET ::glbinding APPEND PROPERTY IMPORTED_CONFIGURATIONS NOCONFIG)
set_target_properties(::glbinding PROPERTIES
  IMPORTED_LINK_INTERFACE_LANGUAGES_NOCONFIG "CXX"
  IMPORTED_LOCATION_NOCONFIG "${_IMPORT_PREFIX}/lib/libglbinding.a"
  )

list(APPEND _cmake_import_check_targets ::glbinding )
list(APPEND _cmake_import_check_files_for_::glbinding "${_IMPORT_PREFIX}/lib/libglbinding.a" )

# Commands beyond this point should not need to know the version.
set(CMAKE_IMPORT_FILE_VERSION)
