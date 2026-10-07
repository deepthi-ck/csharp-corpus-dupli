#!/usr/bin/env bash
# nuget-audit
set -uo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
. "$REPO_ROOT/tools/_skip.sh"

# Paket pins are mirrored as PackageReference, so a plain `dotnet restore` (the worker has no paket tool) resolves them. Measured: `dotnet list package --vulnerable --include-transitive --format json` over 6 projects reports Newtonsoft.Json 9.0.1 (High), System.Net.Http 4.3.0 (High), System.Text.RegularExpressions 4.3.0 (High), BouncyCastle 1.8.1 (Moderate). ai-testable-platform v1.0.5 worker (runner: dotnet-sca).
require_cmd dotnet
OUT="$REPO_ROOT/reports/nuget-audit"; mkdir -p "$OUT"
cd "$REPO_ROOT"
dotnet restore OrderKit.sln --nologo -v quiet || exit $RC_FAIL
dotnet list OrderKit.sln package --vulnerable --include-transitive --format json --no-restore > "$OUT/vulnerable.json" || exit $RC_FAIL
exit $RC_OK
