// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃                     zcloc v0.4.0                              ┃
// ┃                                                               ┃
// ┃                  Created by: aliel0malki                      ┃
// ┃                Last Updated: 2024-11-5                        ┃
// ┃                      License: MIT                             ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

const std = @import("std");

pub fn main() !void {
    const allocator = std.heap.page_allocator;
    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len != 2) {
        std.debug.print("Usage: zcloc <directory>\n", .{});
        return;
    }

    const directory = args[1];
    var file_counts = FileCounts.init();
    try processDirectory(directory, &file_counts);
    file_counts.printSummary();
}

const FileCounts = struct {
    codes: usize = 0,
    comments: usize = 0,
    blank_lines: usize = 0,

    pub fn init() FileCounts {
        return FileCounts{};
    }

    pub fn printSummary(self: *FileCounts) void {
        std.debug.print("Code: {d}\nComment: {d}\nBlank: {d}\n", .{ self.codes, self.comments, self.blank_lines });
    }
};

fn processDirectory(dir_path: []const u8, counts: *FileCounts) !void {
    var dir = try std.fs.cwd().openDir(dir_path, .{ .iterate = true });
    defer dir.close();

    var iterator = dir.iterate();
    while (try iterator.next()) |entry| {
        if (entry.kind == .file) {
            const file_path = try std.fs.path.join(std.heap.page_allocator, &.{ dir_path, entry.name });
            defer std.heap.page_allocator.free(file_path);
            try processFile(file_path, counts);
        } else if (entry.kind == .directory) {
            const sub_dir_path = try std.fs.path.join(std.heap.page_allocator, &.{ dir_path, entry.name });
            defer std.heap.page_allocator.free(sub_dir_path);
            try processDirectory(sub_dir_path, counts);
        }
    }
}

fn processFile(file_path: []const u8, counts: *FileCounts) !void {
    const file = try std.fs.cwd().openFile(file_path, .{ .mode = .read_only });
    defer file.close();
    var reader = file.reader();
    var buffer: [1024]u8 = undefined;
    while (try reader.readUntilDelimiterOrEof(&buffer, '\n')) |line| {
        if (line.len == 0) {
            counts.blank_lines += 1;
            continue;
        }
        if (line[0] == '/' and line.len > 1) {
            if (line[1] == '/' or line[1] == '*') {
                counts.comments += 1;
                continue;
            }
        }
        counts.codes += 1;
    }
}
