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
    var dobj = lb.core.Dobject.create().?;
    const status = dobj.init(128, @sizeOf(t));

    try expectEqual(status, @intFromEnum(lb.core.Status.ok));

    _ = dobj.destroy(true);
}

test "init_stack" {
    var dobj: lb.core.Dobject = undefined;
    const status = dobj.init(128, @sizeOf(t));

    try expectEqual(status, @intFromEnum(lb.core.Status.ok));

    _ = dobj.destroy(false);
}

test "init_args" {
    var dobj = zeroInit(lb.core.Dobject, .{});
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
    var dobj: lb.core.Dobject = undefined;
    _ = dobj.init(128, @sizeOf(t));

    const data = dobj.alloc();

    try expect(data != null);
    try expectEqual(dobj.allocated, 1);

    _ = dobj.destroy(false);
}

test "obj_calloc" {
    var dobj: lb.core.Dobject = undefined;
    _ = dobj.init(128, @sizeOf(t));

    const data = dobj.calloc();

    try expectEqual(@as(*t, @ptrCast(@alignCast(data.?))).a, 0);
    try expectEqual(@as(*t, @ptrCast(@alignCast(data.?))).b, 0x00);
    try expectEqual(@as(*t, @ptrCast(@alignCast(data.?))).c, 0);

    _ = dobj.destroy(false);
}

test "obj_mem_chunk" {
    const count: usize = 128;

    var dobj: lb.core.Dobject = undefined;
    _ = dobj.init(count, @sizeOf(t));

    for (0..count) |_| {
        _ = dobj.alloc();
    }

    try expectEqual(dobj.mem.?.chunk_length, 1);

    _ = dobj.destroy(false);
}

test "obj_alloc_free_alloc" {
    var dobj: lb.core.Dobject = undefined;
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
    var dobj: lb.core.Dobject = undefined;

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
    var dobj: lb.core.Dobject = undefined;

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
    var dobj: lb.core.Dobject = undefined;

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

test "absolute_position_edge" {
    var data: *t = undefined;
    var dobj: lb.core.Dobject = undefined;

    _ = dobj.init(128, @sizeOf(t));

    for (0..256) |i| {
        data = @as(*t, @ptrCast(@alignCast(dobj.alloc().?)));

        data.a = i;
        data.b = @truncate(@as(c_int, @intCast(i)));
        data.c = @intCast(i + 5);
    }

    data = @as(*t, @ptrCast(@alignCast(dobj.byAbsolutePosition(128).?)));

    try expectEqual(data.a, 128);
    try expectEqual(data.b, @as(c_char, @truncate(@as(c_int, @intCast(128)))));
    try expectEqual(data.c, 133);

    _ = dobj.destroy(false);
}

test "obj_free" {
    var dobj: lb.core.Dobject = undefined;
    _ = dobj.init(128, @sizeOf(t));

    const data = @as(*t, @ptrCast(@alignCast(dobj.alloc().?)));
    _ = dobj.free(data);

    try expectEqual(dobj.allocated, 0);
    try expectEqual(dobj.cacheLength(), 1);

    _ = dobj.destroy(false);
}

test "clean" {
    var dobj: lb.core.Dobject = undefined;
    _ = dobj.init(128, @sizeOf(t));

    const data = @as(?*t, @ptrCast(@alignCast(dobj.alloc().?)));
    try expect(data != null);

    dobj.clean();
    try expectEqual(dobj.allocated, 0);
    try expectEqual(dobj.cacheLength(), 0);

    _ = dobj.destroy(false);
}

test "destroy" {
    var dobj = lb.core.Dobject.create().?;
    _ = dobj.init(128, @sizeOf(t));

    try expectEqual(dobj.destroy(true), null);

    dobj = lb.core.Dobject.create().?;
    _ = dobj.init(128, @sizeOf(t));

    try expectEqual(dobj.destroy(false), dobj);
    try expectEqual(dobj.destroy(true), null);
    try expectEqual(lb.core.Dobject.destroy(null, false), null);
}

test "destroy_stack" {
    var dobj = lb.core.Dobject.create().?;
    _ = dobj.init(128, @sizeOf(t));

    try expectEqual(dobj.destroy(false), dobj);
}
