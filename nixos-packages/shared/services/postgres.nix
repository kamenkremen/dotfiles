{pkgs, ...}:
{
  services.postgresql = {
  	enable = true;
	package = pkgs.postgresql_16;

	extensions = with pkgs.postgresql16Packages; [
		postgis
	];
  };
}
