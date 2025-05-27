# When adding a new public key, make sure to run agenix
let
  timbits-nixfred = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMPsbSNv4ViBYXTIXSO/Hwu1MyGcQLwUW33WMSDzOQiU";
in
{
  "github.age".publicKeys = [
    timbits-nixfred
  ];
}
