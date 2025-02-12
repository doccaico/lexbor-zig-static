const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib_mod = b.addModule("lexbor", .{
        .root_source_file = b.path("src/root.zig"),
    });

    const lexbor = b.addStaticLibrary(.{
        .name = "lexbor",
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });

    b.installArtifact(lexbor);

    lexbor.addIncludePath(b.path("libs"));

    lexbor.addCSourceFiles(.{
        .files = &.{
            //
            // core module
            //
            "libs/lexbor/core/array.c",
            "libs/lexbor/core/array_obj.c",
            "libs/lexbor/core/avl.c",
            "libs/lexbor/core/bst.c",
            "libs/lexbor/core/bst_map.c",
            "libs/lexbor/core/conv.c",
            "libs/lexbor/core/diyfp.c",
            "libs/lexbor/core/dobject.c",
            "libs/lexbor/core/dtoa.c",
            "libs/lexbor/core/hash.c",
            "libs/lexbor/core/in.c",
            "libs/lexbor/core/mem.c",
            "libs/lexbor/core/mraw.c",
            "libs/lexbor/core/plog.c",
            "libs/lexbor/core/print.c",
            "libs/lexbor/core/serialize.c",
            "libs/lexbor/core/shs.c",
            "libs/lexbor/core/str.c",
            "libs/lexbor/core/strtod.c",
            "libs/lexbor/core/utils.c",
            //
            // css module
            //
            "libs/lexbor/css/at_rule/state.c",
            "libs/lexbor/css/at_rule.c",
            "libs/lexbor/css/css.c",
            "libs/lexbor/css/declaration.c",
            "libs/lexbor/css/log.c",
            "libs/lexbor/css/parser.c",
            "libs/lexbor/css/property/state.c",
            "libs/lexbor/css/property.c",
            "libs/lexbor/css/rule.c",
            "libs/lexbor/css/selectors/pseudo.c",
            "libs/lexbor/css/selectors/pseudo_state.c",
            "libs/lexbor/css/selectors/selector.c",
            "libs/lexbor/css/selectors/selectors.c",
            "libs/lexbor/css/selectors/state.c",
            "libs/lexbor/css/state.c",
            "libs/lexbor/css/stylesheet.c",
            "libs/lexbor/css/syntax/anb.c",
            "libs/lexbor/css/syntax/parser.c",
            "libs/lexbor/css/syntax/state.c",
            "libs/lexbor/css/syntax/syntax.c",
            "libs/lexbor/css/syntax/token.c",
            "libs/lexbor/css/syntax/tokenizer/error.c",
            "libs/lexbor/css/syntax/tokenizer.c",
            "libs/lexbor/css/unit.c",
            "libs/lexbor/css/value.c",
            //
            // dom module
            //
            "libs/lexbor/dom/collection.c",
            "libs/lexbor/dom/exception.c",
            "libs/lexbor/dom/interface.c",
            "libs/lexbor/dom/interfaces/attr.c",
            "libs/lexbor/dom/interfaces/cdata_section.c",
            "libs/lexbor/dom/interfaces/character_data.c",
            "libs/lexbor/dom/interfaces/comment.c",
            "libs/lexbor/dom/interfaces/document.c",
            "libs/lexbor/dom/interfaces/document_fragment.c",
            "libs/lexbor/dom/interfaces/document_type.c",
            "libs/lexbor/dom/interfaces/element.c",
            "libs/lexbor/dom/interfaces/event_target.c",
            "libs/lexbor/dom/interfaces/node.c",
            "libs/lexbor/dom/interfaces/processing_instruction.c",
            "libs/lexbor/dom/interfaces/shadow_root.c",
            "libs/lexbor/dom/interfaces/text.c",
            //
            // encoding module
            //
            "libs/lexbor/encoding/big5.c",
            "libs/lexbor/encoding/decode.c",
            "libs/lexbor/encoding/encode.c",
            "libs/lexbor/encoding/encoding.c",
            "libs/lexbor/encoding/euc_kr.c",
            "libs/lexbor/encoding/gb18030.c",
            "libs/lexbor/encoding/iso_2022_jp_katakana.c",
            "libs/lexbor/encoding/jis0208.c",
            "libs/lexbor/encoding/jis0212.c",
            "libs/lexbor/encoding/range.c",
            "libs/lexbor/encoding/res.c",
            "libs/lexbor/encoding/single.c",
            //
            // html module
            //
            "libs/lexbor/html/encoding.c",
            "libs/lexbor/html/interface.c",
            "libs/lexbor/html/interfaces/anchor_element.c",
            "libs/lexbor/html/interfaces/area_element.c",
            "libs/lexbor/html/interfaces/audio_element.c",
            "libs/lexbor/html/interfaces/base_element.c",
            "libs/lexbor/html/interfaces/body_element.c",
            "libs/lexbor/html/interfaces/br_element.c",
            "libs/lexbor/html/interfaces/button_element.c",
            "libs/lexbor/html/interfaces/canvas_element.c",
            "libs/lexbor/html/interfaces/d_list_element.c",
            "libs/lexbor/html/interfaces/data_element.c",
            "libs/lexbor/html/interfaces/data_list_element.c",
            "libs/lexbor/html/interfaces/details_element.c",
            "libs/lexbor/html/interfaces/dialog_element.c",
            "libs/lexbor/html/interfaces/directory_element.c",
            "libs/lexbor/html/interfaces/div_element.c",
            "libs/lexbor/html/interfaces/document.c",
            "libs/lexbor/html/interfaces/element.c",
            "libs/lexbor/html/interfaces/embed_element.c",
            "libs/lexbor/html/interfaces/field_set_element.c",
            "libs/lexbor/html/interfaces/font_element.c",
            "libs/lexbor/html/interfaces/form_element.c",
            "libs/lexbor/html/interfaces/frame_element.c",
            "libs/lexbor/html/interfaces/frame_set_element.c",
            "libs/lexbor/html/interfaces/head_element.c",
            "libs/lexbor/html/interfaces/heading_element.c",
            "libs/lexbor/html/interfaces/hr_element.c",
            "libs/lexbor/html/interfaces/html_element.c",
            "libs/lexbor/html/interfaces/iframe_element.c",
            "libs/lexbor/html/interfaces/image_element.c",
            "libs/lexbor/html/interfaces/input_element.c",
            "libs/lexbor/html/interfaces/label_element.c",
            "libs/lexbor/html/interfaces/li_element.c",
            "libs/lexbor/html/interfaces/link_element.c",
            "libs/lexbor/html/interfaces/map_element.c",
            "libs/lexbor/html/interfaces/marquee_element.c",
            "libs/lexbor/html/interfaces/media_element.c",
            "libs/lexbor/html/interfaces/menu_element.c",
            "libs/lexbor/html/interfaces/meta_element.c",
            "libs/lexbor/html/interfaces/meter_element.c",
            "libs/lexbor/html/interfaces/mod_element.c",
            "libs/lexbor/html/interfaces/o_list_element.c",
            "libs/lexbor/html/interfaces/object_element.c",
            "libs/lexbor/html/interfaces/opt_group_element.c",
            "libs/lexbor/html/interfaces/option_element.c",
            "libs/lexbor/html/interfaces/output_element.c",
            "libs/lexbor/html/interfaces/paragraph_element.c",
            "libs/lexbor/html/interfaces/param_element.c",
            "libs/lexbor/html/interfaces/picture_element.c",
            "libs/lexbor/html/interfaces/pre_element.c",
            "libs/lexbor/html/interfaces/progress_element.c",
            "libs/lexbor/html/interfaces/quote_element.c",
            "libs/lexbor/html/interfaces/script_element.c",
            "libs/lexbor/html/interfaces/select_element.c",
            "libs/lexbor/html/interfaces/slot_element.c",
            "libs/lexbor/html/interfaces/source_element.c",
            "libs/lexbor/html/interfaces/span_element.c",
            "libs/lexbor/html/interfaces/style_element.c",
            "libs/lexbor/html/interfaces/table_caption_element.c",
            "libs/lexbor/html/interfaces/table_cell_element.c",
            "libs/lexbor/html/interfaces/table_col_element.c",
            "libs/lexbor/html/interfaces/table_element.c",
            "libs/lexbor/html/interfaces/table_row_element.c",
            "libs/lexbor/html/interfaces/table_section_element.c",
            "libs/lexbor/html/interfaces/template_element.c",
            "libs/lexbor/html/interfaces/text_area_element.c",
            "libs/lexbor/html/interfaces/time_element.c",
            "libs/lexbor/html/interfaces/title_element.c",
            "libs/lexbor/html/interfaces/track_element.c",
            "libs/lexbor/html/interfaces/u_list_element.c",
            "libs/lexbor/html/interfaces/unknown_element.c",
            "libs/lexbor/html/interfaces/video_element.c",
            "libs/lexbor/html/interfaces/window.c",
            "libs/lexbor/html/node.c",
            "libs/lexbor/html/parser.c",
            "libs/lexbor/html/serialize.c",
            "libs/lexbor/html/style.c",
            "libs/lexbor/html/token.c",
            "libs/lexbor/html/token_attr.c",
            "libs/lexbor/html/tokenizer/error.c",
            "libs/lexbor/html/tokenizer/state.c",
            "libs/lexbor/html/tokenizer/state_comment.c",
            "libs/lexbor/html/tokenizer/state_doctype.c",
            "libs/lexbor/html/tokenizer/state_rawtext.c",
            "libs/lexbor/html/tokenizer/state_rcdata.c",
            "libs/lexbor/html/tokenizer/state_script.c",
            "libs/lexbor/html/tokenizer.c",
            "libs/lexbor/html/tree/active_formatting.c",
            "libs/lexbor/html/tree/error.c",
            "libs/lexbor/html/tree/insertion_mode/after_after_body.c",
            "libs/lexbor/html/tree/insertion_mode/after_after_frameset.c",
            "libs/lexbor/html/tree/insertion_mode/after_body.c",
            "libs/lexbor/html/tree/insertion_mode/after_frameset.c",
            "libs/lexbor/html/tree/insertion_mode/after_head.c",
            "libs/lexbor/html/tree/insertion_mode/before_head.c",
            "libs/lexbor/html/tree/insertion_mode/before_html.c",
            "libs/lexbor/html/tree/insertion_mode/foreign_content.c",
            "libs/lexbor/html/tree/insertion_mode/in_body.c",
            "libs/lexbor/html/tree/insertion_mode/in_caption.c",
            "libs/lexbor/html/tree/insertion_mode/in_cell.c",
            "libs/lexbor/html/tree/insertion_mode/in_column_group.c",
            "libs/lexbor/html/tree/insertion_mode/in_frameset.c",
            "libs/lexbor/html/tree/insertion_mode/in_head.c",
            "libs/lexbor/html/tree/insertion_mode/in_head_noscript.c",
            "libs/lexbor/html/tree/insertion_mode/in_row.c",
            "libs/lexbor/html/tree/insertion_mode/in_select.c",
            "libs/lexbor/html/tree/insertion_mode/in_select_in_table.c",
            "libs/lexbor/html/tree/insertion_mode/in_table.c",
            "libs/lexbor/html/tree/insertion_mode/in_table_body.c",
            "libs/lexbor/html/tree/insertion_mode/in_table_text.c",
            "libs/lexbor/html/tree/insertion_mode/in_template.c",
            "libs/lexbor/html/tree/insertion_mode/initial.c",
            "libs/lexbor/html/tree/insertion_mode/text.c",
            "libs/lexbor/html/tree/open_elements.c",
            "libs/lexbor/html/tree/template_insertion.c",
            "libs/lexbor/html/tree.c",
            //
            // ns module
            //

            //
            // ports module
            //
            "libs/lexbor/ports/windows_nt/lexbor/core/fs.c",
            "libs/lexbor/ports/windows_nt/lexbor/core/memory.c",
            "libs/lexbor/ports/windows_nt/lexbor/core/perf.c",
        },
        .flags = &.{
            "-std=c99",
            "-DLEXBOR_STATIC",
        },
    });

    const test_step = b.step("test", "Run lexbor tests");

    const tests = b.addTest(.{
        .name = "lexbor-core-array-tests",
        .root_source_file = b.path("src/unit-tests.zig"),
        .target = target,
        .optimize = optimize,
    });

    tests.root_module.addImport("lexbor", lib_mod);

    b.installArtifact(tests);

    tests.linkLibrary(lexbor);

    test_step.dependOn(&b.addRunArtifact(tests).step);
}
