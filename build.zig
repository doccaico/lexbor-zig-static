const std = @import("std");
const Build = std.Build;
const exit = std.process.exit;
const print = std.debug.print;
const Allocator = std.mem.Allocator;
const eql = std.mem.eql;
const argsAlloc = std.process.argsAlloc;
// const builtin = @import("builtin");

pub const Options = struct {
    core: bool = false,
    css: bool = false,
    dom: bool = false,
    encoding: bool = false,
    html: bool = false,
    ns: bool = false,
    ports: bool = false,
    punycode: bool = false,
    selectors: bool = false,
    tag: bool = false,
    unicode: bool = false,
    url: bool = false,
    utils: bool = false,
};

pub fn build(b: *std.Build) !void {
    const defaults = Options{};
    var options = Options{
        .core = b.option(bool, "core", "Build a core module") orelse defaults.core,
        .css = b.option(bool, "css", "Build a css module") orelse defaults.css,
        .dom = b.option(bool, "dom", "Build a dom module") orelse defaults.dom,
        .encoding = b.option(bool, "encoding", "Build a encoding module") orelse defaults.encoding,
        .html = b.option(bool, "html", "Build a html module") orelse defaults.html,
        .ports = b.option(bool, "ports", "Build a ports module") orelse defaults.ports,
    };

    if (try test_and_d_option(b.allocator, &options)) {
        print("The test command does not accept the -D option; a full build is always performed.\n", .{});
        print("You cannot select modules to build, and all modules are always built.\n", .{});
        exit(1);
    }

    parseOptions(&options);

    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const core: ?*Build.Step.Compile = if (options.core)
        compileCore(b, .{
            .name = "liblexbor-core",
            .target = target,
            .optimize = optimize,
            .link_libc = true,
        })
    else
        null;

    const css: ?*Build.Step.Compile = if (options.css)
        compileCss(b, .{
            .name = "liblexbor-css",
            .target = target,
            .optimize = optimize,
            .link_libc = true,
        })
    else
        null;

    const dom: ?*Build.Step.Compile = if (options.dom)
        compileDom(b, .{
            .name = "liblexbor-dom",
            .target = target,
            .optimize = optimize,
            .link_libc = true,
        })
    else
        null;

    const encoding: ?*Build.Step.Compile = if (options.encoding)
        compileEncoding(b, .{
            .name = "liblexbor-encoding",
            .target = target,
            .optimize = optimize,
            .link_libc = true,
        })
    else
        null;

    const html: ?*Build.Step.Compile = if (options.html)
        compileHtml(b, .{
            .name = "liblexbor-html",
            .target = target,
            .optimize = optimize,
            .link_libc = true,
        })
    else
        null;

    const ports: ?*Build.Step.Compile = if (options.ports)
        compilePorts(b, .{
            .name = "liblexbor-ports",
            .target = target,
            .optimize = optimize,
            .link_libc = true,
        })
    else
        null;

    const lib_mod = b.addModule("lexbor", .{
        .root_source_file = b.path("src/lexbor.zig"),
    });

    const test_step = b.step("test", "Run lexbor tests");

    const tests = b.addTest(.{
        .root_source_file = b.path("test/tests.zig"),
        .target = target,
        .optimize = optimize,
    });

    tests.root_module.addImport("lexbor", lib_mod);

    b.installArtifact(tests);

    if (options.core) {
        tests.linkLibrary(core.?);
    }
    if (options.css) {
        tests.linkLibrary(css.?);
    }
    if (options.dom) {
        tests.linkLibrary(dom.?);
    }
    if (options.encoding) {
        tests.linkLibrary(encoding.?);
    }
    if (options.html) {
        tests.linkLibrary(html.?);
    }
    if (options.ports) {
        tests.linkLibrary(ports.?);
    }

    test_step.dependOn(&b.addRunArtifact(tests).step);
}

fn test_and_d_option(allocator: Allocator, options: *Options) !bool {
    const is_test = blk: {
        for (try argsAlloc(allocator)) |arg| {
            if (eql(u8, "test", arg)) {
                break :blk true;
            }
        }
        break :blk false;
    };

    if (is_test and (options.core or options.css or options.dom or
        options.encoding or options.html or options.ns or
        options.ports or options.punycode or options.selectors or
        options.tag or options.unicode or options.url or
        options.utils))
    {
        return true;
    }
    return false;
}

