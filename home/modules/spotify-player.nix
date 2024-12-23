let
  device_name = "nixfred spotify-player"; # TODO remove hardcoded name, maybe move to module system
in
{
  programs.spotify-player = {
    enable = true;
    settings = {
      enable_notify = false;
      default_device = device_name;
      client_id = "f999b60be23f46c394ba8c738deea165";

      device = {
        name = device_name;
        device_type = "computer";
        volume = 50;
      };
    };
  };
}
