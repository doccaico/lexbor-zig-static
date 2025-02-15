const std = @import("std");
const expect = std.testing.expect;
const expectEqual = std.testing.expectEqual;
const zeroInit = std.mem.zeroInit;

const lb = @import("lexbor");

test "init" {
    var mem = lb.core.Mem.create().?;
    const status = mem.init(1024);

    try expectEqual(status, @intFromEnum(lb.core.Status.ok));

    try expect(mem.chunk != null);
    try expectEqual(mem.chunk, mem.chunk_first);

    try expect(mem.chunk.?.data != null);
    try expectEqual(mem.chunk.?.next, null);
    try expectEqual(mem.chunk.?.prev, null);

    try expectEqual(mem.chunk.?.length, 0);
    try expectEqual(mem.chunk.?.size, 1024);

    try expectEqual(mem.chunk_length, 1);
    try expectEqual(mem.chunk_min_size, 1024);

    _ = mem.destroy(true);
}

test "init_null" {
    const status = lb.core.Mem.init(null, 1024);
    try expectEqual(status, @intFromEnum(lb.core.Status.error_object_is_null));
}

test "init_stack" {
    var mem: lb.core.Mem = undefined;
    const status = mem.init(1024);

    try expectEqual(status, @intFromEnum(lb.core.Status.ok));

    _ = mem.destroy(false);
}

test "init_args" {
    var mem = zeroInit(lb.core.Mem, .{});
    var status: lb.core.status = undefined;

    status = mem.init(0);
    try expectEqual(status, @intFromEnum(lb.core.Status.error_wrong_args));

    _ = mem.destroy(false);
}

test "mem_alloc" {
    var mem: lb.core.Mem = undefined;
    _ = mem.init(1024);

    const data = mem.alloc(12);
    try expect(data != null);

    _ = mem.destroy(false);
}

test "mem_alloc_n" {
    var mem: lb.core.Mem = undefined;
    _ = mem.init(1024);

    for (0..32) |_| {
        try expect(mem.alloc(32) != null);
    }

    try expectEqual(mem.chunk_length, 1);

    _ = mem.destroy(false);
}

test "mem_alloc_overflow" {
    var mem: lb.core.Mem = undefined;
    _ = mem.init(31);

    const data = mem.alloc(1047);
    try expect(data != null);

    try expectEqual(mem.chunk_length, 2);

    _ = mem.destroy(false);
}

test "mem_calloc" {
    const len: usize = 12;

    var mem: lb.core.Mem = undefined;
    _ = mem.init(1024);

    const data: ?[*]u8 = @ptrCast(@alignCast(mem.calloc(len)));
    try expect(data != null);

    for (0..len) |i| {
        try expectEqual(data.?[i], 0x00);
    }

    try expectEqual(mem.chunk_length, 1);

    _ = mem.destroy(false);
}

test "mem_calloc_overflow" {
    const len: usize = 1027;

    var mem: lb.core.Mem = undefined;
    _ = mem.init(31);

    const data: ?[*]u8 = @ptrCast(@alignCast(mem.calloc(len)));
    try expect(data != null);

    for (0..len) |i| {
        try expectEqual(data.?[i], 0x00);
    }

    try expectEqual(mem.chunk_length, 2);

    _ = mem.destroy(false);
}

test "clean" {
    var mem: lb.core.Mem = undefined;
    _ = mem.init(12);

    for (0..32) |_| {
        try expect(mem.alloc(24) != null);
    }

    mem.clean();

    try expect(mem.chunk != null);
    try expectEqual(mem.chunk_first, mem.chunk);

    try expectEqual(mem.chunk.?.length, 0);
    try expectEqual(mem.chunk.?.size, mem.chunk_min_size);
    try expect(mem.alloc(24) != null);

    _ = mem.destroy(false);
}

test "destroy" {
    var mem = lb.core.Mem.create().?;
    _ = mem.init(1024);

    try expectEqual(mem.destroy(true), null);

    mem = lb.core.Mem.create().?;
    _ = mem.init(1021);

    try expectEqual(mem.destroy(false), mem);
    try expectEqual(mem.destroy(true), null);
    try expectEqual(lb.core.Mem.destroy(null, false), null);
}
