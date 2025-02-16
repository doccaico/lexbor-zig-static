const std = @import("std");
const expect = std.testing.expect;
const expectEqual = std.testing.expectEqual;
const zeroInit = std.mem.zeroInit;

const lb = @import("lexbor");

test "init" {
    var mraw = lb.core.Mraw.create().?;
    const status = mraw.init(1024);

    try expectEqual(status, @intFromEnum(lb.core.Status.ok));

    _ = mraw.destroy(true);
}

test "init_null" {
    const status = lb.core.Mraw.init(null, 1024);
    try expectEqual(status, @intFromEnum(lb.core.Status.error_object_is_null));
}

test "init_stack" {
    var mraw: lb.core.Mraw = undefined;
    const status = mraw.init(1024);

    try expectEqual(status, @intFromEnum(lb.core.Status.ok));

    _ = mraw.destroy(false);
}

test "init_args" {
    var mraw = zeroInit(lb.core.Mraw, .{});
    var status: lb.core.status = undefined;

    status = mraw.init(0);
    try expectEqual(status, @intFromEnum(lb.core.Status.error_wrong_args));

    _ = mraw.destroy(false);
}

test "mraw_alloc" {
    var mraw = zeroInit(lb.core.Mraw, .{});
    _ = mraw.init(1024);

    const data = mraw.alloc(127);
    try expect(data != null);

    try expectEqual(lb.core.mrawDataSize(data), lb.core.memAlign(127));

    try expectEqual(mraw.mem.?.chunk_length, 1);
    try expectEqual(mraw.mem.?.chunk.?.length, lb.core.memAlign(127) + lb.core.mraw_meta_size);

    try expectEqual(mraw.mem.?.chunk.?.size, lb.core.memAlign(1024) + lb.core.mraw_meta_size);

    try expectEqual(mraw.cache.?.tree_length, 0);

    try expectEqual(mraw.mem.?.chunk, mraw.mem.?.chunk_first);

    _ = mraw.destroy(false);
}

test "mraw_alloc_eq" {
    var mraw = zeroInit(lb.core.Mraw, .{});
    _ = mraw.init(1024);

    const data = mraw.alloc(1024);
    try expect(data != null);

    try expectEqual(lb.core.mrawDataSize(data), 1024);

    try expectEqual(mraw.mem.?.chunk_length, 1);
    try expectEqual(mraw.mem.?.chunk.?.length, 1024 + lb.core.mraw_meta_size);
    try expectEqual(mraw.mem.?.chunk.?.size, 1024 + lb.core.mraw_meta_size);

    try expectEqual(mraw.cache.?.tree_length, 0);

    try expectEqual(mraw.mem.?.chunk, mraw.mem.?.chunk_first);

    _ = mraw.destroy(false);
}

test "mraw_alloc_overflow_if_len_0" {
    var mraw = zeroInit(lb.core.Mraw, .{});
    _ = mraw.init(1024);

    const data = mraw.alloc(1025);
    try expect(data != null);

    try expectEqual(lb.core.mrawDataSize(data), lb.core.memAlign(1025));

    try expectEqual(mraw.mem.?.chunk_length, 1);
    try expectEqual(mraw.mem.?.chunk.?.length, lb.core.memAlign(1025) + lb.core.mraw_meta_size);

    try expectEqual(mraw.mem.?.chunk.?.size, lb.core.memAlign(1025) + lb.core.memAlign(1024) + (2 * lb.core.mraw_meta_size));

    try expectEqual(mraw.cache.?.tree_length, 0);
    try expectEqual(mraw.mem.?.chunk, mraw.mem.?.chunk_first);

    _ = mraw.destroy(false);
}

test "mraw_alloc_overflow_if_len_not_0" {
    var mraw = zeroInit(lb.core.Mraw, .{});
    _ = mraw.init(1024);

    var data = mraw.alloc(13);
    try expect(data != null);
    try expectEqual(lb.core.mrawDataSize(data), lb.core.memAlign(13));

    data = mraw.alloc(1025);
    try expect(data != null);
    try expectEqual(lb.core.mrawDataSize(data), lb.core.memAlign(1025));

    try expectEqual(mraw.mem.?.chunk_first.?.length, 1024 + lb.core.mraw_meta_size);
    try expectEqual(mraw.mem.?.chunk_first.?.size, 1024 + lb.core.mraw_meta_size);

    try expectEqual(mraw.mem.?.chunk_length, 2);
    try expectEqual(mraw.mem.?.chunk.?.length, lb.core.memAlign(1025) + lb.core.mraw_meta_size);

    try expectEqual(mraw.mem.?.chunk.?.size, lb.core.memAlign(1025) + lb.core.memAlign(1024) + (2 * lb.core.mraw_meta_size));

    try expectEqual(mraw.cache.?.tree_length, 1);
    try expectEqual(mraw.cache.?.root.?.size, (lb.core.memAlign(1024) + lb.core.mraw_meta_size) - (lb.core.memAlign(13) + lb.core.mraw_meta_size) - lb.core.mraw_meta_size);

    try expect(mraw.mem.?.chunk != mraw.mem.?.chunk_first);

    _ = mraw.destroy(false);
}

