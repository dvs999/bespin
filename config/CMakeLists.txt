# the standalone config tool ("bespin")

set(bespin_config_SOURCES main.cpp bconfig.cpp config.cpp kdeini.cpp ../revision.cpp
    bconfig.h config.h dialog.h kdeini.h config.ui uiDemo.ui)

add_executable(bespin_config ${bespin_config_SOURCES})
set_target_properties(bespin_config PROPERTIES OUTPUT_NAME "bespin")
target_compile_definitions(bespin_config PRIVATE EXECUTABLE=1)
target_link_libraries(bespin_config PRIVATE Qt6::Core Qt6::Gui Qt6::Widgets)
install(TARGETS bespin_config DESTINATION ${CMAKE_INSTALL_BINDIR})
