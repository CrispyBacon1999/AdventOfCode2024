const std = @import("std");
const TreeNode = @import("tree.zig").TreeNode;
const TreeIterator = @import("tree.zig").TreeIterator;

pub fn main() !void {
    const file_path = "test.txt";
    const allocator = std.heap.page_allocator;
    const left_numbers = try allocator.create(TreeNode);
    const right_numbers = try allocator.create(TreeNode);

    defer allocator.free(left_numbers);
    defer allocator.free(right_numbers);

    try read_file(file_path, left_numbers, right_numbers);

    var left_iterator = try TreeIterator.init(allocator, left_numbers);
    defer left_iterator.deinit();

    var right_iterator = try TreeIterator.init(allocator, right_numbers);
    defer right_iterator.deinit();

    var total_sum: i32 = 0;

    // Loop through both trees together
    while (left_iterator.next() != null and right_iterator.next() != null) {
        const left_value = left_iterator.next();
        const right_value = right_iterator.next();

        // Find the difference between the two values
        const difference: i32 = left_value.? - right_value.?;

        // Add the difference to the total sum
        total_sum += difference;
    }

    std.debug.print("Total sum: {}\n", .{total_sum});
}

fn read_file(path: []const u8, left_numbers: *TreeNode, right_numbers: *TreeNode) !void {
    const file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var first_line = true;
    var buf: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        const line_slice: []const u8 = line;
        var it = std.mem.splitSequence(u8, line_slice, " ");
        if (it.next()) |left_str| {
            if (it.next()) |right_str| {
                const left = try std.fmt.parseInt(i32, left_str, 10);
                const right = try std.fmt.parseInt(i32, right_str, 10);

                if (first_line) {
                    left_numbers.* = TreeNode.init(left);
                    right_numbers.* = TreeNode.init(right);
                    first_line = false;
                } else {
                    left_numbers.insert(left);
                    right_numbers.insert(right);
                }
            }
        }
    }
}

test "simple test" {
    var list = std.ArrayList(i32).init(std.testing.allocator);
    defer list.deinit(); // try commenting this out and see if zig detects the memory leak!
    try list.append(42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
