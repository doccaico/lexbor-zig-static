// src/core.h
const std = @import("std");

const lb = @import("lexbor.zig");

// libc

extern fn memset(dest: ?*anyopaque, c: c_int, count: usize) ?*anyopaque;
extern fn memcpy(dest: ?*anyopaque, src: ?*const anyopaque, count: usize) ?*anyopaque;

// core/array.h

pub const Array = extern struct {
    list: ?[*]?*anyopaque,
    size: usize,
    length: usize,

    pub fn create() ?*Array {
        return lexbor_array_create();
    }

    pub fn init(self: ?*Array, size: usize) status {
        return lexbor_array_init(self, size);
    }

    pub fn clean(self: ?*Array) void {
        return lexbor_array_clean(self);
    }

    pub fn destroy(self: ?*Array, self_destroy: bool) ?*Array {
        return lexbor_array_destroy(self, self_destroy);
    }

    pub fn expand(self: ?*Array, up_to: usize) ?*?*anyopaque {
        return lexbor_array_expand(self, up_to);
    }

    pub fn push(self: ?*Array, value: ?*anyopaque) status {
        return lexbor_array_push(self, value);
    }

    pub fn pop(self: ?*Array) ?*anyopaque {
        return lexbor_array_pop(self);
    }

    pub fn insert(self: ?*Array, idx: usize, value: ?*anyopaque) status {
        return lexbor_array_insert(self, idx, value);
    }

    pub fn set(self: ?*Array, idx: usize, value: ?*anyopaque) status {
        return lexbor_array_set(self, idx, value);
    }

    pub fn delete(self: ?*Array, begin: usize, length: usize) void {
        return lexbor_array_delete(self, begin, length);
    }

    pub fn getNoi(self: ?*Array, idx: usize) ?*anyopaque {
        return lexbor_array_get_noi(self, idx);
    }

    pub fn lengthNoi(self: ?*Array) usize {
        return lexbor_array_length_noi(self);
    }

    pub fn sizeNoi(self: ?*Array) usize {
        return lexbor_array_size_noi(self);
    }
};

extern fn lexbor_array_create() ?*Array;
extern fn lexbor_array_init(Array: ?*Array, size: usize) status;
extern fn lexbor_array_clean(Array: ?*Array) void;
extern fn lexbor_array_destroy(Array: ?*Array, self_destroy: bool) ?*Array;
extern fn lexbor_array_expand(Array: ?*Array, up_to: usize) ?*?*anyopaque;
extern fn lexbor_array_push(Array: ?*Array, value: ?*anyopaque) status;
extern fn lexbor_array_pop(Array: ?*Array) ?*anyopaque;
extern fn lexbor_array_insert(Array: ?*Array, idx: usize, value: ?*anyopaque) status;
extern fn lexbor_array_set(Array: ?*Array, idx: usize, value: ?*anyopaque) status;
extern fn lexbor_array_delete(Array: ?*Array, begin: usize, length: usize) void;
extern fn lexbor_array_get_noi(Array: ?*Array, idx: usize) ?*anyopaque;
extern fn lexbor_array_length_noi(Array: ?*Array) usize;
extern fn lexbor_array_size_noi(Array: ?*Array) usize;

pub inline fn arrayGet(array: ?*Array, idx: usize) ?*anyopaque {
    if (idx >= array.?.length) {
        return null;
    }

    return array.?.list.?[idx];
}

pub inline fn arrayLength(array: ?*Array) usize {
    return array.?.length;
}

pub inline fn arraySize(array: ?*Array) usize {
    return array.?.size;
}

// core/array_obj.h

pub const ArrayObj = extern struct {
    list: ?[*]u8,
    size: usize,
    length: usize,
    struct_size: usize,

    pub fn create() ?*ArrayObj {
        return lexbor_array_obj_create();
    }

    pub fn init(self: ?*ArrayObj, size: usize, struct_size: usize) status {
        return lexbor_array_obj_init(self, size, struct_size);
    }

    pub fn clean(self: ?*ArrayObj) void {
        return lexbor_array_obj_clean(self);
    }

    pub fn destroy(self: ?*ArrayObj, self_destroy: bool) ?*ArrayObj {
        return lexbor_array_obj_destroy(self, self_destroy);
    }

    pub fn expand(self: ?*ArrayObj, up_to: usize) ?*u8 {
        return lexbor_array_obj_expand(self, up_to);
    }

    pub fn push(self: ?*ArrayObj) ?*anyopaque {
        return lexbor_array_obj_push(self);
    }

    pub fn pushWoCls(self: ?*ArrayObj) ?*anyopaque {
        return lexbor_array_obj_push_wo_cls(self);
    }

    pub fn pushN(self: ?*ArrayObj, count: usize) ?*anyopaque {
        return lexbor_array_obj_push_wo_cls(self, count);
    }

    pub fn pop(self: ?*ArrayObj) ?*anyopaque {
        return lexbor_array_obj_pop(self);
    }

    pub fn delete(self: ?*ArrayObj, begin: usize, length: usize) void {
        return lexbor_array_obj_delete(self, begin, length);
    }
};

extern fn lexbor_array_obj_create() ?*ArrayObj;
extern fn lexbor_array_obj_init(array: ?*ArrayObj, size: usize, struct_size: usize) status;
extern fn lexbor_array_obj_clean(array: ?*ArrayObj) void;
extern fn lexbor_array_obj_destroy(array: ?*ArrayObj, self_destroy: bool) ?*ArrayObj;
extern fn lexbor_array_obj_expand(array: ?*ArrayObj, up_to: usize) ?*u8;
extern fn lexbor_array_obj_push(array: ?*ArrayObj) ?*anyopaque;
extern fn lexbor_array_obj_push_wo_cls(array: ?*ArrayObj) ?*anyopaque;
extern fn lexbor_array_obj_push_n(array: ?*ArrayObj, count: usize) ?*anyopaque;
extern fn lexbor_array_obj_pop(array: ?*ArrayObj) ?*anyopaque;
extern fn lexbor_array_obj_delete(array: ?*ArrayObj, begin: usize, length: usize) void;
extern fn lexbor_array_obj_erase_noi(array: ?*ArrayObj) void;
extern fn lexbor_array_obj_get_noi(array: ?*ArrayObj, idx: usize) ?*anyopaque;
extern fn lexbor_array_obj_length_noi(array: ?*ArrayObj) usize;
extern fn lexbor_array_obj_size_noi(array: ?*ArrayObj) usize;
extern fn lexbor_array_obj_struct_size_noi(array: ?*ArrayObj) usize;
extern fn lexbor_array_obj_last_noi(array: ?*ArrayObj) ?*anyopaque;

