cmake_minimum_required(VERSION 3.17)

project(tree-sitter VERSION 1.0 DESCRIPTION "tree-sitter" LANGUAGES C CXX)

# Enable solution folders
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# Restrict to debug and release build types
set(CMAKE_CONFIGURATION_TYPES "Debug;Release")

macro(DeclareMain LibraryName SourceDirectory)
	file(GLOB ${LibraryName}_SOURCES CONFIGURE_DEPENDS ${SourceDirectory}/lib.c ${SourceDirectory}/*.h ${SourceDirectory}/unicode/*.h)
	source_group(TREE ${SourceDirectory} FILES ${${LibraryName}_SOURCES})
	
	add_library(${LibraryName} STATIC ${${LibraryName}_SOURCES})

	target_include_directories(${LibraryName} PUBLIC "${SourceDirectory}")	
	target_compile_options(${LibraryName} PRIVATE "/Zi" "/Oy-")
	target_link_options(${LibraryName} PRIVATE /DEBUG:FULL)
endmacro()

macro(DeclareLanguage LibraryName SourceDirectory HasScanner)
	file(GLOB ${LibraryName}_SOURCES CONFIGURE_DEPENDS ${SourceDirectory}/parser.c ${SourceDirectory}/tree_sitter/*.h)
	
	set(${LibraryName}_SCANNER_SOURCES)
	if (${HasScanner})
		file(GLOB ${LibraryName}_SCANNER_SOURCES CONFIGURE_DEPENDS ${SourceDirectory}/scanner.cc)
	endif()
	
	source_group(TREE ${SourceDirectory} FILES ${${LibraryName}_SOURCES} ${${LibraryName}_SCANNER_SOURCES})
	
	add_library(${LibraryName} STATIC ${${LibraryName}_SOURCES} ${${LibraryName}_SCANNER_SOURCES})
	
	target_include_directories(${LibraryName} PUBLIC "${SourceDirectory}")	
	target_compile_options(${LibraryName} PRIVATE "/Zi" "/Oy-")
	target_link_options(${LibraryName} PRIVATE /DEBUG:FULL)
endmacro()

set(SourceDirectory ${CMAKE_CURRENT_LIST_DIR}/lib/src)

DeclareMain(tree-sitter ${CMAKE_CURRENT_LIST_DIR}/lib/src)
target_include_directories(tree-sitter PUBLIC "${CMAKE_CURRENT_LIST_DIR}/lib/include")

DeclareLanguage(tree-sitter-c ${CMAKE_CURRENT_LIST_DIR}/languages/tree-sitter-c/src FALSE)

DeclareLanguage(tree-sitter-cpp ${CMAKE_CURRENT_LIST_DIR}/languages/tree-sitter-cpp/src TRUE)


