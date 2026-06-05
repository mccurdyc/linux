{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    git-hooks.url = "github:cachix/git-hooks.nix";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    flake-parts.url = "github:hercules-ci/flake-parts";
    mccurdyc-preferences.url = "github:mccurdyc/nix-templates?dir=modules";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
      ];

      imports = [
        inputs.git-hooks.flakeModule
        inputs.treefmt-nix.flakeModule
        inputs.mccurdyc-preferences.flakeModules.default
      ];

      perSystem =
        { pkgs, ... }:
        {
          mccurdyc = {
            devshell = {
              extraPackages = with pkgs; [
                flex
                bison
                # With the above, I could run `make config`
                bear # generating compile_commands.json for clangd
                # make config
                # make clean; bear -- make
                clang-tools # clangd for neovim LSP
                # HOSTCC=clang (wrapped)
                llvmPackages_19.clang # need wrapped for libc headers
                llvmPackages_19.bintools
                llvmPackages_19.lld
                llvmPackages_19.llvm
                elfutils
                openssl
                ccache # https://docs.kernel.org/kbuild/llvm.html#ccache

                pkg-config
                ncurses
              ];
            };
          };
        };
    };
}
