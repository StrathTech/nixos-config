let
  inherit (builtins) listToAttrs map;
  as-list = [
    { mac = "00:23:24:01:a3:9b"; name = "umbreon"; disk-ok = true; }
    { mac = "00:23:24:01:9c:f7"; name = "sylveon"; disk-ok = true; }
    { mac = "00:23:24:01:a3:0f"; name = "vaporeon"; disk-ok = true;}
    { mac = "00:0f:fe:ce:72:5c"; name = "jolteon"; disk-ok = true; }
    { mac = "00:23:24:33:26:3c"; name = "lucario"; disk-ok = true; }
    { mac = "00:23:24:07:a3:14"; name = "flareon"; disk-ok = true; }
    { mac = "00:23:24:01:a3:5c"; name = "glaceon"; disk-ok = true; }
    # eevee is broken, espeon seems to be missing. Investigate.

    # Temporarily netbooting as lab machine
    { mac = "00:30:48:72:4b:c4"; name = "alakazam"; disk-ok = true; }
  ];
  by-field = field: list: listToAttrs (map (x: {name = x.${field}; value = x;}) list);
in {
  inherit as-list;
  by-mac = by-field "mac" as-list;
  by-name = by-field "name" as-list;
}
