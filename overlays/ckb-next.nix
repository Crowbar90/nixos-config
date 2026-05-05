# To be used until commit 20a3df9a is merged in an official release

final: prev:
{
  ckb-next = prev.ckb-next.overrideAttrs (old: {
    version = "20a3df9a-unstable-2026-05-05";

    src = prev.fetchFromGitHub {
      owner = "ckb-next";
      repo = "ckb-next";
      rev = "20a3df9a678b87b38c28aa921148ac38afb41b10";
      hash = "sha256-gWayVV6DDsx6gU5IZOwU2zMKn9R7NZul8GQh3jymOW8=";
    };
  });
}
