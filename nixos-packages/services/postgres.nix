{pkgs, ...}:
{
  services.postgresql = {
  	enable = true;
	package = pkgs.postgresql_16;

	extraPlugins = with pkgs.postgresql16Packages; [
		postgis
	];
  };
}
