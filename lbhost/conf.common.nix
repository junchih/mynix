{ ... }:

{
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?

  # Set your time zone.
  time.timeZone = "Asia/Singapore";
  # Enable unfree packages
  nixpkgs.config.allowUnfree = true;

  # Journald logging rate limit
  services.journald.rateLimitInterval = "60s";
  services.journald.rateLimitBurst = 300;

  # Nix store space optimising
  nix.settings = {
    auto-optimise-store = true;
  };
  nix.gc = {
    automatic = true;
    dates = "03:15";
    persistent = true;
    options = "--delete-older-than 7d";
  };

  networking.enableIPv6 = true;
  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  # Disable network manager, all configuration shall be manually config here
  networking.networkmanager.enable = false;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
}
