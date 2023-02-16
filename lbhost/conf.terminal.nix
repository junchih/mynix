{ ... }:

{
  programs.mosh.enable = true;
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
}
