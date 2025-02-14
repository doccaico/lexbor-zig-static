// src/core.h
const std = @import("std");

const lb = @import("lexbor.zig");

// core/array.h

pub const array = extern struct {
    list: ?[*]?*anyopaque,
    size: usize,
    length: usize,

    pub fn create() ?*array {
        return lexbor_array_create();
    }

    pub fn init(self: ?*array, size: usize) status {
        return lexbor_array_init(self, size);
    }

    pub fn clean(self: ?*array) void {
        return lexbor_array_clean(self);
    }

    pub fn destroy(self: ?*array, self_destroy: bool) ?*array {
        return lexbor_array_destroy(self, self_destroy);
    }

    pub fn expand(self: ?*array, up_to: usize) ?*?*anyopaque {
        return lexbor_array_expand(self, up_to);
    }

    pub fn push(self: ?*array, value: ?*anyopaque) status {
        return lexbor_array_push(self, value);
    }

    pub fn pop(self: ?*array) ?*anyopaque {
        return lexbor_array_pop(self);
    }

    pub fn insert(self: ?*array, idx: usize, value: ?*anyopaque) status {
        return lexbor_array_insert(self, idx, value);
    }

    pub fn set(self: ?*array, idx: usize, value: ?*anyopaque) status {
        return lexbor_array_set(self, idx, value);
    }

    pub fn delete(self: ?*array, begin: usize, length: usize) void {
        return lexbor_array_delete(self, begin, length);
    }

    pub inline fn get(self: ?*array, idx: usize) ?*anyopaque {
        if (idx >= self.?.length) {
            return null;
        }
        return self.?.list.?[idx];
    }

    pub fn get_noi(self: ?*array, idx: usize) ?*anyopaque {
        return lexbor_array_get_noi(self, idx);
    }

    pub fn length_noi(self: ?*array) usize {
        return lexbor_array_length_noi(self);
    }

    pub fn size_noi(self: ?*array) usize {
        return lexbor_array_size_noi(self);
    }
};

extern fn lexbor_array_create() ?*array;
extern fn lexbor_array_init(array: ?*array, size: usize) status;
extern fn lexbor_array_clean(array: ?*array) void;
extern fn lexbor_array_destroy(array: ?*array, self_destroy: bool) ?*array;
extern fn lexbor_array_expand(array: ?*array, up_to: usize) ?*?*anyopaque;
extern fn lexbor_array_push(array: ?*array, value: ?*anyopaque) status;
extern fn lexbor_array_pop(array: ?*array) ?*anyopaque;
extern fn lexbor_array_insert(array: ?*array, idx: usize, value: ?*anyopaque) status;
extern fn lexbor_array_set(array: ?*array, idx: usize, value: ?*anyopaque) status;
extern fn lexbor_array_delete(array: ?*array, begin: usize, length: usize) void;
extern fn lexbor_array_get_noi(array: ?*array, idx: usize) ?*anyopaque;
extern fn lexbor_array_length_noi(array: ?*array) usize;
extern fn lexbor_array_size_noi(array: ?*array) usize;

// core/array_obj.h

pub const array_obj = extern struct {
    list: ?[*]u8,
    size: usize,
    length: usize,
    struct_size: usize,

    pub fn create() ?*array_obj {
        return lexbor_array_obj_create();
    }

    pub fn init(self: ?*array_obj, size: usize, struct_size: usize) status {
        return lexbor_array_obj_init(self, size, struct_size);
    }

    pub fn clean(self: ?*array_obj) void {
        return lexbor_array_obj_clean(self);
    }

    pub fn destroy(self: ?*array_obj, self_destroy: bool) ?*array_obj {
        return lexbor_array_obj_destroy(self, self_destroy);
    }

    pub fn expand(self: ?*array_obj, up_to: usize) ?*u8 {
        return lexbor_array_obj_expand(self, up_to);
    }

    pub fn push(self: ?*array_obj) ?*anyopaque {
        return lexbor_array_obj_push(self);
    }

    pub fn push_wo_cls(self: ?*array_obj) ?*anyopaque {
        return lexbor_array_obj_push_wo_cls(self);
    }

    pub fn push_n(self: ?*array_obj, count: usize) ?*anyopaque {
        return lexbor_array_obj_push_wo_cls(self, count);
    }

    pub fn pop(self: ?*array_obj) ?*anyopaque {
        return lexbor_array_obj_pop(self);
    }

    pub fn delete(self: ?*array_obj, begin: usize, length: usize) void {
        return lexbor_array_obj_delete(self, begin, length);
    }

    pub inline fn erase(self: ?*array_obj) void {
        const slice = std.mem.asBytes(self.?);
        @memset(slice, 0);
    }

    pub inline fn get(self: ?*array_obj, idx: usize) ?*anyopaque {
        if (idx >= self.?.length) {
            return null;
        }
        return self.?.list.? + (idx * self.?.struct_size);
    }

    pub inline fn last(self: ?*array_obj) ?*anyopaque {
        if (self.?.length == 0) {
            return null;
        }
        return self.?.list + ((self.?.length - 1) * self.?.struct_size);
    }
};

