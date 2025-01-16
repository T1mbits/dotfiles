{
  buildGoModule,
  fetchFromGitHub,
  ...
}:

buildGoModule rec {
  pname = "todocli";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "HxX2";
    repo = "todocli";
    rev = "v${version}";
    hash = "sha256-dvuBkrI3+5bfrNYvAYFucxyGFqP5jqMW1Zz8VgHl704=";
  };

  vendorHash = "sha256-6M1d2JAj9yCN9hIhE8QL+GXH3QdNhPCdm1Fa/j5X1lE=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Todo CLI to manage your to do list in a neat way";
    homepage = "https://github.com/HxX2/todocli";
    mainProgram = "todocli";
  };
}
