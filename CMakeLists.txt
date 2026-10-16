cmake_minimum_required(VERSION 3.16)
project(bespin LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)

option(ENABLE_ARGB "Enable translucent windows" ON)

find_package(Qt6 6.2 REQUIRED COMPONENTS Core Gui Widgets)

include(GNUInstallDirs)

if (ENABLE_ARGB)
    add_compile_definitions(BESPIN_ARGB_WINDOWS=1)
else()
    add_compile_definitions(BESPIN_ARGB_WINDOWS=0)
endif()
add_compile_definitions(VARYING_SHADOWS=1)

# revision.h (formerly from svnversion)
find_package(Git QUIET)
set(BESPIN_REVISION "qt6")
if (GIT_FOUND AND EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/.git")
    execute_process(COMMAND ${GIT_EXECUTABLE} rev-parse --short HEAD
                    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
                    OUTPUT_VARIABLE BESPIN_REVISION OUTPUT_STRIP_TRAILING_WHITESPACE)
endif()
file(WRITE ${CMAKE_CURRENT_BINARY_DIR}/revision.h "#define SVN_REVISION ${BESPIN_REVISION}\n")
include_directories(${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR})

add_subdirectory(blib)

set(bespin_SOURCES
    animator/basic.cpp animator/aprogress.cpp animator/hover.cpp
    animator/hoverindex.cpp animator/hovercomplex.cpp animator/tab.cpp
    bespin.cpp buttons.cpp docks.cpp frames.cpp genpixmaps.cpp hacks.cpp init.cpp
    input.cpp menus.cpp pixelmetric.cpp polish.cpp progress.cpp qsubcmetrics.cpp
    scrollareas.cpp indicators.cpp sizefromcontents.cpp slider.cpp stdpix.cpp stylehint.cpp
    tabbing.cpp toolbars.cpp views.cpp visualframe.cpp window.cpp revision.cpp)

file(GLOB bespin_HDRS *.h animator/*.h)

add_library(bespin MODULE ${bespin_SOURCES} ${bespin_HDRS})
target_compile_definitions(bespin PRIVATE BLIB_EXPORT=)
target_link_libraries(bespin PRIVATE QtBespin Qt6::Core Qt6::Gui Qt6::Widgets)
# the DBus bits only talked to the (gone) Bespin KWin decoration and XBar
target_compile_definitions(bespin PRIVATE BESPIN_NO_DBUS)

# install into Qt's style plugin dir
get_target_property(_qmake Qt6::qmake IMPORTED_LOCATION)
execute_process(COMMAND ${_qmake} -query QT_INSTALL_PLUGINS
                OUTPUT_VARIABLE QT6_PLUGINS_DIR OUTPUT_STRIP_TRAILING_WHITESPACE)
install(TARGETS bespin LIBRARY DESTINATION ${QT6_PLUGINS_DIR}/styles)

add_subdirectory(config)

install(FILES man/bespin.1 DESTINATION ${CMAKE_INSTALL_MANDIR}/man1)
install(FILES extras/bespin-compl DESTINATION ${CMAKE_INSTALL_DATADIR}/bash-completion/completions RENAME bespin)
