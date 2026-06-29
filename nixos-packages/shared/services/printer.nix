{
  config,
  pkgs,
  ...
}: {
  services.printing.enable = true;

  services.printing.drivers = with pkgs; [
    gutenprint
    gutenprintBin
    hplip
    brlaser
    epson-escpr
    splix
  ];
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
