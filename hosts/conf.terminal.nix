{ ... }:

{
  programs.mosh.enable = true;
  programs.tmux.enable = true;
  programs.tmux.keyMode = "vi";
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    configure = {
      customRC = ''
        set runtimepath^=~/.vim runtimepath+=~/.vim/after
        let &packpath = &runtimepath
        source ~/.vimrc
      '';
    };
  };
}
