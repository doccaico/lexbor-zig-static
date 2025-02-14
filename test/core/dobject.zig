const std = @import("std");
const expect = std.testing.expect;
const expectEqual = std.testing.expectEqual;
const zeroInit = std.mem.zeroInit;
// const expectEqualStrings = std.testing.expectEqualStrings;

const lb = @import("lexbor");

pub const t = struct {
    a: usize,
    b: c_char,
    c: c_int,
};

test "init" {
    var dobj = lb.core.dobject.create().?;
    const status = dobj.init(128, @sizeOf(t));

    try expectEqual(status, @intFromEnum(lb.core.Status.ok));

    _ = dobj.destroy(true);
}

test "init_stack" {
    var dobj: lb.core.dobject = undefined;
    const status = dobj.init(128, @sizeOf(t));

    try expectEqual(status, @intFromEnum(lb.core.Status.ok));

    _ = dobj.destroy(false);
}

test "init_args" {
    var dobj = zeroInit(lb.core.dobject, .{});
    var status: lb.core.status = undefined;

    status = dobj.init(0, @sizeOf(t));
    try expectEqual(status, @intFromEnum(lb.core.Status.error_wrong_args));

    status = dobj.init(128, 0);
    try expectEqual(status, @intFromEnum(lb.core.Status.error_wrong_args));

    status = dobj.init(0, 0);
    try expectEqual(status, @intFromEnum(lb.core.Status.error_wrong_args));

    _ = dobj.destroy(false);
}

test "obj_alloc" {
    var dobj: lb.core.dobject = undefined;
    _ = dobj.init(128, @sizeOf(t));

    const data = dobj.alloc();

    try expect(data != null);
    try expectEqual(dobj.allocated, 1);

    _ = dobj.destroy(false);
}

test "obj_calloc" {
    var dobj: lb.core.dobject = undefined;
    _ = dobj.init(128, @sizeOf(t));

    const data = dobj.calloc();

    try expectEqual(@as(*t, @ptrCast(@alignCast(data.?))).a, 0);
    try expectEqual(@as(*t, @ptrCast(@alignCast(data.?))).b, 0x00);
    try expectEqual(@as(*t, @ptrCast(@alignCast(data.?))).c, 0);

    _ = dobj.destroy(false);
}

test "obj_mem_chunk" {
    const count: usize = 128;

    var dobj: lb.core.dobject = undefined;
    _ = dobj.init(count, @sizeOf(t));

    for (0..count) |_| {
        _ = dobj.alloc();
    }

    try expectEqual(dobj.mem.?.chunk_length, 1);

    _ = dobj.destroy(false);
}

test "obj_alloc_free_alloc" {
    var dobj: lb.core.dobject = undefined;
    _ = dobj.init(128, @sizeOf(t));

    var data = dobj.alloc();

    @as(*t, @ptrCast(@alignCast(data.?))).a = 159753;
    @as(*t, @ptrCast(@alignCast(data.?))).b = 'L';
    @as(*t, @ptrCast(@alignCast(data.?))).c = 12;

    _ = dobj.free(data);

    try expectEqual(dobj.allocated, 0);
    try expectEqual(dobj.cacheLength(), 1);

    data = dobj.alloc();

    try expectEqual(@as(*t, @ptrCast(@alignCast(data.?))).a, 159753);
    try expectEqual(@as(*t, @ptrCast(@alignCast(data.?))).b, 'L');
    try expectEqual(@as(*t, @ptrCast(@alignCast(data.?))).c, 12);

    _ = dobj.destroy(false);
}

test "obj_cache" {
    var dobj: lb.core.dobject = undefined;

    var data: [100]t = undefined;

    const data_size = data.len;

    _ = dobj.init(128, @sizeOf(t));

    for (0..data_size) |i| {
        data[i] = @as(*t, @ptrCast(@alignCast(dobj.alloc().?))).*;
        try expectEqual(dobj.allocated, i + 1);
    }

    for (0..data_size) |i| {
        _ = dobj.free(&data[i]);
        try expectEqual(dobj.cacheLength(), i + 1);
    }

    try expectEqual(dobj.allocated, 0);
    try expectEqual(dobj.cacheLength(), 100);

    _ = dobj.destroy(false);
}

test "absolute_position" {
    var data: *t = undefined;
    var dobj: lb.core.dobject = undefined;

    _ = dobj.init(128, @sizeOf(t));

    for (0..100) |i| {
        data = @as(*t, @ptrCast(@alignCast(dobj.alloc().?)));

        data.a = i;
        data.b = @intCast(i);
        data.c = @intCast(i + 5);
    }

    data = @as(*t, @ptrCast(@alignCast(dobj.byAbsolutePosition(34).?)));

    try expectEqual(data.a, 34);
    try expectEqual(data.b, 34);
    try expectEqual(data.c, 39);

    _ = dobj.destroy(false);
}