extern fn lexbor_array_obj_create() ?*array_obj;
extern fn lexbor_array_obj_init(array: ?*array_obj, size: usize, struct_size: usize) status;
extern fn lexbor_array_obj_clean(array: ?*array_obj) void;
extern fn lexbor_array_obj_destroy(array: ?*array_obj, self_destroy: bool) ?*array_obj;
extern fn lexbor_array_obj_expand(array: ?*array_obj, up_to: usize) ?*u8;
extern fn lexbor_array_obj_push(array: ?*array_obj) ?*anyopaque;
extern fn lexbor_array_obj_push_wo_cls(array: ?*array_obj) ?*anyopaque;
extern fn lexbor_array_obj_push_n(array: ?*array_obj, count: usize) ?*anyopaque;
extern fn lexbor_array_obj_pop(array: ?*array_obj) ?*anyopaque;
extern fn lexbor_array_obj_delete(array: ?*array_obj, begin: usize, length: usize) void;
extern fn lexbor_array_obj_erase_noi(array: ?*array_obj) void;
extern fn lexbor_array_obj_get_noi(array: ?*array_obj, idx: usize) ?*anyopaque;
extern fn lexbor_array_obj_length_noi(array: ?*array_obj) usize;
extern fn lexbor_array_obj_size_noi(array: ?*array_obj) usize;
extern fn lexbor_array_obj_struct_size_noi(array: ?*array_obj) usize;
extern fn lexbor_array_obj_last_noi(array: ?*array_obj) ?*anyopaque;

// core/avl.h

pub const avl_node_f = ?*const fn (avl: ?*avl, root: ?*?*avl_node, node: ?*avl_node, ctx: ?*anyopaque) callconv(.C) status;

pub const avl_node = extern struct {
    type: usize,
    height: c_short,
    value: ?*anyopaque,

    left: ?*avl_node,
    right: ?*avl_node,
    parent: ?*avl_node,

    // renaming: node_clean to clean
    pub fn clean(self: ?*avl_node) void {
        return lexbor_avl_node_clean(self);
    }
};

pub const avl = extern struct {
    nodes: ?*dobject,
    last_right: ?*avl_node,

    pub fn create() ?*avl {
        return lexbor_avl_create();
    }

    pub fn init(self: ?*avl, chunk_len: usize, struct_size: usize) status {
        return lexbor_avl_init(self, chunk_len, struct_size);
    }

    pub fn clean(self: ?*avl) void {
        lexbor_avl_clean(self);
    }

    pub fn destroy(self: ?*avl, self_destroy: bool) ?*avl {
        return lexbor_avl_destroy(self, self_destroy);
    }

    pub fn node_make(self: ?*avl, @"type": usize, value: ?*anyopaque) ?*avl_node {
        return lexbor_avl_node_make(self, @"type", value);
    }

    pub fn node_destroy(self: ?*avl, node: ?*avl_node, self_destroy: bool) ?*avl_node {
        return lexbor_avl_node_destroy(self, node, self_destroy);
    }

    pub fn insert(self: ?*avl, scope: ?*?*avl_node, @"type": usize, value: ?*anyopaque) ?*avl_node {
        return lexbor_avl_insert(self, scope, @"type", value);
    }

    pub fn search(self: ?*avl, scope: ?*avl_node, @"type": usize) ?*avl_node {
        return lexbor_avl_search(self, scope, @"type");
    }

    pub fn remove(self: ?*avl, scope: ?*?*avl_node, @"type": usize) ?*anyopaque {
        return lexbor_avl_remove(self, scope, @"type");
    }

    pub fn remove_by_node(self: ?*avl, root: ?*?*avl_node, node: ?*avl_node) void {
        lexbor_avl_remove_by_node(self, root, node);
    }

    pub fn foreach(self: ?*avl, scope: ?*?*avl_node, cb: avl_node_f, ctx: ?*anyopaque) status {
        return lexbor_avl_foreach(self, scope, cb, ctx);
    }

    pub fn foreach_recursion(self: ?*avl, scope: ?*avl_node, callback: avl_node_f, ctx: ?*anyopaque) void {
        lexbor_avl_foreach_recursion(self, scope, callback, ctx);
    }
};

