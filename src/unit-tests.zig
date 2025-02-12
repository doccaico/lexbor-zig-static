const std = @import("std");
const expect = std.testing.expect;
const expectEqual = std.testing.expectEqual;

const lb = @import("lexbor");

test "init" {
    var array = lb.array.create().?;
    const status = array.init(32);

    try expectEqual(status, @intFromEnum(lb.Status.ok));
    // try expectEqual(status, @intFromEnum(lb.Status.error_wrong_args));

    _ = array.destroy(true);
}
