# When adding a new public key, make sure to run agenix
let
  # Public user keys
  timbits-nixfred = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMPsbSNv4ViBYXTIXSO/Hwu1MyGcQLwUW33WMSDzOQiU";

  # Public system keys
  nixfred = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFhHhFGOlTbVupG8ZzDn68OswXCtX23jcvjAJkORi5YP";
in
{
  "test.age".publicKeys = [
    nixfred
    timbits-nixfred
  ];
}