extern fn lexbor_avl_create() ?*avl;
extern fn lexbor_avl_init(avl: ?*avl, chunk_len: usize, struct_size: usize) status;
extern fn lexbor_avl_clean(avl: ?*avl) void;
extern fn lexbor_avl_destroy(avl: ?*avl, struct_destroy: bool) ?*avl;
extern fn lexbor_avl_node_make(avl: ?*avl, type: usize, value: ?*anyopaque) ?*avl_node;
extern fn lexbor_avl_node_clean(node: ?*avl_node) void;
extern fn lexbor_avl_node_destroy(avl: ?*avl, node: ?*avl_node, self_destroy: bool) ?*avl_node;
extern fn lexbor_avl_insert(avl: ?*avl, scope: ?*?*avl_node, type: usize, value: ?*anyopaque) ?*avl_node;
extern fn lexbor_avl_search(avl: ?*avl, scope: ?*avl_node, type: usize) ?*avl_node;
extern fn lexbor_avl_remove(avl: ?*avl, scope: ?*?*avl_node, type: usize) ?*anyopaque;
extern fn lexbor_avl_remove_by_node(avl: ?*avl, root: ?*?*avl_node, node: ?*avl_node) void;
extern fn lexbor_avl_foreach(avl: ?*avl, scope: ?*?*avl_node, cb: avl_node_f, ctx: ?*anyopaque) status;
extern fn lexbor_avl_foreach_recursion(avl: ?*avl, scope: ?*avl_node, callback: avl_node_f, ctx: ?*anyopaque) void;

// core/base.h

const version_major = 1;
const version_minor = 8;
const version_patch = 0;

const version_string = "1.8.0";

pub const Status = enum(c_int) {
    ok = 0x0000,
    @"error" = 0x0001,
    error_memory_allocation,
    error_object_is_null,
    error_small_buffer,
    error_incomplete_object,
    error_no_free_slot,
    error_too_small_size,
    error_not_exists,
    error_wrong_args,
    error_wrong_stage,
    error_unexpected_result,
    error_unexpected_data,
    error_overflow,
    @"continue",
    small_buffer,
    aborted,
    stopped,
    next,
    stop,
    warning,
};

pub const Action = enum(c_int) {
    ok = 0x00,
    stop = 0x01,
    next = 0x02,
};

pub const serialize_cb_f = ?*const fn (data: ?*char, len: usize, ctx: ?*anyopaque) callconv(.C) status;
pub const serialize_cb_cp_f = ?*const fn (cps: ?*codepoint, len: usize, ctx: ?*anyopaque) callconv(.C) status;

pub const serialize_ctx = extern struct {
    c: serialize_cb_f,
    ctx: ?*anyopaque,

    opt: isize,
    count: usize,
};

// core/bst.h

pub const bst_entry_f = ?*const fn (bst: ?*bst, entry: ?*bst_entry, ctx: ?*anyopaque) callconv(.C) bool;

pub const bst_entry = extern struct {
    value: ?*anyopaque,

    right: ?*bst_entry,
    left: ?*bst_entry,
    next: ?*bst_entry,
    parent: ?*bst_entry,

    size: usize,

    pub fn serialize_entry(self: ?*bst_entry, callback: callback_f, ctx: ?*anyopaque, tabs: usize) void {
        return lexbor_bst_serialize(self, callback, ctx, tabs);
    }
};

