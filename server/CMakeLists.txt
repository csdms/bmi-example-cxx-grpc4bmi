# bmi-example-cxx-grpc4bmi

cmake_minimum_required(VERSION 3.12)
project(bmi-example-cxx-grpc4bmi
  VERSION 0.1.0
  LANGUAGES CXX
)

include(GNUInstallDirs)

find_package(PkgConfig REQUIRED)

pkg_check_modules(BMIHEATCXX REQUIRED IMPORTED_TARGET bmiheatcxx)
message(STATUS "  Include dir: ${BMIHEATCXX_INCLUDE_DIRS}")
message(STATUS "  Library path: ${BMIHEATCXX_LINK_LIBRARIES}")
include_directories(${BMIHEATCXX_INCLUDE_DIRS})

pkg_check_modules(PROTOBUF REQUIRED IMPORTED_TARGET protobuf)
message(STATUS "  Include dir: ${PROTOBUF_INCLUDE_DIRS}")
message(STATUS "  Library path: ${PROTOBUF_LINK_LIBRARIES}")

pkg_check_modules(GRPC4BMI REQUIRED IMPORTED_TARGET grpc4bmi)
message(STATUS "  Include dir: ${GRPC4BMI_INCLUDE_DIRS}")
message(STATUS "  Library path: ${GRPC4BMI_LINK_LIBRARIES}")

set(server_exe heatcxx-grpc4bmi-server)

add_executable(${server_exe} ${server_exe}.cxx)
target_link_libraries(${server_exe} ${BMIHEATCXX_LINK_LIBRARIES} ${PROTOBUF_LINK_LIBRARIES} ${GRPC4BMI_LINK_LIBRARIES})

install(
  TARGETS ${server_exe}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
