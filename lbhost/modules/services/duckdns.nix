{ config
, lib
, pkgs
, ...
}:

let

  inherit (lib)
    mkOption
    mkIf
    mdDoc
    optionalString
    types
    ;
  cfg = config.services.duckdns;

in
{

  options.services.duckdns = {

    enable = mkOption {
      default = false;
      type = types.bool;
      description = mdDoc ''
        Enable duckdns service to update dynamic dns of duckdns.
      '';
    };

    interval = mkOption {
      default = "10min";
      type = types.str;
      description = mdDoc ''
        The interval at which to run the check and update.
        See {command}`main 7 systemd.time` for the format.
      '';
    };

    ipv4 = mkOption {
      default = true;
      type = types.bool;
      description = mdDoc ''
        Whether to use IPv4.
      '';
    };

    ipv6 = mkOption {
      default = false;
      type = types.bool;
      description = mdDoc ''
        Whether to use IPv6.
      '';
    };

    domain = mkOption {
      default = "";
      type = types.str;
      description = mdDoc ''
        The sub domain name to synchronize. See duckdns url format.
      '';
    };

    token = mkOption {
      default = "";
      type = types.str;
      description = mdDoc ''
        The duckdns generated token for account identifying.
      '';
    };

  };

  config = mkIf cfg.enable {

    assertions = [
      {
        assertion = cfg.domain != "";
        message = "services.duckdns.domain shall not be empty!";
      }
      {
        assertion = cfg.token != "";
        message = "services.duckdns.token missing value!";
      }
    ];

    systemd.services.duckdns-updater = {
      script =
        let
          curl = "${pkgs.curl}/bin/curl";
          get-ipv4-addr = optionalString cfg.ipv4
            "$(${curl} -s \"https://api.ipify.org\")";
          get-ipv6-addr = optionalString cfg.ipv6
            "$(${curl} -s \"https://api6.ipify.org\")";
        in
        ''
          set -eu
          ipv4_addr=${get-ipv4-addr}
          ipv6_addr=${get-ipv6-addr}
          ${curl} -s "https://www.duckdns.org/update?domains=${cfg.domain}&token=${cfg.token}&ip=$ipv4_addr&ipv6=$ipv6_addr"
        '';
      serviceConfig = {
        DynamicUser = true;
        Type = "oneshot";
      };
    };

    systemd.timers.duckdns-updater = {
      description = "Update duckdns";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = cfg.interval;
        OnUnitInactiveSec = cfg.interval;
        Unit = "duckdns-updater.service";
      };
    };

  };
}
