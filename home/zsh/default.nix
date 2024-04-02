{ config, lib, pkgs, ... }: {
  # ZSH Config
  programs.zsh = {
    enable = true;

    shellAliases = {
      ls = "lsd";
      ll = "lsd -l";
    };

    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.7.0";
          sha256 = "149zh2rm59blr2q458a5irkfh82y3dwdich60s9670kl3cl5h2m1";
        };
      }
    ];

    initExtra = ''
      source $HOME/.p10k.zsh
      eval "$(direnv hook zsh)"
    '';

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "fzf" "direnv" ];
      custom = "$HOME/.omz-custom/";
      theme = "powerlevel10k/powerlevel10k";
    };

    syntaxHighlighting.enable = true;
    enableAutosuggestions = true;
  };
}
