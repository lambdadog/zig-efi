const std = @import("std");
const uefi = std.os.uefi;

pub fn main() uefi.Status {
    const message: [*:0]const u16 = std.unicode.utf8ToUtf16LeStringLiteral(
        "Hello, world!",
    );

    // Acquire handles
    const boot_services = uefi.system_table.boot_services orelse {
        return .Unsupported;
    };
    const con_in = uefi.system_table.con_in orelse {
        return .Unsupported;
    };
    const con_out = uefi.system_table.con_out orelse {
        return .Unsupported;
    };

    // Display
    switch (con_out.clearScreen()) {
        .Success => {},
        else => |code| return code,
    }

    switch (con_out.outputString(message)) {
        .Success => {},
        else => |code| return code,
    }

    // Wait for input
    var idx: usize = undefined;
    switch (boot_services.waitForEvent(
        1,
        @ptrCast([*]const uefi.Event, &con_in.wait_for_key),
        &idx,
    )) {
        .Success => {},
        else => |code| return code,
    }

    // Clear screen again before exiting. Nonessential, so we ignore
    // the Status.
    _ = con_out.clearScreen();

    return .Success;
}
