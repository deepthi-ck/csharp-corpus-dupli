#!/usr/bin/env bash
# stryker
set -uo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
. "$REPO_ROOT/tools/_skip.sh"

# Requires Stryker.NET >= 5.0.0. Measured: 5.0.0 with --test-project tests/OrderKit.Tests: 519 mutants, score 24.09%, mutation-report.json written. Stryker.NET 4.0.0 (the platform catalog pin) aborts with 'Internal error due to compile error' because its bundled Roslyn predates C# 14 (field keyword, null-conditional assignment) used by the byte-identical domain fixture. The platform pin must move to 5.0.0. ai-testable-platform v1.0.5 worker (runner: stryker-net).
require_cmd dotnet
OUT="$REPO_ROOT/reports/stryker"; mkdir -p "$OUT"
cd "$REPO_ROOT"
command -v dotnet-stryker >/dev/null 2>&1 || dotnet stryker --version >/dev/null 2>&1 || missing "dotnet-stryker (>= 5.0.0) is not installed"
dotnet restore OrderKit.sln --nologo -v quiet || exit $RC_FAIL
dotnet stryker --reporter json --reporter cleartext --output "$OUT" --test-project tests/OrderKit.Tests/OrderKit.Tests.csproj || exit $RC_FAIL
exit $RC_OK
