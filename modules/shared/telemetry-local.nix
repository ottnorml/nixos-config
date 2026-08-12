{
  # CocoIndex: disable release-only anonymous usage tracking for the Python package.
  # Source: https://cocoindex.io/docs/about/telemetry/
  COCOINDEX_DISABLE_USAGE_TRACKING = "1";

  # OpenSpec CLI: explicitly disable anonymous usage analytics.
  # Source: https://github.com/Fission-AI/OpenSpec/blob/main/src/telemetry/index.ts
  OPENSPEC_TELEMETRY = "0";

  # Semgrep: disable automatic metrics collection.
  # Source: https://docs.semgrep.dev/metrics/#automatic-collection-opt-in-and-opt-out
  SEMGREP_SEND_METRICS = "off";

  # Serena: disable usage reporting from the coding assistant.
  # Source: https://oraios.github.io/serena/02-usage/050_configuration.html#usage-reporting
  SERENA_USAGE_REPORTING = "false";

  # Superpowers: disable Visual Companion telemetry.
  # Source: https://github.com/obra/superpowers#visual-companion-telemetry
  SUPERPOWERS_DISABLE_TELEMETRY = "1";
}
