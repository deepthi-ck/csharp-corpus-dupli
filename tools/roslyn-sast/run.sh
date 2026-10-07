#!/usr/bin/env bash
# roslyn-sast
set -uo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
. "$REPO_ROOT/tools/_skip.sh"

# SecurityCodeScan.VS2019 5.6.7 loads through the same imported bundle and the security-code-scan SARIF is produced. It reports 0 SCS-specific rules here: the code has no ASP.NET taint sources, so the taint findings come from Semgrep. ai-testable-platform v1.0.5 worker (runner: security-code-scan).
require_cmd dotnet
OUT="$REPO_ROOT/reports/roslyn-sast"; mkdir -p "$OUT"
cd "$REPO_ROOT"
dotnet restore OrderKit.sln --nologo -v quiet || exit $RC_FAIL
dotnet build OrderKit.sln --no-restore -c Release -nologo -v quiet -p:TreatWarningsAsErrors=false "-p:ErrorLog=$OUT/scs.sarif,version=2.1" || exit $RC_FAIL
exit $RC_OK
