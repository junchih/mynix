{ configuration
, pkgs
, lib
, ...
}:

let
  inherit (lib)
    optionals
    optionalAttrs
    ;
  has-X = configuration.services.xserver.enable or false;
in
{
  environment.systemPackages = with pkgs; [
    wget
    curl
    tree
    unzip
    unrar
    gnutar
  ] ++ (optionals has-X [
    neovide
    vlc
    nomacs
  ]);
  programs.mosh = {
    enable = true;
  };
  programs.tmux = {
    enable = true;
    keyMode = "vi";
  };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withRuby = false;
    withPython3 = false;
    withNodeJs = false;
    configure = {
      customRC = ''
        set runtimepath^=~/.vim runtimepath+=~/.vim/after
        let &packpath = &runtimepath
        source ~/.vimrc
      '';
    };
  };
  programs.firefox = optionalAttrs has-X {
    enable = true;
  };
}