pub inline fn arrayObjErase(array: ?*ArrayObj) void {
    _ = memset(array.?, 0, @sizeOf(ArrayObj));
}

pub inline fn arrayObjGet(array: ?*ArrayObj, idx: usize) ?*anyopaque {
    if (idx >= array.?.length) {
        return null;
    }
    return array.?.list.? + (idx * array.?.struct_size);
}

pub inline fn arrayObjLength(array: ?*ArrayObj) void {
    return array.?.length;
}

pub inline fn arrayObjSize(array: ?*ArrayObj) void {
    return array.?.size;
}

pub inline fn arrayObjStructSize(array: ?*ArrayObj) void {
    return array.?.struct_size;
}

pub inline fn arrayObjLast(array: ?*ArrayObj) ?*anyopaque {
    if (array.?.length == 0) {
        return null;
    }
    return array.?.list + ((array.?.length - 1) * array.?.struct_size);
}

// core/avl.h

pub const avlNodeF = ?*const fn (avl: ?*Avl, root: ?*?*AvlNode, node: ?*AvlNode, ctx: ?*anyopaque) callconv(.C) status;

pub const AvlNode = extern struct {
    type: usize,
    height: c_short,
    value: ?*anyopaque,
    left: ?*AvlNode,
    right: ?*AvlNode,
    parent: ?*AvlNode,

    pub fn clean(self: ?*AvlNode) void {
        return lexbor_avl_node_clean(self);
    }
};

pub const Avl = extern struct {
    nodes: ?*Dobject,
    last_right: ?*AvlNode,

    pub fn create() ?*Avl {
        return lexbor_avl_create();
    }

    pub fn init(self: ?*Avl, chunk_len: usize, struct_size: usize) status {
        return lexbor_avl_init(self, chunk_len, struct_size);
    }

    pub fn clean(self: ?*Avl) void {
        lexbor_avl_clean(self);
    }

    pub fn destroy(self: ?*Avl, self_destroy: bool) ?*Avl {
        return lexbor_avl_destroy(self, self_destroy);
    }

    pub fn nodeMake(self: ?*Avl, @"type": usize, value: ?*anyopaque) ?*AvlNode {
        return lexbor_avl_node_make(self, @"type", value);
    }

    pub fn nodeDestroy(self: ?*Avl, node: ?*AvlNode, self_destroy: bool) ?*AvlNode {
        return lexbor_avl_node_destroy(self, node, self_destroy);
    }

    pub fn insert(self: ?*Avl, scope: ?*?*AvlNode, @"type": usize, value: ?*anyopaque) ?*AvlNode {
        return lexbor_avl_insert(self, scope, @"type", value);
    }

    pub fn search(self: ?*Avl, scope: ?*AvlNode, @"type": usize) ?*AvlNode {
        return lexbor_avl_search(self, scope, @"type");
    }

    pub fn remove(self: ?*Avl, scope: ?*?*AvlNode, @"type": usize) ?*anyopaque {
        return lexbor_avl_remove(self, scope, @"type");
    }

    pub fn removeByNode(self: ?*Avl, root: ?*?*AvlNode, node: ?*AvlNode) void {
        lexbor_avl_remove_by_node(self, root, node);
    }

    pub fn foreach(self: ?*Avl, scope: ?*?*AvlNode, cb: avlNodeF, ctx: ?*anyopaque) status {
        return lexbor_avl_foreach(self, scope, cb, ctx);
    }

    pub fn foreachRecursion(self: ?*Avl, scope: ?*AvlNode, callback: avlNodeF, ctx: ?*anyopaque) void {
        lexbor_avl_foreach_recursion(self, scope, callback, ctx);
    }
};

extern fn lexbor_avl_create() ?*Avl;
extern fn lexbor_avl_init(avl: ?*Avl, chunk_len: usize, struct_size: usize) status;
extern fn lexbor_avl_clean(avl: ?*Avl) void;
extern fn lexbor_avl_destroy(avl: ?*Avl, struct_destroy: bool) ?*Avl;
extern fn lexbor_avl_node_make(avl: ?*Avl, type: usize, value: ?*anyopaque) ?*AvlNode;
extern fn lexbor_avl_node_clean(node: ?*AvlNode) void;
extern fn lexbor_avl_node_destroy(avl: ?*Avl, node: ?*AvlNode, self_destroy: bool) ?*AvlNode;
extern fn lexbor_avl_insert(avl: ?*Avl, scope: ?*?*AvlNode, type: usize, value: ?*anyopaque) ?*AvlNode;
extern fn lexbor_avl_search(avl: ?*Avl, scope: ?*AvlNode, type: usize) ?*AvlNode;
extern fn lexbor_avl_remove(avl: ?*Avl, scope: ?*?*AvlNode, type: usize) ?*anyopaque;
extern fn lexbor_avl_remove_by_node(avl: ?*Avl, root: ?*?*AvlNode, node: ?*AvlNode) void;
extern fn lexbor_avl_foreach(avl: ?*Avl, scope: ?*?*AvlNode, cb: avlNodeF, ctx: ?*anyopaque) status;
extern fn lexbor_avl_foreach_recursion(avl: ?*Avl, scope: ?*AvlNode, callback: avlNodeF, ctx: ?*anyopaque) void;

// core/base.h

pub const Version = struct {
    pub const major = 1;
    pub const minor = 8;
    pub const patch = 0;
    pub const string = "1.8.0";
};

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

pub const serializeCbF = ?*const fn (data: ?*const char, len: usize, ctx: ?*anyopaque) callconv(.C) status;
pub const serializeCbCpF = ?*const fn (cps: ?*const codepoint, len: usize, ctx: ?*anyopaque) callconv(.C) status;

pub const SerializeCtx = extern struct {
    c: serializeCbF,
    ctx: ?*anyopaque,
    opt: isize,
    count: usize,
};

// core/bst.h

