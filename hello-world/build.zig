const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    const exe = b.addExecutable("bootx64", "src/main.zig");
    exe.setBuildMode(b.standardReleaseOptions());
    exe.setTarget(.{
        .cpu_arch = .x86_64,
        .os_tag = .uefi,
        .abi = .msvc,
    });
    exe.setOutputDir("root/efi/boot");
    exe.install();
}
