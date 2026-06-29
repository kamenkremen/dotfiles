{pkgs, ...}: {
  security.rtkit.enable = true;
  environment.systemPackages = with pkgs; [
    qjackctl
  ];

  services.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.extraConfig."90-hotone-ampero-one" = {
      "monitor.alsa.rules" = [
        {
          matches = [
            {
              "device.name" = "~alsa_card.usb-HOTONE_AUDIO_HOTONE_MP80_PRODUCT_.*";
            }
          ];
          actions.update-props = {
            "device.profile" = "output:analog-stereo+input:analog-stereo";
            "api.acp.auto-profile" = false;
          };
        }
        {
          matches = [
            {
              "node.name" = "~alsa_(output|input)\\.usb-HOTONE_AUDIO_HOTONE_MP80_PRODUCT_.*\\.analog-stereo";
            }
          ];
          actions.update-props = {
            "audio.format" = "S16LE";
            "audio.rate" = 44100;
          };
        }
      ];
    };
    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 44100;
        "default.clock.allowed-rates" = [44100 48000];
        "default.clock.quantum" = 256;
        "default.clock.min-quantum" = 128;
        "default.clock.max-quantum" = 1024;
      };
    };
  };
}