pub inline fn bstRoot(bst: ?*Bst) ?*BstEntry {
    return bst.?.root;
}

pub inline fn bstRootRef(bst: ?*Bst) ?*?*BstEntry {
    return &(bst.?.root);
}

pub const BstEntryF = ?*const fn (bst: ?*Bst, entry: ?*BstEntry, ctx: ?*anyopaque) callconv(.C) bool;

pub const BstEntry = extern struct {
    value: ?*anyopaque,
    right: ?*BstEntry,
    left: ?*BstEntry,
    next: ?*BstEntry,
    parent: ?*BstEntry,
    size: usize,

    pub fn serializeEntry(self: ?*BstEntry, callback: callbackF, ctx: ?*anyopaque, tabs: usize) void {
        return lexbor_bst_serialize(self, callback, ctx, tabs);
    }
};

pub const Bst = extern struct {
    dobject: ?*Dobject,
    root: ?*BstEntry,
    tree_length: usize,

    pub fn create() ?*Bst {
        return lexbor_bst_create();
    }

    pub fn init(self: ?*Bst, size: usize) status {
        return lexbor_bst_init(self, size);
    }

    pub fn clean(self: ?*Bst) void {
        lexbor_bst_clean(self);
    }

    pub fn destroy(self: ?*Bst, self_destroy: bool) ?*Bst {
        return lexbor_bst_destroy(self, self_destroy);
    }

    pub fn entryMake(self: ?*Bst, size: usize) ?*BstEntry {
        return lexbor_bst_entry_make(self, size);
    }

    pub fn insert(self: ?*Bst, scope: ?*?*BstEntry, size: usize, value: ?*anyopaque) ?*BstEntry {
        return lexbor_bst_insert(self, scope, size, value);
    }

    pub fn insertNotExists(self: ?*Bst, scope: ?*?*BstEntry, size: usize) ?*BstEntry {
        return lexbor_bst_insert_not_exists(self, scope, size);
    }

    pub fn search(self: ?*Bst, scope: ?*BstEntry, size: usize) ?*BstEntry {
        return lexbor_bst_search(self, scope, size);
    }

    pub fn searchClose(self: ?*Bst, scope: ?*BstEntry, size: usize) ?*BstEntry {
        return lexbor_bst_search_close(self, scope, size);
    }

    pub fn remove(self: ?*Bst, root: ?*?*BstEntry, size: usize) ?*anyopaque {
        return lexbor_bst_remove(self, root, size);
    }

    pub fn removeClose(self: ?*Bst, root: ?*?*BstEntry, size: usize, found_size: ?*usize) ?*anyopaque {
        return lexbor_bst_remove_close(self, root, size, found_size);
    }

    pub fn removeByPointer(self: ?*Bst, entry: ?*BstEntry, root: ?*?*BstEntry) ?*anyopaque {
        return lexbor_bst_remove_by_pointer(self, entry, root);
    }

    pub fn serialize(self: ?*Bst, callback: callbackF, ctx: ?*anyopaque) void {
        return lexbor_bst_serialize(self, callback, ctx);
    }
};

extern fn lexbor_bst_create() ?*Bst;
extern fn lexbor_bst_init(bst: ?*Bst, size: usize) status;
extern fn lexbor_bst_clean(bst: ?*Bst) void;
extern fn lexbor_bst_destroy(bst: ?*Bst, self_destroy: bool) ?*Bst;
extern fn lexbor_bst_entry_make(bst: ?*Bst, size: usize) ?*BstEntry;
extern fn lexbor_bst_insert(bst: ?*Bst, scope: ?*?*BstEntry, size: usize, value: ?*anyopaque) ?*BstEntry;
extern fn lexbor_bst_insert_not_exists(bst: ?*Bst, scope: ?*?*BstEntry, size: usize) ?*BstEntry;
extern fn lexbor_bst_search(bst: ?*Bst, scope: ?*BstEntry, size: usize) ?*BstEntry;
extern fn lexbor_bst_search_close(bst: ?*Bst, scope: ?*BstEntry, size: usize) ?*BstEntry;
extern fn lexbor_bst_remove(bst: ?*Bst, root: ?*?*BstEntry, size: usize) ?*anyopaque;
extern fn lexbor_bst_remove_close(bst: ?*Bst, root: ?*?*BstEntry, size: usize, found_size: ?*usize) ?*anyopaque;
extern fn lexbor_bst_remove_by_pointer(bst: ?*Bst, entry: ?*BstEntry, root: ?*?*BstEntry) ?*anyopaque;
extern fn lexbor_bst_serialize(bst: ?*Bst, callback: callbackF, ctx: ?*anyopaque) void;
extern fn lexbor_bst_serialize_entry(entry: ?*BstEntry, callback: callbackF, ctx: ?*anyopaque, tabs: usize) void;

// core/bst_map.h

pub const BstMapEntry = extern struct {
    str: Str,
    value: ?*anyopaque,
};

pub const BstMap = extern struct {
    bst: ?*Bst,
    mraw: ?*Mraw,
    entries: ?*Dobject,

    pub fn create() ?*BstMap {
        return lexbor_bst_map_create();
    }

    pub fn init(self: ?*BstMap, size: usize) status {
        return lexbor_bst_map_init(self, size);
    }

    pub fn clean(self: ?*BstMap) void {
        return lexbor_bst_map_clean(self);
    }

    pub fn destroy(self: ?*BstMap, self_destroy: bool) ?*BstMap {
        return lexbor_bst_map_destroy(self, self_destroy);
    }

    pub fn search(self: ?*BstMap, scope: ?*BstEntry, key: ?*const char, key_len: usize) ?*BstMapEntry {
        return lexbor_bst_map_search(self, scope, key, key_len);
    }

    pub fn insert(self: ?*BstMap, scope: ?*?*BstEntry, key: ?*const char, key_len: usize, value: ?*anyopaque) ?*BstMapEntry {
        return lexbor_bst_map_insert(self, scope, key, key_len, value);
    }

    pub fn insertNotExists(self: ?*BstMap, scope: ?*?*BstEntry, key: ?*const char, key_len: usize) ?*BstMapEntry {
        return lexbor_bst_map_insert_not_exists(self, scope, key, key_len);
    }

    pub fn remove(self: ?*BstMap, scope: ?*?*BstEntry, key: ?*const char, key_len: usize) ?*anyopaque {
        return lexbor_bst_map_remove(self, scope, key, key_len);
    }
};

