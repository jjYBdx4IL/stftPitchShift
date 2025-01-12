cmake_minimum_required(VERSION 3.18)

project(LibStftPitchShift VERSION 1.3)

add_library(LibStftPitchShift)

if(ENABLE_BUILTIN)
  # formerly include("${CMAKE_CURRENT_LIST_DIR}/pocketfft/CMakeLists.txt")
  find_path(POCKETFFT_INCLUDE_DIR pocketfft_hdronly.h PATHS "${CMAKE_CURRENT_LIST_DIR}/pocketfft" REQUIRED)
else()
  find_path(POCKETFFT_INCLUDE_DIR pocketfft_hdronly.h REQUIRED)
endif()

set_target_properties(LibStftPitchShift
  PROPERTIES OUTPUT_NAME "stftpitchshift"
)

set(HEADER_FILES
  "${CMAKE_CURRENT_LIST_DIR}/Cepstrum.h"
  "${CMAKE_CURRENT_LIST_DIR}/Dump.h"
  "${CMAKE_CURRENT_LIST_DIR}/Pitcher.h"
  "${CMAKE_CURRENT_LIST_DIR}/Resampler.h"
  "${CMAKE_CURRENT_LIST_DIR}/STFT.h"
  "${CMAKE_CURRENT_LIST_DIR}/StftPitchShift.h"
  "${CMAKE_CURRENT_LIST_DIR}/Timer.h"
  "${CMAKE_CURRENT_LIST_DIR}/Version.h"
  "${CMAKE_CURRENT_LIST_DIR}/Vocoder.h"
)

set(SOURCE_FILES
  "${CMAKE_CURRENT_LIST_DIR}/Cepstrum.cpp"
  "${CMAKE_CURRENT_LIST_DIR}/Pitcher.cpp"
  "${CMAKE_CURRENT_LIST_DIR}/Resampler.cpp"
  "${CMAKE_CURRENT_LIST_DIR}/STFT.cpp"
  "${CMAKE_CURRENT_LIST_DIR}/StftPitchShift.cpp"
  "${CMAKE_CURRENT_LIST_DIR}/Vocoder.cpp"
)

target_sources(LibStftPitchShift
  PRIVATE ${HEADER_FILES} ${SOURCE_FILES}
)

target_compile_features(LibStftPitchShift
  PRIVATE cxx_std_11
)

if (UNIX)
  target_link_libraries(LibStftPitchShift
    PRIVATE pthread)
endif()

# ---------------------------------------------------------------------------
# https://cmake.org/cmake/help/git-stage/guide/importing-exporting/index.html
# ---------------------------------------------------------------------------

include(CMakePackageConfigHelpers)
include(GNUInstallDirs)

target_include_directories(LibStftPitchShift
  PUBLIC  "$<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}/..>"
  PRIVATE "$<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}>"
  INTERFACE "$<INSTALL_INTERFACE:include/StftPitchShift>"
)

install(TARGETS ${PROJECT_NAME}
        EXPORT ${PROJECT_NAME}Targets
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
        INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
)

install(FILES ${HEADER_FILES}
        DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/StftPitchShift
)

install(EXPORT ${PROJECT_NAME}Targets
        FILE ${PROJECT_NAME}Targets.cmake
        NAMESPACE ${PROJECT_NAME}::
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)

configure_package_config_file(
  ${CMAKE_CURRENT_SOURCE_DIR}/Config.cmake.in
  "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake"
  INSTALL_DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)

set_property(TARGET ${PROJECT_NAME} PROPERTY VERSION ${PROJECT_VERSION})
set_property(TARGET ${PROJECT_NAME} PROPERTY SOVERSION 1)
set_property(TARGET ${PROJECT_NAME} PROPERTY INTERFACE_${PROJECT_NAME}_MAJOR_VERSION 1)
set_property(TARGET ${PROJECT_NAME} APPEND PROPERTY COMPATIBLE_INTERFACE_STRING ${PROJECT_NAME}_MAJOR_VERSION)

write_basic_package_version_file(
  "${PROJECT_NAME}ConfigVersion.cmake"
  VERSION "${PROJECT_VERSION}"
  COMPATIBILITY AnyNewerVersion
)

install(
  FILES ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
        ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
  DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}
)