test "mraw_alloc_if_len_not_0" {
    var mraw = zeroInit(lb.core.Mraw, .{});
    _ = mraw.init(1024);

    var data = mraw.alloc(8);
    try expect(data != null);
    try expectEqual(lb.core.mrawDataSize(data), lb.core.memAlign(8));

    data = mraw.alloc(1016 - lb.core.mraw_meta_size);
    try expect(data != null);
    try expectEqual(lb.core.mrawDataSize(data), 1016 - lb.core.mraw_meta_size);

    try expectEqual(mraw.mem.?.chunk_length, 1);
    try expectEqual(mraw.mem.?.chunk.?.length, 1024 + lb.core.mraw_meta_size);
    try expectEqual(mraw.mem.?.chunk.?.size, mraw.mem.?.chunk.?.length);

    try expectEqual(mraw.cache.?.tree_length, 0);
    try expectEqual(mraw.mem.?.chunk, mraw.mem.?.chunk_first);

    _ = mraw.destroy(false);
}

test "mraw_realloc" {
    var mraw = zeroInit(lb.core.Mraw, .{});
    _ = mraw.init(1024);

    const data: ?*u8 = @ptrCast(mraw.alloc(128));
    try expect(data != null);
    try expectEqual(lb.core.mrawDataSize(data), 128);

    const new_data: ?*u8 = @ptrCast(mraw.realloc(data, 256));
    try expect(new_data != null);
    try expectEqual(lb.core.mrawDataSize(new_data), 256);

    try expectEqual(data, new_data);

    try expectEqual(mraw.mem.?.chunk_length, 1);
    try expectEqual(mraw.mem.?.chunk.?.length, 256 + lb.core.mraw_meta_size);
    try expectEqual(mraw.mem.?.chunk.?.size, 1024 + lb.core.mraw_meta_size);

    try expectEqual(mraw.cache.?.tree_length, 0);
    try expectEqual(mraw.mem.?.chunk, mraw.mem.?.chunk_first);

    _ = mraw.destroy(false);
}

test "mraw_realloc_eq" {
    var mraw = zeroInit(lb.core.Mraw, .{});
    _ = mraw.init(1024);

    const data: ?*u8 = @ptrCast(mraw.alloc(128));
    try expect(data != null);
    try expectEqual(lb.core.mrawDataSize(data), 128);

    const new_data: ?*u8 = @ptrCast(mraw.realloc(data, 128));
    try expect(new_data != null);
    try expectEqual(lb.core.mrawDataSize(new_data), 128);

    try expectEqual(data, new_data);

    try expectEqual(mraw.mem.?.chunk_length, 1);
    try expectEqual(mraw.mem.?.chunk.?.length, 128 + lb.core.mraw_meta_size);
    try expectEqual(mraw.mem.?.chunk.?.size, 1024 + lb.core.mraw_meta_size);

    try expectEqual(mraw.cache.?.tree_length, 0);
    try expectEqual(mraw.mem.?.chunk, mraw.mem.?.chunk_first);

    _ = mraw.destroy(false);
}

test "mraw_realloc_tail_0" {
    var mraw = zeroInit(lb.core.Mraw, .{});
    _ = mraw.init(1024);

    const data: ?*u8 = @ptrCast(mraw.alloc(128));
    try expect(data != null);
    try expectEqual(lb.core.mrawDataSize(data), 128);

    const new_data: ?*u8 = @ptrCast(mraw.realloc(data, 0));
    try expectEqual(new_data, null);

    try expectEqual(mraw.mem.?.chunk_length, 1);
    try expectEqual(mraw.mem.?.chunk.?.length, 0);
    try expectEqual(mraw.mem.?.chunk.?.size, 1024 + lb.core.mraw_meta_size);

    try expectEqual(mraw.cache.?.tree_length, 0);
    try expectEqual(mraw.mem.?.chunk, mraw.mem.?.chunk_first);

    _ = mraw.destroy(false);
}

test "mraw_realloc_tail_n" {
    var mraw = zeroInit(lb.core.Mraw, .{});
    _ = mraw.init(1024);

    var data: ?*u8 = @ptrCast(mraw.alloc(128));
    try expect(data != null);
    try expectEqual(lb.core.mrawDataSize(data), 128);

    data = @ptrCast(mraw.alloc(128));
    try expect(data != null);
    try expectEqual(lb.core.mrawDataSize(data), 128);

    const new_data: ?*u8 = @ptrCast(mraw.realloc(data, 1024));
    try expect(new_data != null);
    try expectEqual(lb.core.mrawDataSize(new_data), 1024);

    try expect(data != new_data);

    try expectEqual(mraw.mem.?.chunk_length, 2);
    try expectEqual(mraw.mem.?.chunk.?.length, 1024 + lb.core.mraw_meta_size);
    try expectEqual(mraw.mem.?.chunk.?.size, 1024 + lb.core.mraw_meta_size);

    try expectEqual(mraw.cache.?.tree_length, 1);
    try expectEqual(mraw.cache.?.root.?.size, (lb.core.memAlign(1024) + lb.core.mraw_meta_size) - (lb.core.memAlign(128) + lb.core.mraw_meta_size) - lb.core.mraw_meta_size);

    try expect(mraw.mem.?.chunk != mraw.mem.?.chunk_first);

    _ = mraw.destroy(false);
}
