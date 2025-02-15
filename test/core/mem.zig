const std = @import("std");
const expect = std.testing.expect;
const expectEqual = std.testing.expectEqual;

const lb = @import("lexbor");

// test "init" {
//     var array = lb.core.Array.create().?;
//     const status = array.init(32);
//
//     try expectEqual(status, @intFromEnum(lb.core.Status.ok));
//
//     _ = array.destroy(true);
// }
//
// test "init_null" {
//     const status = lb.core.Array.init(null, 32);
//     try expectEqual(status, @intFromEnum(lb.core.Status.error_object_is_null));
// }
