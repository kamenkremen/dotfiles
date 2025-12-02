{...}:
{
programs.firefox = {
    enable = true;

    profiles = {
      my-profile = {
	 
      };
      my-friends-profile = {
        # bookmarks, extensions, search engines...
      };
    };
  };

  stylix.targets.firefox.profileNames = [ "default" "my-friends-profile" ];
}