pub const bst = extern struct {
    dobject: ?*dobject,
    root: ?*bst_entry,

    tree_length: usize,

    pub fn create() ?*bst {
        return lexbor_bst_create();
    }

    pub fn init(self: ?*bst, size: usize) status {
        return lexbor_bst_init(self, size);
    }

    pub fn clean(self: ?*bst) void {
        lexbor_bst_clean(self);
    }

    pub fn destroy(self: ?*bst, self_destroy: bool) ?*bst {
        return lexbor_bst_destroy(self, self_destroy);
    }

    pub fn entry_make(self: ?*bst, size: usize) ?*bst_entry {
        return lexbor_bst_entry_make(self, size);
    }

    pub fn insert(self: ?*bst, scope: ?*?*bst_entry, size: usize, value: ?*anyopaque) ?*bst_entry {
        return lexbor_bst_insert(self, scope, size, value);
    }

    pub fn insert_not_exists(self: ?*bst, scope: ?*?*bst_entry, size: usize) ?*bst_entry {
        return lexbor_bst_insert_not_exists(self, scope, size);
    }

    pub fn search(self: ?*bst, scope: ?*bst_entry, size: usize) ?*bst_entry {
        return lexbor_bst_search(self, scope, size);
    }

    pub fn search_close(self: ?*bst, scope: ?*bst_entry, size: usize) ?*bst_entry {
        return lexbor_bst_search_close(self, scope, size);
    }

    pub fn remove(self: ?*bst, root: ?*?*bst_entry, size: usize) ?*anyopaque {
        return lexbor_bst_remove(self, root, size);
    }

    pub fn remove_close(self: ?*bst, root: ?*?*bst_entry, size: usize, found_size: ?*usize) ?*anyopaque {
        return lexbor_bst_remove_close(self, root, size, found_size);
    }

    pub fn remove_by_pointer(self: ?*bst, entry: ?*bst_entry, root: ?*?*bst_entry) ?*anyopaque {
        return lexbor_bst_remove_by_pointer(self, entry, root);
    }

    pub fn serialize(self: ?*bst, callback: callback_f, ctx: ?*anyopaque) void {
        return lexbor_bst_serialize(self, callback, ctx);
    }
};

extern fn lexbor_bst_create() ?*bst;
extern fn lexbor_bst_init(bst: ?*bst, size: usize) status;
extern fn lexbor_bst_clean(bst: ?*bst) void;
extern fn lexbor_bst_destroy(bst: ?*bst, self_destroy: bool) ?*bst;
extern fn lexbor_bst_entry_make(bst: ?*bst, size: usize) ?*bst_entry;
extern fn lexbor_bst_insert(bst: ?*bst, scope: ?*?*bst_entry, size: usize, value: ?*anyopaque) ?*bst_entry;
extern fn lexbor_bst_insert_not_exists(bst: ?*bst, scope: ?*?*bst_entry, size: usize) ?*bst_entry;
extern fn lexbor_bst_search(bst: ?*bst, scope: ?*bst_entry, size: usize) ?*bst_entry;
extern fn lexbor_bst_search_close(bst: ?*bst, scope: ?*bst_entry, size: usize) ?*bst_entry;
extern fn lexbor_bst_remove(bst: ?*bst, root: ?*?*bst_entry, size: usize) ?*anyopaque;
extern fn lexbor_bst_remove_close(bst: ?*bst, root: ?*?*bst_entry, size: usize, found_size: ?*usize) ?*anyopaque;
extern fn lexbor_bst_remove_by_pointer(bst: ?*bst, entry: ?*bst_entry, root: ?*?*bst_entry) ?*anyopaque;
extern fn lexbor_bst_serialize(bst: ?*bst, callback: callback_f, ctx: ?*anyopaque) void;
extern fn lexbor_bst_serialize_entry(entry: ?*bst_entry, callback: callback_f, ctx: ?*anyopaque, tabs: usize) void;

// core/bst_map.h

pub const bst_map_entry = extern struct {
    str: str,
    value: ?*anyopaque,
};

pub const bst_map = extern struct {
    bst: ?*bst,
    mraw: ?*mraw,
    entries: ?*dobject,

    pub fn create() ?*bst_map {
        return lexbor_bst_map_create();
    }

    pub fn init(self: ?*bst_map, size: usize) status {
        return lexbor_bst_map_init(self, size);
    }

    pub fn clean(self: ?*bst_map) void {
        return lexbor_bst_map_clean(self);
    }

    pub fn destroy(self: ?*bst_map, self_destroy: bool) ?*bst_map {
        return lexbor_bst_map_destroy(self, self_destroy);
    }

    pub fn search(self: ?*bst_map, scope: ?*lb.core.bst_entry, key: ?*const char, key_len: usize) ?*bst_map_entry {
        return lexbor_bst_map_search(self, scope, key, key_len);
    }

    pub fn insert(self: ?*bst_map, scope: ?*?*lb.core.bst_entry, key: ?*const char, key_len: usize, value: ?*anyopaque) ?*bst_map_entry {
        return lexbor_bst_map_insert(self, scope, key, key_len, value);
    }

    pub fn insert_not_exists(self: ?*bst_map, scope: ?*?*lb.core.bst_entry, key: ?*const char, key_len: usize) ?*bst_map_entry {
        return lexbor_bst_map_insert_not_exists(self, scope, key, key_len);
    }

    pub fn remove(self: ?*bst_map, scope: ?*?*lb.core.bst_entry, key: ?*const char, key_len: usize) ?*anyopaque {
        return lexbor_bst_map_remove(self, scope, key, key_len);
    }
};