test "absolute_position_up" {
    var data: *t = undefined;
    var dobj: lb.core.dobject = undefined;

    _ = dobj.init(27, @sizeOf(t));

    for (0..213) |i| {
        data = @as(*t, @ptrCast(@alignCast(dobj.alloc().?)));

        data.a = i;
        data.b = @truncate(@as(c_int, @intCast(i)));
        data.c = @intCast(i + 5);
    }

    data = @as(*t, @ptrCast(@alignCast(dobj.byAbsolutePosition(121).?)));

    try expectEqual(data.a, 121);
    try expectEqual(data.b, 121);
    try expectEqual(data.c, 126);

    _ = dobj.destroy(false);
}

// test "bst_map_insert" {
//     var bst_map: lb.core.bst_map = undefined;
//     var entry: ?*lb.core.bst_map_entry = undefined;
//
//     var scope: ?*lb.core.bst_entry = null;
//
//     const key = "test";
//     const key_len = key.len;
//
//     try expectEqual(bst_map.init(128), @intFromEnum(lb.core.Status.ok));
//
//     entry = bst_map.insert(&scope, &key[0], key_len, @as(*anyopaque, @ptrFromInt(1)));
//
//     try expect(entry != null);
//     try expect(scope != null);
//
//     try expectEqualStrings(entry.?.str.data.?[0..key_len], key);
//     try expectEqual(entry.?.str.length, key_len);
//     try expectEqual(entry.?.value, @as(*anyopaque, @ptrFromInt(1)));
//
//     _ = bst_map.destroy(false);
// }
//
// test "bst_map_search" {
//     var bst_map: lb.core.bst_map = undefined;
//     var entry: ?*lb.core.bst_map_entry = undefined;
//
//     var scope: ?*lb.core.bst_entry = null;
//
//     const key = "test";
//     const key_len = key.len;
//
//     const col_key = "test1";
//     const col_key_len = key.len;
//
//     try expectEqual(bst_map.init(128), @intFromEnum(lb.core.Status.ok));
//
//     entry = bst_map.insert(&scope, &key[0], key_len, @as(*anyopaque, @ptrFromInt(1)));
//
//     try expect(entry != null);
//
//     entry = bst_map.insert(&scope, &col_key[0], col_key_len, @as(*anyopaque, @ptrFromInt(2)));
//
//     try expect(entry != null);
//
//     entry = bst_map.search(scope, &key[0], key_len);
//     try expect(entry != null);
//
//     try expectEqualStrings(entry.?.str.data.?[0..key_len], key);
//     try expectEqual(entry.?.str.length, key_len);
//     try expectEqual(entry.?.value, @as(*anyopaque, @ptrFromInt(1)));
//
//     _ = bst_map.destroy(false);
// }
//
// test "bst_map_remove" {
//     var value: ?*anyopaque = undefined;
//     var bst_map: lb.core.bst_map = undefined;
//     var entry: ?*lb.core.bst_map_entry = undefined;
//
//     var scope: ?*lb.core.bst_entry = null;
//
//     const key = "test";
//     const key_len = key.len;
//
//     const col_key = "test1";
//     const col_key_len = key.len;
//
//     try expectEqual(bst_map.init(128), @intFromEnum(lb.core.Status.ok));
//
//     entry = bst_map.insert(&scope, &key[0], key_len, @as(*anyopaque, @ptrFromInt(1)));
//
//     try expect(entry != null);
//
//     entry = bst_map.insert(&scope, &col_key[0], col_key_len, @as(*anyopaque, @ptrFromInt(2)));
//
//     try expect(entry != null);
//
//     value = bst_map.remove(&scope, &key[0], key_len);
//
//     try expectEqual(value.?, @as(*anyopaque, @ptrFromInt(1)));
//     try expect(scope != null);
//
//     _ = bst_map.destroy(false);
// }
//
// test "clean" {
//     var bst_map: lb.core.bst_map = undefined;
//     var entry: ?*lb.core.bst_map_entry = undefined;
//     var scope: ?*lb.core.bst_entry = null;
//
//     const key = "test";
//     const key_len = key.len;
//
//     try expectEqual(bst_map.init(128), @intFromEnum(lb.core.Status.ok));
//
//     entry = bst_map.insert(&scope, &key[0], key_len, @as(*anyopaque, @ptrFromInt(1)));
//
//     try expect(entry != null);
//
//     bst_map.clean();
//
//     _ = bst_map.destroy(false);
// }
//
// test "destroy" {
//     var bst_map = lb.core.bst_map.create().?;
//     try expectEqual(bst_map.init(128), @intFromEnum(lb.core.Status.ok));
//
//     try expectEqual(bst_map.destroy(true), null);
//
//     bst_map = lb.core.bst_map.create().?;
//     try expectEqual(bst_map.init(128), @intFromEnum(lb.core.Status.ok));
//
//     try expectEqual(bst_map.destroy(false), bst_map);
//     try expectEqual(bst_map.destroy(true), null);
//     try expectEqual(lb.core.bst_map.destroy(null, false), null);
// }
//
// test "destroy_stack" {
//     var bst_map: lb.core.bst_map = undefined;
//     try expectEqual(bst_map.init(128), @intFromEnum(lb.core.Status.ok));
//
//     try expectEqual(bst_map.destroy(false), &bst_map);
// }
