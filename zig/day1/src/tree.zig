const std = @import("std");

pub const TreeNode = struct {
    value: i32,
    left: ?*TreeNode,
    right: ?*TreeNode,

    pub fn init(value: i32) TreeNode {
        return TreeNode{
            .value = value,
            .left = null,
            .right = null,
        };
    }

    pub fn insert(self: *TreeNode, value: i32) !void {
        if (value < self.value) {
            if (self.left) |left| {
                try left.insert(value);
            } else {
                const allocator = std.heap.page_allocator;
                const node = try allocator.create(TreeNode);
                defer allocator.free(node);
                node.* = TreeNode.init(value);
                self.left = node;
            }
        } else {
            if (self.right) |right| {
                try right.insert(value);
            } else {
                const allocator = std.heap.page_allocator;
                const node = try allocator.create(TreeNode);
                defer allocator.free(node);
                node.* = TreeNode.init(value);
                self.right = node;
            }
        }
    }
};

pub const TreeIterator = struct {
    stack: std.ArrayList(*TreeNode),
    current: ?*TreeNode,

    pub fn init(allocator: std.mem.Allocator, root: *TreeNode) !TreeIterator {
        const stack = std.ArrayList(*TreeNode).init(allocator);
        return TreeIterator{
            .stack = stack,
            .current = root,
        };
    }

    pub fn deinit(self: *TreeIterator) void {
        self.stack.deinit();
    }

    pub fn next(self: *TreeIterator) ?*i32 {
        if (self.current == null and self.stack.items.len == 0) {
            return null;
        }

        while (self.current) |node| {
            try self.stack.append(node);
            self.current = node.left;
        }

        const top_node = self.stack.pop();

        self.current = top_node.right;

        return top_node.value;
    }
};