extern fn lexbor_bst_map_create() ?*bst_map;
extern fn lexbor_bst_map_init(bst_map: ?*bst_map, size: usize) status;
extern fn lexbor_bst_map_clean(bst_map: ?*bst_map) void;
extern fn lexbor_bst_map_destroy(bst_map: ?*bst_map, self_destroy: bool) ?*bst_map;
extern fn lexbor_bst_map_search(bst_map: ?*bst_map, scope: ?*lb.core.bst_entry, key: ?*const char, key_len: usize) ?*bst_map_entry;
extern fn lexbor_bst_map_insert(bst_map: ?*bst_map, scope: ?*?*lb.core.bst_entry, key: ?*const char, key_len: usize, value: ?*anyopaque) ?*bst_map_entry;
extern fn lexbor_bst_map_insert_not_exists(bst_map: ?*bst_map, scope: ?*?*lb.core.bst_entry, key: ?*const char, key_len: usize) ?*bst_map_entry;
extern fn lexbor_bst_map_remove(bst_map: ?*bst_map, scope: ?*?*lb.core.bst_entry, key: ?*const char, key_len: usize) ?*anyopaque;
extern fn lexbor_bst_map_mraw_noi(bst_map: ?*bst_map) ?*mraw;

// core/conv.h

pub fn conv_float_to_data(num: f64, buf: ?*char, len: usize) usize {
    return lexbor_conv_float_to_data(num, buf, len);
}

pub fn conv_long_to_data(num: c_long, buf: ?*char, len: usize) usize {
    return lexbor_conv_long_to_data(num, buf, len);
}

pub fn conv_int64_to_data(num: i64, buf: ?*char, len: usize) usize {
    return lexbor_conv_int64_to_data(num, buf, len);
}

pub fn conv_data_to_double(start: ?*const ?*char, len: usize) f64 {
    return lexbor_conv_data_to_double(start, len);
}

pub fn conv_data_to_ulong(data: ?*const ?*char, length: usize) c_ulong {
    return lexbor_conv_data_to_ulong(data, length);
}

pub fn conv_data_to_long(data: ?*const ?*char, length: usize) c_long {
    return lexbor_conv_data_to_long(data, length);
}

pub fn conv_data_to_uint(data: ?*const ?*char, length: usize) c_uint {
    return lexbor_conv_data_to_uint(data, length);
}

pub fn conv_dec_to_hex(number: u32, out: ?*char, length: usize) usize {
    return lexbor_conv_dec_to_hex(number, out, length);
}

extern fn lexbor_conv_float_to_data(num: f64, buf: ?*char, len: usize) usize;
extern fn lexbor_conv_long_to_data(num: c_long, buf: ?*char, len: usize) usize;
extern fn lexbor_conv_int64_to_data(num: i64, buf: ?*char, len: usize) usize;
extern fn lexbor_conv_data_to_double(start: ?*const ?*char, len: usize) f64;
extern fn lexbor_conv_data_to_ulong(data: ?*const ?*char, length: usize) c_ulong;
extern fn lexbor_conv_data_to_long(data: ?*const ?*char, length: usize) c_long;
extern fn lexbor_conv_data_to_uint(data: ?*const ?*char, length: usize) c_uint;
extern fn lexbor_conv_dec_to_hex(number: u32, out: ?*char, length: usize) usize;

pub inline fn conv_double_to_long(number: f64) c_long {
    if (number > std.math.maxInt(c_long)) {
        return std.math.maxInt(c_long);
    }
    if (number < std.math.minInt(c_long)) {
        return -std.math.maxInt(c_long);
    }
    return @trunc(number);
}

// core/def.h

// core/diyfp.h

