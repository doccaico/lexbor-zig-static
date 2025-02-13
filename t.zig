const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;
const print = std.debug.print;
const assert = std.debug.assert;
const expect = std.testing.expect;

pub fn main() !void {
    const args = [_][]const u8{ "zig.exe", "test", "-Dcss=true", "-Dns=true" };

    // const single_example_name = args[args.len - 1];
    // var index: ?usize = null;

    const is_test = blk: {
        for (args[1..]) |arg| {
            if (std.mem.eql(u8, "test", arg)) {
                break :blk true;
            }
        }
        break :blk false;
    };

    print("{any}\n", .{is_test});
}
// zig test filename.zig
// test "if" {
//     try expect(1 == 1);
// }
//  const stdout = std.io.getStdOut().writer();
//  const message: []const u8 = "Hello, World!";
//  try stdout.print("{s}\n", .{message});
