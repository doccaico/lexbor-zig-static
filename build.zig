const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const lib_mod = b.addModule("lexbor", .{
        .root_source_file = b.path("src/lexbor.zig"),
    });

    const lexbor = b.addStaticLibrary(.{
        .name = "lexbor",
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });

    b.installArtifact(lexbor);

    lexbor.addIncludePath(b.path("lib"));

    lexbor.addCSourceFiles(.{
        .files = &.{
            //
            // core module
            //
            "lib/lexbor/core/array.c",
            "lib/lexbor/core/array_obj.c",
            "lib/lexbor/core/avl.c",
            "lib/lexbor/core/bst.c",
            "lib/lexbor/core/bst_map.c",
            "lib/lexbor/core/conv.c",
            "lib/lexbor/core/diyfp.c",
            "lib/lexbor/core/dobject.c",
            "lib/lexbor/core/dtoa.c",
            "lib/lexbor/core/hash.c",
            "lib/lexbor/core/in.c",
            "lib/lexbor/core/mem.c",
            "lib/lexbor/core/mraw.c",
            "lib/lexbor/core/plog.c",
            "lib/lexbor/core/print.c",
            "lib/lexbor/core/serialize.c",
            "lib/lexbor/core/shs.c",
            "lib/lexbor/core/str.c",
            "lib/lexbor/core/strtod.c",
            "lib/lexbor/core/utils.c",
            //
            // css module
            //
            "lib/lexbor/css/at_rule/state.c",
            "lib/lexbor/css/at_rule.c",
            "lib/lexbor/css/css.c",
            "lib/lexbor/css/declaration.c",
            "lib/lexbor/css/log.c",
            "lib/lexbor/css/parser.c",
            "lib/lexbor/css/property/state.c",
            "lib/lexbor/css/property.c",
            "lib/lexbor/css/rule.c",
            "lib/lexbor/css/selectors/pseudo.c",
            "lib/lexbor/css/selectors/pseudo_state.c",
            "lib/lexbor/css/selectors/selector.c",
            "lib/lexbor/css/selectors/selectors.c",
            "lib/lexbor/css/selectors/state.c",
            "lib/lexbor/css/state.c",
            "lib/lexbor/css/stylesheet.c",
            "lib/lexbor/css/syntax/anb.c",
            "lib/lexbor/css/syntax/parser.c",
            "lib/lexbor/css/syntax/state.c",
            "lib/lexbor/css/syntax/syntax.c",
            "lib/lexbor/css/syntax/token.c",
            "lib/lexbor/css/syntax/tokenizer/error.c",
            "lib/lexbor/css/syntax/tokenizer.c",
            "lib/lexbor/css/unit.c",
            "lib/lexbor/css/value.c",
            //
            // dom module
            //
            "lib/lexbor/dom/collection.c",
            "lib/lexbor/dom/exception.c",
            "lib/lexbor/dom/interface.c",
            "lib/lexbor/dom/interfaces/attr.c",
            "lib/lexbor/dom/interfaces/cdata_section.c",
            "lib/lexbor/dom/interfaces/character_data.c",
            "lib/lexbor/dom/interfaces/comment.c",
            "lib/lexbor/dom/interfaces/document.c",
            "lib/lexbor/dom/interfaces/document_fragment.c",
            "lib/lexbor/dom/interfaces/document_type.c",
            "lib/lexbor/dom/interfaces/element.c",
            "lib/lexbor/dom/interfaces/event_target.c",
            "lib/lexbor/dom/interfaces/node.c",
            "lib/lexbor/dom/interfaces/processing_instruction.c",
            "lib/lexbor/dom/interfaces/shadow_root.c",
            "lib/lexbor/dom/interfaces/text.c",
            //
            // encoding module
            //
            "lib/lexbor/encoding/big5.c",
            "lib/lexbor/encoding/decode.c",
            "lib/lexbor/encoding/encode.c",
            "lib/lexbor/encoding/encoding.c",
            "lib/lexbor/encoding/euc_kr.c",
            "lib/lexbor/encoding/gb18030.c",
            "lib/lexbor/encoding/iso_2022_jp_katakana.c",
            "lib/lexbor/encoding/jis0208.c",
            "lib/lexbor/encoding/jis0212.c",
            "lib/lexbor/encoding/range.c",
            "lib/lexbor/encoding/res.c",
            "lib/lexbor/encoding/single.c",
            //
            // html module
            //
            "lib/lexbor/html/encoding.c",
            "lib/lexbor/html/interface.c",
            "lib/lexbor/html/interfaces/anchor_element.c",
            "lib/lexbor/html/interfaces/area_element.c",
            "lib/lexbor/html/interfaces/audio_element.c",
            "lib/lexbor/html/interfaces/base_element.c",
            "lib/lexbor/html/interfaces/body_element.c",
            "lib/lexbor/html/interfaces/br_element.c",
            "lib/lexbor/html/interfaces/button_element.c",
            "lib/lexbor/html/interfaces/canvas_element.c",
            "lib/lexbor/html/interfaces/d_list_element.c",
            "lib/lexbor/html/interfaces/data_element.c",
            "lib/lexbor/html/interfaces/data_list_element.c",
            "lib/lexbor/html/interfaces/details_element.c",
            "lib/lexbor/html/interfaces/dialog_element.c",
            "lib/lexbor/html/interfaces/directory_element.c",
            "lib/lexbor/html/interfaces/div_element.c",
            "lib/lexbor/html/interfaces/document.c",
            "lib/lexbor/html/interfaces/element.c",
            "lib/lexbor/html/interfaces/embed_element.c",
            "lib/lexbor/html/interfaces/field_set_element.c",
            "lib/lexbor/html/interfaces/font_element.c",
            "lib/lexbor/html/interfaces/form_element.c",
            "lib/lexbor/html/interfaces/frame_element.c",
            "lib/lexbor/html/interfaces/frame_set_element.c",
            "lib/lexbor/html/interfaces/head_element.c",
            "lib/lexbor/html/interfaces/heading_element.c",
            "lib/lexbor/html/interfaces/hr_element.c",
            "lib/lexbor/html/interfaces/html_element.c",
            "lib/lexbor/html/interfaces/iframe_element.c",
            "lib/lexbor/html/interfaces/image_element.c",
            "lib/lexbor/html/interfaces/input_element.c",
            "lib/lexbor/html/interfaces/label_element.c",
            "lib/lexbor/html/interfaces/li_element.c",
            "lib/lexbor/html/interfaces/link_element.c",
            "lib/lexbor/html/interfaces/map_element.c",
            "lib/lexbor/html/interfaces/marquee_element.c",
            "lib/lexbor/html/interfaces/media_element.c",
            "lib/lexbor/html/interfaces/menu_element.c",
            "lib/lexbor/html/interfaces/meta_element.c",
            "lib/lexbor/html/interfaces/meter_element.c",
            "lib/lexbor/html/interfaces/mod_element.c",
            "lib/lexbor/html/interfaces/o_list_element.c",
            "lib/lexbor/html/interfaces/object_element.c",
            "lib/lexbor/html/interfaces/opt_group_element.c",
            "lib/lexbor/html/interfaces/option_element.c",
            "lib/lexbor/html/interfaces/output_element.c",
            "lib/lexbor/html/interfaces/paragraph_element.c",
            "lib/lexbor/html/interfaces/param_element.c",
            "lib/lexbor/html/interfaces/picture_element.c",
            "lib/lexbor/html/interfaces/pre_element.c",
            "lib/lexbor/html/interfaces/progress_element.c",
            "lib/lexbor/html/interfaces/quote_element.c",
            "lib/lexbor/html/interfaces/script_element.c",
            "lib/lexbor/html/interfaces/select_element.c",
            "lib/lexbor/html/interfaces/slot_element.c",
            "lib/lexbor/html/interfaces/source_element.c",
            "lib/lexbor/html/interfaces/span_element.c",
            "lib/lexbor/html/interfaces/style_element.c",
            "lib/lexbor/html/interfaces/table_caption_element.c",
            "lib/lexbor/html/interfaces/table_cell_element.c",
            "lib/lexbor/html/interfaces/table_col_element.c",
            "lib/lexbor/html/interfaces/table_element.c",
            "lib/lexbor/html/interfaces/table_row_element.c",
            "lib/lexbor/html/interfaces/table_section_element.c",
            "lib/lexbor/html/interfaces/template_element.c",
            "lib/lexbor/html/interfaces/text_area_element.c",
            "lib/lexbor/html/interfaces/time_element.c",
            "lib/lexbor/html/interfaces/title_element.c",
            "lib/lexbor/html/interfaces/track_element.c",
            "lib/lexbor/html/interfaces/u_list_element.c",
            "lib/lexbor/html/interfaces/unknown_element.c",
            "lib/lexbor/html/interfaces/video_element.c",
            "lib/lexbor/html/interfaces/window.c",
            "lib/lexbor/html/node.c",
            "lib/lexbor/html/parser.c",
            "lib/lexbor/html/serialize.c",
            "lib/lexbor/html/style.c",
            "lib/lexbor/html/token.c",
            "lib/lexbor/html/token_attr.c",
            "lib/lexbor/html/tokenizer/error.c",
            "lib/lexbor/html/tokenizer/state.c",
            "lib/lexbor/html/tokenizer/state_comment.c",
            "lib/lexbor/html/tokenizer/state_doctype.c",
            "lib/lexbor/html/tokenizer/state_rawtext.c",
            "lib/lexbor/html/tokenizer/state_rcdata.c",
            "lib/lexbor/html/tokenizer/state_script.c",
            "lib/lexbor/html/tokenizer.c",
            "lib/lexbor/html/tree/active_formatting.c",
            "lib/lexbor/html/tree/error.c",
            "lib/lexbor/html/tree/insertion_mode/after_after_body.c",
            "lib/lexbor/html/tree/insertion_mode/after_after_frameset.c",
            "lib/lexbor/html/tree/insertion_mode/after_body.c",
            "lib/lexbor/html/tree/insertion_mode/after_frameset.c",
            "lib/lexbor/html/tree/insertion_mode/after_head.c",
            "lib/lexbor/html/tree/insertion_mode/before_head.c",
            "lib/lexbor/html/tree/insertion_mode/before_html.c",
            "lib/lexbor/html/tree/insertion_mode/foreign_content.c",
            "lib/lexbor/html/tree/insertion_mode/in_body.c",
            "lib/lexbor/html/tree/insertion_mode/in_caption.c",
            "lib/lexbor/html/tree/insertion_mode/in_cell.c",
            "lib/lexbor/html/tree/insertion_mode/in_column_group.c",
            "lib/lexbor/html/tree/insertion_mode/in_frameset.c",
            "lib/lexbor/html/tree/insertion_mode/in_head.c",
            "lib/lexbor/html/tree/insertion_mode/in_head_noscript.c",
            "lib/lexbor/html/tree/insertion_mode/in_row.c",
            "lib/lexbor/html/tree/insertion_mode/in_select.c",
            "lib/lexbor/html/tree/insertion_mode/in_select_in_table.c",
            "lib/lexbor/html/tree/insertion_mode/in_table.c",
            "lib/lexbor/html/tree/insertion_mode/in_table_body.c",
            "lib/lexbor/html/tree/insertion_mode/in_table_text.c",
            "lib/lexbor/html/tree/insertion_mode/in_template.c",
            "lib/lexbor/html/tree/insertion_mode/initial.c",
            "lib/lexbor/html/tree/insertion_mode/text.c",
            "lib/lexbor/html/tree/open_elements.c",
            "lib/lexbor/html/tree/template_insertion.c",
            "lib/lexbor/html/tree.c",
            //
            // ns module
            //

            //
            // ports module
            //
            "lib/lexbor/ports/windows_nt/lexbor/core/fs.c",
            "lib/lexbor/ports/windows_nt/lexbor/core/memory.c",
            "lib/lexbor/ports/windows_nt/lexbor/core/perf.c",
        },
        .flags = &.{
            "-std=c99",
            "-DLEXBOR_STATIC",
        },
    });

    const test_step = b.step("test", "Run lexbor tests");

    const tests = b.addTest(.{
        .root_source_file = b.path("test/unit_tests.zig"),
        .target = target,
        .optimize = optimize,
    });

    tests.root_module.addImport("lexbor", lib_mod);

    b.installArtifact(tests);

    tests.linkLibrary(lexbor);

    test_step.dependOn(&b.addRunArtifact(tests).step);
}