pub inline fn uint64_hl(h: anytype, l: anytype) u64 {
    return @intCast((h << 32) + l);
}

pub const DBL_SIGNIFICAND_SIZE = 52;
pub const DBL_EXPONENT_BIAS = 0x3FF + DBL_SIGNIFICAND_SIZE;
pub const DBL_EXPONENT_MIN = -DBL_EXPONENT_BIAS;
pub const DBL_EXPONENT_MAX = 0x7FF - DBL_EXPONENT_BIAS;
pub const DBL_EXPONENT_DENORMAL = -DBL_EXPONENT_BIAS + 1;

pub const DBL_SIGNIFICAND_MASK = uint64_hl(0x000FFFFF, 0xFFFFFFFF);
pub const DBL_HIDDEN_BIT = uint64_hl(0x00100000, 0x00000000);
pub const DBL_EXPONENT_MASK = uint64_hl(0x7FF00000, 0x00000000);
pub const DIYFP_SIGNIFICAND_SIZE = 64;
pub const SIGNIFICAND_SIZE = 53;
pub const SIGNIFICAND_SHIFT = DIYFP_SIGNIFICAND_SIZE - DBL_SIGNIFICAND_SIZE;
pub const DECIMAL_EXPONENT_OFF = 348;
pub const DECIMAL_EXPONENT_MIN = -348;
pub const DECIMAL_EXPONENT_MAX = 340;
pub const DECIMAL_EXPONENT_DIST = 8;

pub const diyfp = extern struct {
    significand: u64,
    exp: c_int,
};

pub fn cached_power_dec(exp: c_int, dec_exp: ?*c_int) diyfp {
    return lexbor_cached_power_dec(exp, dec_exp);
}

pub fn cached_power_bin(exp: c_int, dec_exp: ?*c_int) diyfp {
    return lexbor_cached_power_bin(exp, dec_exp);
}

extern fn lexbor_cached_power_dec(exp: c_int, dec_exp: ?*c_int) diyfp;
extern fn lexbor_cached_power_bin(exp: c_int, dec_exp: ?*c_int) diyfp;

pub inline fn diyfp_leading_zeros64(x: u64) u64 {
    var n: u64 = undefined;

    if (x == 0) {
        return 64;
    }

    n = 0;

    while ((x & 0x8000000000000000) == 0) {
        n += 1;
        x <<= 1;
    }
    return n;
}

pub inline fn diyfp_from_d2(d: u64) diyfp {
    var biased_exp: c_int = undefined;
    var significand: u64 = undefined;
    var r: diyfp = undefined;

    const U = extern union {
        d: f64,
        u64_: u64,
    };
    var u = U{};

    u.d = d;

    biased_exp = (u.u64_ & DBL_EXPONENT_MASK) >> DBL_SIGNIFICAND_SIZE;
    significand = u.u64_ & DBL_SIGNIFICAND_MASK;

    if (biased_exp != 0) {
        r.significand = significand + DBL_HIDDEN_BIT;
        r.exp = biased_exp - DBL_EXPONENT_BIAS;
    } else {
        r.significand = significand;
        r.exp = DBL_EXPONENT_MIN + 1;
    }

    return r;
}

pub inline fn diyfp_2d(v: diyfp) f64 {
    var exp: c_int = undefined;
    var significand: u64 = undefined;
    var biased_exp: u64 = undefined;

    const U = extern union {
        d: f64,
        u64_: u64,
    };
    var u = U{};

    exp = v.exp;
    significand = v.significand;

    while (significand > DBL_HIDDEN_BIT + DBL_SIGNIFICAND_MASK) {
        significand >>= 1;
        exp += 1;
    }

    if (exp >= DBL_EXPONENT_MAX) {
        return std.math.inf(f64);
    }

    if (exp < DBL_EXPONENT_DENORMAL) {
        return 0.0;
    }

    while (exp > DBL_EXPONENT_DENORMAL and (significand & DBL_HIDDEN_BIT) == 0) {
        significand <<= 1;
        exp -= 1;
    }

    if (exp == DBL_EXPONENT_DENORMAL and (significand & DBL_HIDDEN_BIT) == 0) {
        biased_exp = 0;
    } else {
        biased_exp = @intCast(exp + DBL_EXPONENT_BIAS);
    }

    u.u64_ = (significand & DBL_SIGNIFICAND_MASK) | (biased_exp << DBL_SIGNIFICAND_SIZE);

    return u.d;
}

