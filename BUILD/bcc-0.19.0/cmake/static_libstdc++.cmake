# only turn on static-libstdc++ if also linking statically against clang
string(REGEX MATCH ".*[.]a$" LIBCLANG_ISSTATIC "${libclangBasic}")
# if gcc 4.9 or higher is used, static libstdc++ is a good option
if (CMAKE_COMPILER_IS_GNUCC AND LIBCLANG_ISSTATIC AND (NOT ENABLE_LLVM_SHARED OR libclang-shared STREQUAL "libclang-shared-NOTFOUND"))
  execute_process(COMMAND ${CMAKE_C_COMPILER} -dumpversion OUTPUT_VARIABLE GCC_VERSION)
  if (GCC_VERSION VERSION_GREATER 4.9 OR GCC_VERSION VERSION_EQUAL 4.9)
    execute_process(COMMAND ${CMAKE_C_COMPILER} -print-libgcc-file-name OUTPUT_VARIABLE GCC_LIB)
    get_filename_component(GCC_DIR "${GCC_LIB}" DIRECTORY)
    find_library(GCC_LIBSTDCPP libstdc++.a PATHS "${GCC_DIR}" NO_DEFAULT_PATH)
    if (GCC_LIBSTDCPP)
      message(STATUS "Using static-libstdc++")
      set(CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -static-libstdc++")
    endif()
  endif()
endif()