extern fn lexbor_bst_map_create() ?*BstMap;
extern fn lexbor_bst_map_init(bst_map: ?*BstMap, size: usize) status;
extern fn lexbor_bst_map_clean(bst_map: ?*BstMap) void;
extern fn lexbor_bst_map_destroy(bst_map: ?*BstMap, self_destroy: bool) ?*BstMap;
extern fn lexbor_bst_map_search(bst_map: ?*BstMap, scope: ?*BstEntry, key: ?*const char, key_len: usize) ?*BstMapEntry;
extern fn lexbor_bst_map_insert(bst_map: ?*BstMap, scope: ?*?*BstEntry, key: ?*const char, key_len: usize, value: ?*anyopaque) ?*BstMapEntry;
extern fn lexbor_bst_map_insert_not_exists(bst_map: ?*BstMap, scope: ?*?*BstEntry, key: ?*const char, key_len: usize) ?*BstMapEntry;
extern fn lexbor_bst_map_remove(bst_map: ?*BstMap, scope: ?*?*BstEntry, key: ?*const char, key_len: usize) ?*anyopaque;
extern fn lexbor_bst_map_mraw_noi(bst_map: ?*BstMap) ?*Mraw;

pub inline fn bstMapMraw(bst_map: ?*BstMap) ?*Mraw {
    return bst_map.?.mraw;
}

// core/conv.h

pub const Conv = struct {
    pub fn floatToData(num: f64, buf: ?*char, len: usize) usize {
        return lexbor_conv_float_to_data(num, buf, len);
    }

    pub fn longToData(num: c_long, buf: ?*char, len: usize) usize {
        return lexbor_conv_long_to_data(num, buf, len);
    }

    pub fn int64ToData(num: i64, buf: ?*char, len: usize) usize {
        return lexbor_conv_int64_to_data(num, buf, len);
    }

    pub fn dataToDouble(start: ?*const ?*char, len: usize) f64 {
        return lexbor_conv_data_to_double(start, len);
    }

    pub fn dataToUlong(data: ?*const ?*char, length: usize) c_ulong {
        return lexbor_conv_data_to_ulong(data, length);
    }

    pub fn dataToLong(data: ?*const ?*char, length: usize) c_long {
        return lexbor_conv_data_to_long(data, length);
    }

    pub fn dataToUint(data: ?*const ?*char, length: usize) c_uint {
        return lexbor_conv_data_to_uint(data, length);
    }

    pub fn decToHex(number: u32, out: ?*char, length: usize) usize {
        return lexbor_conv_dec_to_hex(number, out, length);
    }
};

extern fn lexbor_conv_float_to_data(num: f64, buf: ?*char, len: usize) usize;
extern fn lexbor_conv_long_to_data(num: c_long, buf: ?*char, len: usize) usize;
extern fn lexbor_conv_int64_to_data(num: i64, buf: ?*char, len: usize) usize;
extern fn lexbor_conv_data_to_double(start: ?*const ?*char, len: usize) f64;
extern fn lexbor_conv_data_to_ulong(data: ?*const ?*char, length: usize) c_ulong;
extern fn lexbor_conv_data_to_long(data: ?*const ?*char, length: usize) c_long;
extern fn lexbor_conv_data_to_uint(data: ?*const ?*char, length: usize) c_uint;
extern fn lexbor_conv_dec_to_hex(number: u32, out: ?*char, length: usize) usize;

pub inline fn convDoubleToLong(number: f64) c_long {
    if (number > std.math.maxInt(c_long)) {
        return std.math.maxInt(c_long);
    }
    if (number < std.math.minInt(c_long)) {
        return -std.math.maxInt(c_long);
    }
    return @trunc(number);
}

// core/def.h

pub const MEM_ALIGN_STEP = @sizeOf(*anyopaque);

// core/diyfp.h

pub inline fn uint64Hl(h: anytype, l: anytype) u64 {
    return @intCast((h << 32) + l);
}

pub const DBL_SIGNIFICAND_SIZE = 52;
pub const DBL_EXPONENT_BIAS = 0x3FF + DBL_SIGNIFICAND_SIZE;
pub const DBL_EXPONENT_MIN = -DBL_EXPONENT_BIAS;
pub const DBL_EXPONENT_MAX = 0x7FF - DBL_EXPONENT_BIAS;
pub const DBL_EXPONENT_DENORMAL = -DBL_EXPONENT_BIAS + 1;

pub const DBL_SIGNIFICAND_MASK = uint64Hl(0x000FFFFF, 0xFFFFFFFF);
pub const DBL_HIDDEN_BIT = uint64Hl(0x00100000, 0x00000000);
pub const DBL_EXPONENT_MASK = uint64Hl(0x7FF00000, 0x00000000);
pub const DIYFP_SIGNIFICAND_SIZE = 64;
pub const SIGNIFICAND_SIZE = 53;
pub const SIGNIFICAND_SHIFT = DIYFP_SIGNIFICAND_SIZE - DBL_SIGNIFICAND_SIZE;
pub const DECIMAL_EXPONENT_OFF = 348;
pub const DECIMAL_EXPONENT_MIN = -348;
pub const DECIMAL_EXPONENT_MAX = 340;
pub const DECIMAL_EXPONENT_DIST = 8;

pub const Diyfp = extern struct {
    significand: u64,
    exp: c_int,

    pub fn cachedPowerDec(exp: c_int, dec_exp: ?*c_int) Diyfp {
        return lexbor_cached_power_dec(exp, dec_exp);
    }

    pub fn cachedPowerBin(exp: c_int, dec_exp: ?*c_int) Diyfp {
        return lexbor_cached_power_bin(exp, dec_exp);
    }
};

extern fn lexbor_cached_power_dec(exp: c_int, dec_exp: ?*c_int) Diyfp;
extern fn lexbor_cached_power_bin(exp: c_int, dec_exp: ?*c_int) Diyfp;

