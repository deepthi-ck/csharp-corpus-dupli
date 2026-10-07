#!/usr/bin/env bash
# coverlet
set -uo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
. "$REPO_ROOT/tools/_skip.sh"

# Test project now carries Microsoft.NET.Test.Sdk 17.12.0, NUnit3TestAdapter 4.6.0, coverlet.collector 6.0.2. Measured: `dotnet test --collect:"XPlat Code Coverage"` with the platform runsettings, 21/21 passed, Cobertura line 47.5%, branch 38.9%. Feeds cs_coverage_delta. ai-testable-platform v1.0.5 worker (runner: coverlet).
require_cmd dotnet
OUT="$REPO_ROOT/reports/coverlet"; mkdir -p "$OUT"
cd "$REPO_ROOT"
dotnet restore OrderKit.sln --nologo -v quiet || exit $RC_FAIL
dotnet test OrderKit.sln --no-restore --nologo "--collect:XPlat Code Coverage" --results-directory "$OUT" -v minimal || exit $RC_FAIL
exit $RC_OK
