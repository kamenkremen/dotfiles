{ ... }:
{
  programs.steam.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.amdgpu.opencl.enable = true;
}
