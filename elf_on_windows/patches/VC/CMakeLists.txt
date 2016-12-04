PROJECT(dwarf)
CMAKE_MINIMUM_REQUIRED(VERSION 2.8.12.2)


SET(LIBELF_DIR ${CMAKE_SOURCE_DIR}/../../libelf/lib/install)
LINK_DIRECTORIES(${LIBELF_DIR}/lib)

SET(SRC_DIR ../libdwarf)

ADD_LIBRARY(${PROJECT_NAME} SHARED
    ${SRC_DIR}/dwarf_abbrev.c
    ${SRC_DIR}/dwarf_alloc.c
    ${SRC_DIR}/dwarf_arange.c
    ${SRC_DIR}/dwarf_die_deliv.c
    ${SRC_DIR}/dwarf_elf_access.c
    ${SRC_DIR}/dwarf_error.c
    ${SRC_DIR}/dwarf_form.c
    ${SRC_DIR}/dwarf_frame.c
    ${SRC_DIR}/dwarf_frame2.c
    ${SRC_DIR}/dwarf_frame3.c
    ${SRC_DIR}/dwarf_funcs.c
    ${SRC_DIR}/dwarf_gdbindex.c
    ${SRC_DIR}/dwarf_global.c
    ${SRC_DIR}/dwarf_harmless.c
    ${SRC_DIR}/dwarf_init_finish.c
    ${SRC_DIR}/dwarf_leb.c
    ${SRC_DIR}/dwarf_line.c
    ${SRC_DIR}/dwarf_loc.c
    ${SRC_DIR}/dwarf_macro.c
    ${SRC_DIR}/dwarf_macro5.c
    ${SRC_DIR}/dwarf_original_elf_init.c
    ${SRC_DIR}/dwarf_pubtypes.c
    ${SRC_DIR}/dwarf_query.c
    ${SRC_DIR}/dwarf_ranges.c
    ${SRC_DIR}/dwarf_string.c
    ${SRC_DIR}/dwarf_tied.c
    ${SRC_DIR}/dwarf_tsearchhash.c
    ${SRC_DIR}/dwarf_types.c
    ${SRC_DIR}/dwarf_util.c
    ${SRC_DIR}/dwarf_vars.c
    ${SRC_DIR}/dwarf_weaks.c
    ${SRC_DIR}/dwarf_xu_index.c
    ${SRC_DIR}/dwarf_print_lines.c
    ${SRC_DIR}/malloc_check.c
    ${SRC_DIR}/pro_alloc.c
    ${SRC_DIR}/pro_arange.c
    ${SRC_DIR}/pro_die.c
    ${SRC_DIR}/pro_encode_nm.c
    ${SRC_DIR}/pro_error.c
    ${SRC_DIR}/pro_expr.c
    ${SRC_DIR}/pro_finish.c
    ${SRC_DIR}/pro_forms.c
    ${SRC_DIR}/pro_funcs.c
    ${SRC_DIR}/pro_frame.c
    ${SRC_DIR}/pro_init.c
    ${SRC_DIR}/pro_line.c
    ${SRC_DIR}/pro_reloc.c
    ${SRC_DIR}/pro_reloc_stream.c
    ${SRC_DIR}/pro_reloc_symbolic.c
    ${SRC_DIR}/pro_pubnames.c
    ${SRC_DIR}/pro_section.c
    ${SRC_DIR}/pro_types.c
    ${SRC_DIR}/pro_vars.c
    ${SRC_DIR}/pro_macinfo.c
    ${SRC_DIR}/pro_weaks.c
)

TARGET_INCLUDE_DIRECTORIES(${PROJECT_NAME} PRIVATE . ${SRC_DIR} ${LIBELF_DIR}/include ${LIBELF_DIR}/include/libelf)
TARGET_LINK_LIBRARIES(${PROJECT_NAME} libelf.lib)
