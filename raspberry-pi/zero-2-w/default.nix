{ lib, pkgs, ... }:

{
  imports = [
    ../3
    ../common/default.nix
  ];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  boot.kernelPackages = lib.mkOverride 900 (
    pkgs.linuxPackagesFor (
      pkgs.callPackage ../common/kernel.nix {
        rpiVersion = 3;
        argsOverride = {
          defconfig =
            if pkgs.stdenv.hostPlatform.isAarch64 then "bcm2711_defconfig" else "bcm2709_defconfig";
        };
      }
    )
  );

  hardware.deviceTree.filter = lib.mkDefault "bcm2710-rpi-zero-2*.dtb";

  hardware.firmware = [ (pkgs.callPackage ../common/raspberry-pi-wireless-firmware.nix { }) ];
}