pub inline fn diyfp_shift_left(v: diyfp, shift: c_uint) diyfp {
    return diyfp{ .significand = v.significand << shift, .exp = v.exp - shift };
}

pub inline fn diyfp_shift_right(v: diyfp, shift: c_uint) diyfp {
    return diyfp{ .significand = v.significand >> shift, .exp = v.exp + shift };
}

pub inline fn diyfp_sub(lhs: diyfp, rhs: diyfp) diyfp {
    return diyfp{ .significand = lhs.significand - rhs.significand, .exp = lhs.exp };
}

pub inline fn diyfp_mul(lhs: diyfp, rhs: diyfp) diyfp {
    const a: u64 = lhs.significand >> 32;
    const b: u64 = lhs.significand & 0xffffffff;
    const c: u64 = rhs.significand >> 32;
    const d: u64 = rhs.significand & 0xffffffff;

    const ac: u64 = a * c;
    const bc: u64 = b * c;
    const ad: u64 = a * d;
    const bd: u64 = b * d;

    var tmp: u64 = (bd >> 32) + (ad & 0xffffffff) + (bc & 0xffffffff);

    tmp += @as(c_uint, 1) << 31;

    return diyfp{ .significand = ac + (ad >> 32) + (bc >> 32) + (tmp >> 32), .exp = lhs.exp + rhs.exp + 64 };
}

pub inline fn diyfp_normalize(v: diyfp) diyfp {
    return diyfp_shift_left(v, diyfp_leading_zeros64(v.significand));
}

// core/dobject.h

pub const dobject = extern struct {
    mem: ?*mem,
    cache: ?*array,

    allocated: usize,
    struct_size: usize,
};

extern fn lexbor_dobject_create() ?*dobject;
// extern fn lexbor_dobject_create() ?*dobject;

// core/mem.h

pub const mem_chunk = extern struct {
    data: ?*u8,
    length: usize,
    size: usize,

    next: ?*mem_chunk,
    prev: ?*mem_chunk,
};

pub const mem = extern struct {
    chunk: ?*mem_chunk,
    chunk_first: ?*mem_chunk,

    chunk_min_size: usize,
    chunk_length: usize,
};

// core/lexbor.h

pub fn memory_malloc(size: usize) ?*anyopaque {
    return lexbor_malloc(size);
}

pub fn memory_realloc(dst: ?*anyopaque, size: usize) ?*anyopaque {
    return lexbor_realloc(dst, size);
}

pub fn memory_calloc(num: usize, size: usize) ?*anyopaque {
    return lexbor_calloc(num, size);
}

pub fn memory_free(dst: ?*anyopaque) void {
    lexbor_free(dst);
}

pub fn memory_setup(new_malloc: memory_malloc_f, new_realloc: memory_realloc_f, new_calloc: memory_calloc_f, new_free: memory_free_f) void {
    lexbor_memory_setup(new_malloc, new_realloc, new_calloc, new_free);
}

pub const memory_malloc_f = ?*const fn (size: usize) callconv(.C) ?*anyopaque;
pub const memory_realloc_f = ?*const fn (dst: ?*anyopaque, size: usize) callconv(.C) ?*anyopaque;
pub const memory_calloc_f = ?*const fn (num: usize, size: usize) callconv(.C) ?*anyopaque;
pub const memory_free_f = ?*const fn (dst: ?*anyopaque) callconv(.C) void;

extern fn lexbor_malloc(size: usize) ?*anyopaque;
extern fn lexbor_realloc(dst: *anyopaque, size: usize) ?*anyopaque;
extern fn lexbor_calloc(num: usize, size: usize) ?*anyopaque;
extern fn lexbor_free(dst: ?*anyopaque) void;
extern fn lexbor_memory_setup(new_malloc: memory_malloc_f, new_realloc: memory_realloc_f, new_calloc: memory_calloc_f, new_free: memory_free_f) void;

// core/types.h

pub const codepoint = u32;
pub const char = u8;
pub const status = c_uint;

pub const callback_f = ?*const fn (buffer: ?*char, size: usize, ctx: ?*anyopaque) callconv(.C) status;

// core/mraw.h

pub const mraw = extern struct { mem: ?*mem, cache: ?*bst, ref_count: usize };

// core/str.h

pub const str = extern struct {
    data: ?[*]char,
    length: usize,
};
