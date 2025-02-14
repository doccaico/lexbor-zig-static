const std = @import("std");
const expect = std.testing.expect;
const expectEqual = std.testing.expectEqual;
const expectEqualStrings = std.testing.expectEqualStrings;

const lb = @import("lexbor");

test "init" {
    var bst_map = lb.core.bstMap.create().?;
    const status = bst_map.init(128);

    try expectEqual(status, @intFromEnum(lb.core.Status.ok));

    _ = bst_map.destroy(true);
}

test "init_null" {
    const status = lb.core.bstMap.init(null, 128);
    try expectEqual(status, @intFromEnum(lb.core.Status.error_object_is_null));
}

test "init_stack" {
    var bst_map: lb.core.bstMap = undefined;
    const status = bst_map.init(128);

    try expectEqual(status, @intFromEnum(lb.core.Status.ok));

    _ = bst_map.destroy(false);
}

test "init_args" {
    var bst_map: lb.core.bstMap = .{ .bst = null, .mraw = null, .entries = null };
    var status: lb.core.status = undefined;

    status = bst_map.init(0);
    try expectEqual(status, @intFromEnum(lb.core.Status.error_wrong_args));

    _ = bst_map.destroy(false);
}

test "bst_map_insert" {
    var bst_map: lb.core.bstMap = undefined;
    var entry: ?*lb.core.bstMapEntry = undefined;

    var scope: ?*lb.core.bstEntry = null;

    const key = "test";
    const key_len = key.len;

    try expectEqual(bst_map.init(128), @intFromEnum(lb.core.Status.ok));

    entry = bst_map.insert(&scope, &key[0], key_len, @as(*anyopaque, @ptrFromInt(1)));

    try expect(entry != null);
    try expect(scope != null);

    try expectEqualStrings(entry.?.str.data.?[0..key_len], key);
    try expectEqual(entry.?.str.length, key_len);
    try expectEqual(entry.?.value, @as(*anyopaque, @ptrFromInt(1)));

    _ = bst_map.destroy(false);
}

test "bst_map_search" {
    var bst_map: lb.core.bstMap = undefined;
    var entry: ?*lb.core.bstMapEntry = undefined;

    var scope: ?*lb.core.bstEntry = null;

    const key = "test";
    const key_len = key.len;

    const col_key = "test1";
    const col_key_len = key.len;

    try expectEqual(bst_map.init(128), @intFromEnum(lb.core.Status.ok));

    entry = bst_map.insert(&scope, &key[0], key_len, @as(*anyopaque, @ptrFromInt(1)));

    try expect(entry != null);

    entry = bst_map.insert(&scope, &col_key[0], col_key_len, @as(*anyopaque, @ptrFromInt(2)));

    try expect(entry != null);

    entry = bst_map.search(scope, &key[0], key_len);
    try expect(entry != null);

    try expectEqualStrings(entry.?.str.data.?[0..key_len], key);
    try expectEqual(entry.?.str.length, key_len);
    try expectEqual(entry.?.value, @as(*anyopaque, @ptrFromInt(1)));

    _ = bst_map.destroy(false);
}

test "bst_map_remove" {
    var value: ?*anyopaque = undefined;
    var bst_map: lb.core.bstMap = undefined;
    var entry: ?*lb.core.bstMapEntry = undefined;

    var scope: ?*lb.core.bstEntry = null;

    const key = "test";
    const key_len = key.len;

    const col_key = "test1";
    const col_key_len = key.len;

    try expectEqual(bst_map.init(128), @intFromEnum(lb.core.Status.ok));

    entry = bst_map.insert(&scope, &key[0], key_len, @as(*anyopaque, @ptrFromInt(1)));

    try expect(entry != null);

    entry = bst_map.insert(&scope, &col_key[0], col_key_len, @as(*anyopaque, @ptrFromInt(2)));

    try expect(entry != null);

    value = bst_map.remove(&scope, &key[0], key_len);

    try expectEqual(value.?, @as(*anyopaque, @ptrFromInt(1)));
    try expect(scope != null);

    _ = bst_map.destroy(false);
}

test "clean" {
    var bst_map: lb.core.bstMap = undefined;
    var entry: ?*lb.core.bstMapEntry = undefined;
    var scope: ?*lb.core.bstEntry = null;

    const key = "test";
    const key_len = key.len;

    try expectEqual(bst_map.init(128), @intFromEnum(lb.core.Status.ok));

    entry = bst_map.insert(&scope, &key[0], key_len, @as(*anyopaque, @ptrFromInt(1)));

    try expect(entry != null);

    bst_map.clean();

    _ = bst_map.destroy(false);
}

test "destroy" {
    var bst_map = lb.core.bstMap.create().?;
    try expectEqual(bst_map.init(128), @intFromEnum(lb.core.Status.ok));

    try expectEqual(bst_map.destroy(true), null);

    bst_map = lb.core.bstMap.create().?;
    try expectEqual(bst_map.init(128), @intFromEnum(lb.core.Status.ok));

    try expectEqual(bst_map.destroy(false), bst_map);
    try expectEqual(bst_map.destroy(true), null);
    try expectEqual(lb.core.bstMap.destroy(null, false), null);
}

test "destroy_stack" {
    var bst_map: lb.core.bstMap = undefined;
    try expectEqual(bst_map.init(128), @intFromEnum(lb.core.Status.ok));

    try expectEqual(bst_map.destroy(false), &bst_map);
}
