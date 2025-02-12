//! By convention, root.zig is the root source file when making a library. If
//! you are making an executable, the convention is to delete this file and
//! start with main.zig instead.
const std = @import("std");
// const testing = std.testing;

// const lb = @import("lexbor");

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

pub const status = c_uint;

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

extern fn lexbor_malloc(size: usize) ?*anyopaque;
extern fn lexbor_realloc(dst: *anyopaque, size: usize) ?*anyopaque;
extern fn lexbor_calloc(num: usize, size: usize) ?*anyopaque;
extern fn lexbor_free(dst: ?*anyopaque) void;
