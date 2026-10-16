project(QtBespin LANGUAGES CXX)

set(QtBespin_SOURCES colors.cpp dpi.cpp elements.cpp FX.cpp gradients.cpp shapes.cpp
    tileset.cpp shadows.cpp WM.cpp)

# blib is linked statically into the style, so it doesn't need a separate install
add_library(QtBespin STATIC ${QtBespin_SOURCES})
target_compile_definitions(QtBespin PUBLIC BLIB_EXPORT=)
target_include_directories(QtBespin PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/..)
target_link_libraries(QtBespin PUBLIC Qt6::Core Qt6::Gui Qt6::Widgets)