pub inline fn diyfpLeadingZeros64(x: u64) u64 {
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

pub inline fn diyfpFromD2(d: u64) Diyfp {
    var biased_exp: c_int = undefined;
    var significand: u64 = undefined;
    var r: Diyfp = undefined;

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

pub inline fn diyfp2d(v: Diyfp) f64 {
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

pub inline fn diyfpShiftLeft(v: Diyfp, shift: c_uint) Diyfp {
    return Diyfp{ .significand = v.significand << shift, .exp = v.exp - shift };
}

pub inline fn diyfpShiftRight(v: Diyfp, shift: c_uint) Diyfp {
    return Diyfp{ .significand = v.significand >> shift, .exp = v.exp + shift };
}

pub inline fn diyfpSub(lhs: Diyfp, rhs: Diyfp) Diyfp {
    return Diyfp{ .significand = lhs.significand - rhs.significand, .exp = lhs.exp };
}

pub inline fn diyfpMul(lhs: Diyfp, rhs: Diyfp) Diyfp {
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

    return Diyfp{ .significand = ac + (ad >> 32) + (bc >> 32) + (tmp >> 32), .exp = lhs.exp + rhs.exp + 64 };
}

pub inline fn diyfpNormalize(v: Diyfp) Diyfp {
    return diyfpShiftLeft(v, diyfpLeadingZeros64(v.significand));
}

// core/dobject.h

pub const Dobject = extern struct {
    mem: ?*Mem,
    cache: ?*Array,
    allocated: usize,
    struct_size: usize,

    pub fn create() ?*Dobject {
        return lexbor_dobject_create();
    }

    pub fn init(self: ?*Dobject, chunk_size: usize, struct_size: usize) status {
        return lexbor_dobject_init(self, chunk_size, struct_size);
    }

    pub fn clean(self: ?*Dobject) void {
        return lexbor_dobject_clean(self);
    }

    pub fn destroy(self: ?*Dobject, destroy_self: bool) ?*Dobject {
        return lexbor_dobject_destroy(self, destroy_self);
    }

    pub fn initListEntries(self: ?*Dobject, pos: usize) ?*u8 {
        return lexbor_dobject_init(self, pos);
    }

    pub fn alloc(self: ?*Dobject) ?*anyopaque {
        return lexbor_dobject_alloc(self);
    }

    pub fn calloc(self: ?*Dobject) ?*anyopaque {
        return lexbor_dobject_calloc(self);
    }

    pub fn free(self: ?*Dobject, data: ?*anyopaque) ?*anyopaque {
        return lexbor_dobject_free(self, data);
    }

    pub fn byAbsolutePosition(self: ?*Dobject, pos: usize) ?*anyopaque {
        return lexbor_dobject_by_absolute_position(self, pos);
    }

    pub fn allocatedNoi(self: ?*Dobject) usize {
        return lexbor_dobject_allocated_noi(self);
    }

    pub fn cacheLengthNoi(self: ?*Dobject) usize {
        return lexbor_dobject_cache_length_noi(self);
    }
};

extern fn lexbor_dobject_create() ?*Dobject;
extern fn lexbor_dobject_init(Dobject: ?*Dobject, chunk_size: usize, struct_size: usize) status;
extern fn lexbor_dobject_clean(Dobject: ?*Dobject) void;
extern fn lexbor_dobject_destroy(Dobject: ?*Dobject, destroy_self: bool) ?*Dobject;
extern fn lexbor_dobject_init_list_entries(Dobject: ?*Dobject, pos: usize) ?*u8;
extern fn lexbor_dobject_alloc(Dobject: ?*Dobject) ?*anyopaque;
extern fn lexbor_dobject_calloc(Dobject: ?*Dobject) ?*anyopaque;
extern fn lexbor_dobject_free(Dobject: ?*Dobject, data: ?*anyopaque) ?*anyopaque;
extern fn lexbor_dobject_by_absolute_position(Dobject: ?*Dobject, pos: usize) ?*anyopaque;
extern fn lexbor_dobject_allocated_noi(Dobject: ?*Dobject) usize;
extern fn lexbor_dobject_cache_length_noi(Dobject: ?*Dobject) usize;

pub inline fn dobjectAllocated(dobject: ?*Dobject) usize {
    return dobject.?.allocated;
}

pub inline fn dobjectCacheLength(dobject: ?*Dobject) usize {
    return arrayLength(dobject.?.cache);
}

// core/dtoa.h

pub fn dtoa(value: f64, begin: ?*char, len: usize) usize {
    return lexbor_dtoa(value, begin, len);
}

extern fn lexbor_dtoa(value: f64, begin: ?*char, len: usize) usize;

// core/fs.h

pub const fsDirFileF = ?*const fn (fullpath: ?*const char, fullpath_len: usize, filename: ?*const char, filename_len: usize, ctx: ?*anyopaque) callconv(.C) Action;

pub const FsDirOpt = enum(c_int) {
    undef = 0x00,
    without_dir = 0x01,
    without_file = 0x02,
    without_hidden = 0x04,
};

pub const FsFileType = enum(c_int) {
    undef = 0x00,
    file = 0x01,
    directory = 0x02,
    block_device = 0x03,
    character_device = 0x04,
    pipe = 0x05,
    symlink = 0x06,
    socket = 0x07,
};

pub const FsDir = extern struct {
    pub fn read(dirpath: ?*const char, opt: c_int, callback: fsDirFileF, ctx: ?*anyopaque) status {
        return lexbor_fs_dir_read(dirpath, opt, callback, ctx);
    }
};

pub const FsFile = extern struct {
    pub fn @"type"(full_path: ?*const char) FsFileType {
        return lexbor_fs_file_type(full_path);
    }

    pub fn easyRead(full_path: ?*const char, len: ?*usize) ?*char {
        return lexbor_fs_file_easy_read(full_path, len);
    }
};

extern fn lexbor_fs_dir_read(dirpath: ?*const char, opt: c_int, callback: fsDirFileF, ctx: ?*anyopaque) status;
extern fn lexbor_fs_file_type(full_path: ?*const char) FsFileType;
extern fn lexbor_fs_file_easy_read(full_path: ?*const char, len: ?*usize) ?*char;

// core/hash.h

pub const HASH_SHORT_SIZE = 16;
pub const HASH_TABLE_MIN_SIZE = 32;

pub const hashInsertRaw = @extern(**const HashInsert, .{ .name = "lexbor_hash_insert_raw" });
pub const hashInsertLower = @extern(**const HashInsert, .{ .name = "lexbor_hash_insert_lower" });
pub const hashInsertUpper = @extern(**const HashInsert, .{ .name = "lexbor_hash_insert_upper" });

pub const hashSearchRaw = @extern(**const HashSearch, .{ .name = "lexbor_hash_search_raw" });
pub const hashSearchLower = @extern(**const HashSearch, .{ .name = "lexbor_hash_search_lower" });
pub const hashSearchUpper = @extern(**const HashSearch, .{ .name = "lexbor_hash_search_upper" });

pub const hashIdF = ?*const fn (key: ?*const char, len: usize) callconv(.C) u32;
pub const hashCopyF = ?*const fn (hash: ?*Hash, entry: ?*HashEntry, key: ?*const char, len: usize) callconv(.C) status;
pub const hashCmpF = ?*const fn (first: ?*const char, second: ?*const char, size: usize) callconv(.C) bool;

pub const HashEntry = extern struct {
    u: extern union {
        long_str: ?*char,
        short_str: [HASH_SHORT_SIZE + 1]char,
    },
    length: usize,
    next: ?*HashEntry,
};

pub const HashInsert = extern struct {
    hash: hashIdF,
    cmp: hashCmpF,
    copy: hashCopyF,
};

pub const HashSearch = extern struct {
    hash: hashIdF,
    cmp: hashCmpF,
};

pub const Hash = extern struct {
    entries: ?*Dobject,
    mraw: ?*Mraw,
    table: ?*?*HashEntry,
    table_size: usize,
    struct_size: usize,

    pub fn create() ?*Hash {
        return lexbor_hash_create();
    }

    pub fn init(self: ?*Hash, table_size: usize, struct_size: usize) status {
        return lexbor_hash_init(self, table_size, struct_size);
    }

    pub fn clean(self: ?*Hash) void {
        lexbor_hash_clean(self);
    }

    pub fn destroy(self: ?*Hash, destroy_obj: bool) ?*Hash {
        return lexbor_hash_destroy(self, destroy_obj);
    }

    pub fn insert(self: ?*Hash, insert_: ?*const HashInsert, key: ?*const char, length: usize) ?*anyopaque {
        return lexbor_hash_insert(self, insert_, key, length);
    }

    pub fn insertByEntry(self: ?*Hash, entry: ?*HashEntry, search_: ?*const HashSearch, key: ?*const char, length: usize) ?*anyopaque {
        return lexbor_hash_insert_by_entry(self, entry, search_, key, length);
    }

    pub fn remove(self: ?*Hash, search_: ?*const HashSearch, key: ?*const char, length: usize) void {
        lexbor_hash_remove(self, search_, key, length);
    }

    pub fn search(self: ?*Hash, search_: ?*const HashSearch, key: ?*const char, length: usize) ?*anyopaque {
        return lexbor_hash_search(self, search_, key, length);
    }

    pub fn removeByHashId(self: ?*Hash, hash_id: u32, key: ?*const char, length: usize, cmp_func: hashCmpF) void {
        return lexbor_hash_remove_by_hash_id(self, hash_id, key, length, cmp_func);
    }

    pub fn searchByHashId(self: ?*Hash, hash_id: u32, key: ?*const char, length: usize, cmp_func: hashCmpF) ?*anyopaque {
        return lexbor_hash_search_by_hash_id(self, hash_id, key, length, cmp_func);
    }

    pub fn makeId(key: ?*const char, length: usize) u32 {
        return lexbor_hash_make_id(key, length);
    }

    pub fn makeIdLower(key: ?*const char, length: usize) u32 {
        return lexbor_hash_make_id_lower(key, length);
    }

    pub fn makeIdUpper(key: ?*const char, length: usize) u32 {
        return lexbor_hash_make_id_upper(key, length);
    }

    pub fn copy(self: ?*Hash, entry: ?*HashEntry, key: ?*const char, length: usize) status {
        return lexbor_hash_copy(self, entry, key, length);
    }

    pub fn copyLower(self: ?*Hash, entry: ?*HashEntry, key: ?*const char, length: usize) status {
        return lexbor_hash_copy_lower(self, entry, key, length);
    }

    pub fn copyUpper(self: ?*Hash, entry: ?*HashEntry, key: ?*const char, length: usize) status {
        return lexbor_hash_copy_upper(self, entry, key, length);
    }
};

extern fn lexbor_hash_create() ?*Hash;
extern fn lexbor_hash_init(hash: ?*Hash, table_size: usize, struct_size: usize) status;
extern fn lexbor_hash_clean(hash: ?*Hash) void;
extern fn lexbor_hash_destroy(hash: ?*Hash, destroy_obj: bool) ?*Hash;
extern fn lexbor_hash_insert(hash: ?*Hash, insert: ?*const HashInsert, key: ?*const char, length: usize) ?*anyopaque;
extern fn lexbor_hash_insert_by_entry(hash: ?*Hash, entry: ?*HashEntry, search: ?*const HashSearch, key: ?*const char, length: usize) ?*anyopaque;
extern fn lexbor_hash_remove(hash: ?*Hash, search: ?*const HashSearch, key: ?*const char, length: usize) void;
extern fn lexbor_hash_search(hash: ?*Hash, search: ?*const HashSearch, key: ?*const char, length: usize) ?*anyopaque;
extern fn lexbor_hash_remove_by_hash_id(hash: ?*Hash, hash_id: u32, key: ?*const char, length: usize, cmp_func: hashCmpF) void;
extern fn lexbor_hash_search_by_hash_id(hash: ?*Hash, hash_id: u32, key: ?*const char, length: usize, cmp_func: hashCmpF) ?*anyopaque;
extern fn lexbor_hash_make_id(key: ?*const char, length: usize) u32;
extern fn lexbor_hash_make_id_lower(key: ?*const char, length: usize) u32;
extern fn lexbor_hash_make_id_upper(key: ?*const char, length: usize) u32;
extern fn lexbor_hash_copy(hash: ?*Hash, entry: ?*HashEntry, key: ?*const char, length: usize) status;
extern fn lexbor_hash_copy_lower(hash: ?*Hash, entry: ?*HashEntry, key: ?*const char, length: usize) status;
extern fn lexbor_hash_copy_upper(hash: ?*Hash, entry: ?*HashEntry, key: ?*const char, length: usize) status;

pub inline fn hashEntryStr(entry: ?*HashEntry) ?*char {
    if (entry.?.length <= HASH_SHORT_SIZE) {
        return entry.?.u.short_str;
    }
    return entry.?.u.long_str;
}

pub inline fn hashEntryStrSet(entry: ?*HashEntry, data: ?*char, length: usize) ?*char {
    entry.?.length = length;

    if (length <= HASH_SHORT_SIZE) {
        _ = memcpy(entry.?.u.short_str, data, length);
        return entry.?.u.short_str;
    }

    entry.?.u.long_str = data;
    return entry.?.u.long_str;
}

pub inline fn hashEntryStrFree(hash: ?*Hash, entry: ?*HashEntry) void {
    if (entry.?.length > HASH_SHORT_SIZE) {
        lexbor_mraw_free(hash.?.mraw, entry.?.u.long_str);
    }

    entry.?.length = 0;
}

pub inline fn hashEntryCreate(hash: ?*Hash) ?*HashEntry {
    return @as(?*HashEntry, @ptrCast(@alignCast(lexbor_dobject_calloc(hash.?.entries))));
}

pub inline fn hashEntryDestroy(hash: ?*Hash, entry: ?*HashEntry) ?*HashEntry {
    return @as(?*HashEntry, @ptrCast(@alignCast(lexbor_dobject_free(hash.?.entries, @as(?*anyopaque, @ptrCast(entry))))));
}

pub inline fn hashEntriesCount(hash: ?*Hash) usize {
    return dobjectAllocated(hash.?.entries);
}

// core/in.h

pub const InOpt = enum(c_int) {
    undef = 0x00,
    readonly = 0x01,
    done = 0x02,
    fake = 0x04,
    alloc = 0x08,
};

pub const In = extern struct {
    nodes: ?*Dobject,

    pub fn create() ?*In {
        return lexbor_in_create();
    }

    pub fn init(self: ?*In, chunk_size: usize) status {
        return lexbor_in_init(self, chunk_size);
    }

    pub fn clean(self: ?*In) void {
        return lexbor_in_clean(self);
    }

    pub fn destroy(self: ?*In, self_destroy: bool) ?*In {
        return lexbor_in_destroy(self, self_destroy);
    }

    pub fn nodeMake(self: ?*In, last_node: ?*InNode, buf: ?*const char, buf_size: usize) ?*InNode {
        return lexbor_in_node_make(self, last_node, buf, buf_size);
    }

    pub fn nodeDestroy(self: ?*In, node: ?*InNode, self_destroy: bool) ?*InNode {
        return lexbor_in_node_destroy(self, node, self_destroy);
    }
};

pub const InNode = extern struct {
    offset: usize,
    opt: InOpt,
    begin: ?[*]const char,
    end: ?[*]const char,
    use: ?[*]const char,
    next: ?*InNode,
    prev: ?*InNode,
    incoming: ?*In,

    pub fn clean(self: ?*InNode) void {
        return lexbor_in_node_clean(self);
    }

    pub fn split(self: ?*InNode, pos: ?*const char) ?*InNode {
        return lexbor_in_node_split(self, pos);
    }

    pub fn find(self: ?*InNode, pos: ?*const char) ?*InNode {
        return lexbor_in_node_find(self, pos);
    }

    pub fn posUp(self: ?*InNode, return_node: ?*?*InNode, pos: ?*const char, offset: usize) ?*const char {
        return lexbor_in_node_pos_up(self, return_node, pos, offset);
    }

    pub fn posDown(self: ?*InNode, return_node: ?*?*InNode, pos: ?*const char, offset: usize) ?*const char {
        return lexbor_in_node_pos_down(self, return_node, pos, offset);
    }
};

extern fn lexbor_in_create() ?*In;
extern fn lexbor_in_init(incoming: ?*In, chunk_size: usize) status;
extern fn lexbor_in_clean(incoming: ?*In) void;
extern fn lexbor_in_destroy(incoming: ?*In, self_destroy: bool) ?*In;
extern fn lexbor_in_node_make(incoming: ?*In, last_node: ?*InNode, buf: ?*const char, buf_size: usize) ?*InNode;
extern fn lexbor_in_node_clean(node: ?*InNode) void;
extern fn lexbor_in_node_destroy(incoming: ?*In, node: ?*InNode, self_destroy: bool) ?*InNode;
extern fn lexbor_in_node_split(node: ?*InNode, pos: ?*const char) ?*InNode;
extern fn lexbor_in_node_find(node: ?*InNode, pos: ?*const char) ?*InNode;
extern fn lexbor_in_node_pos_up(node: ?*InNode, return_node: ?*?*InNode, pos: ?*const char, offset: usize) ?*const char;
extern fn lexbor_in_node_pos_down(node: ?*InNode, return_node: ?*?*InNode, pos: ?*const char, offset: usize) ?*const char;
extern fn lexbor_in_node_begin_noi(node: ?*const InNode) ?*const char;
extern fn lexbor_in_node_end_noi(node: ?*const InNode) ?*const char;
extern fn lexbor_in_node_offset_noi(node: ?*const InNode) usize;
extern fn lexbor_in_node_next_noi(node: ?*const InNode) ?*InNode;
extern fn lexbor_in_node_prev_noi(node: ?*const InNode) ?*InNode;
extern fn lexbor_in_node_in_noi(node: ?*const InNode) ?*In;
extern fn lexbor_in_segment_noi(node: ?*const InNode, data: ?*const char) bool;

pub inline fn inNodeBegin(node: ?*const InNode) ?[*]const char {
    return node.?.begin;
}

pub inline fn inNodeEnd(node: ?*const InNode) ?[*]const char {
    return node.?.end;
}

pub inline fn inNodeOffset(node: ?*const InNode) usize {
    return node.?.offset;
}

pub inline fn inNodeNext(node: ?*const InNode) ?*InNode {
    return node.?.next;
}

pub inline fn inNodePrev(node: ?*const InNode) ?*InNode {
    return node.?.prev;
}

pub inline fn inNodeIn(node: ?*const InNode) ?*In {
    return node.?.incoming;
}

pub inline fn inSegment(node: ?*const InNode, data: ?*const char) bool {
    return @intFromPtr(&node.?.begin.?[0]) <= @intFromPtr(&data[0]) and @intFromPtr(&node.?.end.?[0]) >= @intFromPtr(&data[0]);
}

// core/mem.h

pub const MemChunk = extern struct {
    data: ?*u8,
    length: usize,
    size: usize,
    next: ?*MemChunk,
    prev: ?*MemChunk,
};

pub const Mem = extern struct {
    chunk: ?*MemChunk,
    chunk_first: ?*MemChunk,
    chunk_min_size: usize,
    chunk_length: usize,

    pub fn create() ?*Mem {
        return lexbor_mem_create();
    }

    pub fn init(self: ?*Mem, min_chunk_size: usize) status {
        return lexbor_mem_init(self, min_chunk_size);
    }

    pub fn clean(self: ?*Mem) void {
        return lexbor_mem_clean(self);
    }

    pub fn destroy(self: ?*Mem, destroy_self: bool) ?*Mem {
        return lexbor_mem_destroy(self, destroy_self);
    }

    pub fn chunkInit(self: ?*Mem, chunk: ?*MemChunk, length: usize) ?*u8 {
        return lexbor_mem_chunk_init(self, chunk, length);
    }

    pub fn chunkMake(self: ?*Mem, length: usize) ?*MemChunk {
        return lexbor_mem_chunk_make(self, length);
    }

    pub fn chunkDestroy(self: ?*Mem, chunk: ?*MemChunk, self_destroy: bool) ?*MemChunk {
        return lexbor_mem_chunk_destroy(self, chunk, self_destroy);
    }

    pub fn alloc(self: ?*Mem, length: usize) ?*anyopaque {
        return lexbor_mem_alloc(self, length);
    }

    pub fn calloc(self: ?*Mem, length: usize) ?*anyopaque {
        return lexbor_mem_calloc(self, length);
    }
};

extern fn lexbor_mem_create() ?*Mem;
extern fn lexbor_mem_init(mem: ?*Mem, min_chunk_size: usize) status;
extern fn lexbor_mem_clean(mem: ?*Mem) void;
extern fn lexbor_mem_destroy(mem: ?*Mem, destroy_self: bool) ?*Mem;
extern fn lexbor_mem_chunk_init(mem: ?*Mem, chunk: ?*MemChunk, length: usize) ?*u8;
extern fn lexbor_mem_chunk_make(mem: ?*Mem, length: usize) ?*MemChunk;
extern fn lexbor_mem_chunk_destroy(mem: ?*Mem, chunk: ?*MemChunk, self_destroy: bool) ?*MemChunk;
extern fn lexbor_mem_alloc(mem: ?*Mem, length: usize) ?*anyopaque;
extern fn lexbor_mem_calloc(mem: ?*Mem, length: usize) ?*anyopaque;
extern fn lexbor_mem_current_length_noi(mem: ?*Mem) usize;
extern fn lexbor_mem_current_size_noi(mem: ?*Mem) usize;
extern fn lexbor_mem_chunk_length_noi(mem: ?*Mem) usize;
extern fn lexbor_mem_align_noi(size: usize) usize;
extern fn lexbor_mem_align_floor_noi(size: usize) usize;

pub inline fn memCurrentLength(mem: ?*Mem) usize {
    return mem.?.chunk.?.length;
}

pub inline fn memCurrentSize(mem: ?*Mem) usize {
    return mem.?.chunk.?.size;
}

pub inline fn memChunkLength(mem: ?*Mem) usize {
    return mem.?.chunk_length;
}

pub inline fn memAlign(size: usize) usize {
    return if ((size % MEM_ALIGN_STEP) != 0) size + (MEM_ALIGN_STEP - (size % MEM_ALIGN_STEP)) else size;
}

pub inline fn memAlignFloor(size: usize) usize {
    return if ((size % MEM_ALIGN_STEP) != 0) size - (size % MEM_ALIGN_STEP) else size;
}

// core/lexbor.h

pub const memoryMallocF = ?*const fn (size: usize) callconv(.C) ?*anyopaque;
pub const memoryReallocF = ?*const fn (dst: ?*anyopaque, size: usize) callconv(.C) ?*anyopaque;
pub const memoryCallocF = ?*const fn (num: usize, size: usize) callconv(.C) ?*anyopaque;
pub const memoryFreeF = ?*const fn (dst: ?*anyopaque) callconv(.C) void;

pub const Memory = struct {
    pub fn malloc(size: usize) ?*anyopaque {
        return lexbor_malloc(size);
    }

    pub fn realloc(dst: ?*anyopaque, size: usize) ?*anyopaque {
        return lexbor_realloc(dst, size);
    }

    pub fn calloc(num: usize, size: usize) ?*anyopaque {
        return lexbor_calloc(num, size);
    }

    pub fn free(dst: ?*anyopaque) void {
        lexbor_free(dst);
    }

    pub fn setup(new_malloc: memoryMallocF, new_realloc: memoryReallocF, new_calloc: memoryCallocF, new_free: memoryFreeF) void {
        lexbor_memory_setup(new_malloc, new_realloc, new_calloc, new_free);
    }
};

extern fn lexbor_malloc(size: usize) ?*anyopaque;
extern fn lexbor_realloc(dst: *anyopaque, size: usize) ?*anyopaque;
extern fn lexbor_calloc(num: usize, size: usize) ?*anyopaque;
extern fn lexbor_free(dst: ?*anyopaque) void;
extern fn lexbor_memory_setup(new_malloc: memoryMallocF, new_realloc: memoryReallocF, new_calloc: memoryCallocF, new_free: memoryFreeF) void;

// core/mem.h

// core/types.h

pub const codepoint = u32;
pub const char = u8;
pub const status = c_uint;

pub const callbackF = ?*const fn (buffer: ?*char, size: usize, ctx: ?*anyopaque) callconv(.C) status;

// core/mraw.h

pub const Mraw = extern struct {
    mem: ?*Mem,
    cache: ?*Bst,
    ref_count: usize,
};

extern fn lexbor_mraw_free(mraw: ?*Mraw, data: ?*anyopaque) ?*anyopaque;

// core/str.h

pub const Str = extern struct {
    data: ?[*]char,
    length: usize,
};