fn parseOptions(options: *Options) void {
    if (!options.core and !options.css and !options.dom and
        !options.encoding and !options.html and !options.ns and
        !options.ports and !options.punycode and !options.selectors and
        !options.tag and !options.unicode and !options.url and
        !options.utils)
    {
        options.core = true;
        options.css = true;
        options.dom = true;
        options.encoding = true;
        options.html = true;
        options.ns = true;
        options.ports = true;
        options.punycode = true;
        options.selectors = true;
        options.tag = true;
        options.unicode = true;
        options.url = true;
        options.utils = true;
    } else {
        if (options.core) {
            options.core = true;
            options.ports = true;
        }
        if (options.css) {
            options.core = true;
            options.css = true;
            options.ports = true;
        }
        if (options.dom) {
            options.core = true;
            options.tag = true;
            options.ns = true;
            options.ports = true;
        }
        if (options.encoding) {
            options.core = true;
            options.ports = true;
        }
        if (options.html) {
            options.core = true;
            options.dom = true;
            options.ns = true;
            options.tag = true;
            options.css = true;
            options.selectors = true;
            options.ports = true;
        }
        if (options.ns) {
            options.core = true;
            options.ports = true;
        }
        if (options.ports) {
            options.core = true;
            options.ports = true;
        }
        if (options.punycode) {
            options.core = true;
            options.encoding = true;
            options.ports = true;
        }
        if (options.selectors) {
            options.core = true;
            options.dom = true;
            options.css = true;
            options.tag = true;
            options.ns = true;
            options.ports = true;
        }
        if (options.tag) {
            options.core = true;
            options.ports = true;
        }
        if (options.unicode) {
            options.core = true;
            options.encoding = true;
            options.punycode = true;
            options.ports = true;
        }
        if (options.url) {
            options.core = true;
            options.encoding = true;
            options.unicode = true;
            options.punycode = true;
            options.ports = true;
        }
        if (options.utils) {
            options.core = true;
            options.ports = true;
        }
    }
}

fn compileCore(b: *std.Build, static_options: Build.StaticLibraryOptions) *Build.Step.Compile {
    const lib = b.addStaticLibrary(static_options);
    lib.addIncludePath(b.path("lib"));
    lib.addCSourceFiles(.{
        .files = &.{
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
        },
        .flags = &.{
            "-std=c99",
            "-DLEXBOR_STATIC",
        },
    });
    b.installArtifact(lib);
    return lib;
}

fn compileCss(b: *std.Build, static_options: Build.StaticLibraryOptions) *Build.Step.Compile {
    const lib = b.addStaticLibrary(static_options);
    lib.addIncludePath(b.path("lib"));
    lib.addCSourceFiles(.{
        .files = &.{
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
        },
        .flags = &.{
            "-std=c99",
            "-DLEXBOR_STATIC",
        },
    });
    b.installArtifact(lib);
    return lib;
}

fn compileDom(b: *std.Build, static_options: Build.StaticLibraryOptions) *Build.Step.Compile {
    const lib = b.addStaticLibrary(static_options);
    lib.addIncludePath(b.path("lib"));
    lib.addCSourceFiles(.{
        .files = &.{
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
        },
        .flags = &.{
            "-std=c99",
            "-DLEXBOR_STATIC",
        },
    });
    b.installArtifact(lib);
    return lib;
}

fn compileEncoding(b: *std.Build, static_options: Build.StaticLibraryOptions) *Build.Step.Compile {
    const lib = b.addStaticLibrary(static_options);
    lib.addIncludePath(b.path("lib"));
    lib.addCSourceFiles(.{
        .files = &.{
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
        },
        .flags = &.{
            "-std=c99",
            "-DLEXBOR_STATIC",
        },
    });
    b.installArtifact(lib);
    return lib;
}

fn compileHtml(b: *std.Build, static_options: Build.StaticLibraryOptions) *Build.Step.Compile {
    const lib = b.addStaticLibrary(static_options);
    lib.addIncludePath(b.path("lib"));
    lib.addCSourceFiles(.{
        .files = &.{
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
        },
        .flags = &.{
            "-std=c99",
            "-DLEXBOR_STATIC",
        },
    });
    b.installArtifact(lib);
    return lib;
}

fn compilePorts(b: *std.Build, static_options: Build.StaticLibraryOptions) *Build.Step.Compile {
    const lib = b.addStaticLibrary(static_options);
    lib.addIncludePath(b.path("lib"));
    lib.addCSourceFiles(.{
        .files = &.{
            "lib/lexbor/ports/windows_nt/lexbor/core/fs.c",
            "lib/lexbor/ports/windows_nt/lexbor/core/memory.c",
            "lib/lexbor/ports/windows_nt/lexbor/core/perf.c",
        },
        .flags = &.{
            "-Wall", "-pedantic", "-pipe", "-std=c99",
        },
    });
    b.installArtifact(lib);
    return lib;
}
