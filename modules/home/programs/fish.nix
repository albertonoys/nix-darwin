{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}: {
  programs.fish = {
    enable = true;
    # Every fish process (scripts, `fish -c`): PATH and env only. Static paths and
    # variables live in home.sessionPath / home.sessionVariables (shell.nix).
    shellInit = ''
      eval (${osConfig.homebrew.prefix}/bin/brew shellenv)
    '';
    interactiveShellInit = ''
      # GitHub token for Nix flake updates (avoids API rate limits).
      # Set as NIX_CONFIG so only nix sees it, not git/gh.
      if security find-generic-password -a nix-github-token -s nix-github-token &>/dev/null
        set -gx NIX_CONFIG "access-tokens = github.com="(security find-generic-password -a nix-github-token -s nix-github-token -w)
      end

      # Java: Android Studio's bundled JDK when installed, else nix zulu21.
      set -l jbr "/Applications/Android Studio.app/Contents/jbr/Contents/Home"
      if test -d $jbr
        set -gx JAVA_HOME $jbr
      else
        set -gx JAVA_HOME ${pkgs.zulu21.home}
      end
      set -gxp PATH $JAVA_HOME/bin

      # Android SDK
      if test -d $HOME/Library/Android/sdk
        set -gx ANDROID_HOME $HOME/Library/Android/sdk
        set -gxp PATH $ANDROID_HOME/platform-tools
      end

      if type -q atuin
        atuin init fish | source
      end

      abbr -a cd z
    '';
    shellAliases.rld = "source ~/.config/fish/config.fish";
    functions = {
      fish_greeting = lib.mkDefault "";
      bind_bang = ''
        switch (commandline -t)
        case "!"
          commandline -t $history[1]; commandline -f repaint
        case "*"
          commandline -i !
        end
      '';
      bind_dollar = ''
        switch (commandline -t)
        case "!"
          commandline -t ""
          commandline -f history-token-search-backward
        case "*"
          commandline -i '$'
        end
      '';
      fish_user_key_bindings = ''
        bind ! bind_bang
        bind '$' bind_dollar
      '';
      hf = ''
        eval (history | fzf -i)
      '';
      # shell foo bar -> nix shell nixpkgs#foo nixpkgs#bar
      shell = ''
        nix shell (string replace -r '^' 'nixpkgs#' -- $argv)
      '';
      nix-update = ''
        just -f ${config.my.repoDir}/Justfile update switch
      '';
      nix-apply-config = ''
        just -f ${config.my.repoDir}/Justfile switch
      '';
      nix-clean = ''
        just -f ${config.my.repoDir}/Justfile gc
      '';
      nix-upgrade = ''
        just -f ${config.my.repoDir}/Justfile upgrade
      '';
    };
    plugins = [
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
      {
        name = "bass";
        src = pkgs.fishPlugins.bass.src;
      }
    ];
  };
}
