{ lib }:

let
  assignmentPattern = "^([A-Z_][A-Z0-9_]*)=(.*)$";

  parseLine =
    line:
    let
      match = builtins.match assignmentPattern line;
    in
    {
      name = builtins.elemAt match 0;
      value = builtins.elemAt match 1;
    };

  isAssignment = line: builtins.match assignmentPattern line != null;

  removeDisabled = variables: disabled: builtins.removeAttrs variables disabled;
in
{
  parse =
    contents: lib.listToAttrs (map parseLine (lib.filter isAssignment (lib.splitString "\n" contents)));

  applyOptions =
    {
      upstreamVariables,
      extraVariables ? { },
      overrides ? { },
      disabled ? [ ],
      enable ? true,
    }:
    if enable then removeDisabled (upstreamVariables // extraVariables // overrides) disabled else { };
}
