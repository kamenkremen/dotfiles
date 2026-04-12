{pkgs, ...}: {
  imports = [
    ./system.nix
    ./hardware-configuration.nix
  ];
  programs.java = {
    enable = true;
    package = pkgs.graalvmPackages.graalvm-oracle;
  };
  programs.steam.enable = true;
  programs.steam.extraCompatPackages = with pkgs; [proton-ge-bin];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.amdgpu.opencl.enable = true;

  services.v2raya.enable = true;
  services.v2raya.cliPackage = pkgs.xray;
}
