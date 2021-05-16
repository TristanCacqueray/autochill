{ pkgs ? import (builtins.fetchTarball
  "https://github.com/NixOS/nixpkgs/archive/c0e881852006b132236cbf0301bd1939bb50867e.tar.gz")
  { } }:

let
  easy-ps = import (pkgs.fetchFromGitHub {
    owner = "justinwoo";
    repo = "easy-purescript-nix";
    rev = "9b56211d";
    sha256 = "1xkbvcjx5qyz5z7qjampxnhpvvg5grv5ikqpjr1glrfs1lvjff49";
  }) { inherit pkgs; };

in pkgs.mkShell {
  buildInputs = [
    easy-ps.purs
    easy-ps.spago
    pkgs.gjs
    pkgs.gtk4
    pkgs.gnome3.gobject-introspection
    pkgs.dhall
    pkgs.dhall-json
  ];
}
