const std = @import("std");
const fmt = std.fmt;
const mem = std.mem;
const print = std.debug.print;
const assert = std.debug.assert;
const expect = std.testing.expect;

pub fn main() !void {
    var arena: std.heap.ArenaAllocator = undefined;

    arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const args = [_][]const u8{ "zig.exe", "test", "-Dcss=true", "-Dns=true" };

    var list = std.ArrayList([]const u8).init(allocator);
    // missing `defer list.deinit();`
    try list.append("start");
    try list.appendSlice(args[0..]);

    for (list.items) |item| {
        print("{s}\n", .{item});
    }
}
// zig test filename.zig
// test "if" {
//     try expect(1 == 1);
// }
//  const stdout = std.io.getStdOut().writer();
//  const message: []const u8 = "Hello, World!";
//  try stdout.print("{s}\n", .{message});
