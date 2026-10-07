#!/usr/bin/env bash
# roslyn-metrics
set -uo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
. "$REPO_ROOT/tools/_skip.sh"

# Directory.Build.props imports the platform analyzer bundle (/opt/tools/whitebox/csharp/Directory.Analyzers.props), so StyleCop + SonarAnalyzer.CSharp + NetAnalyzers are in the restore graph. Measured on SDK 10.0.303: build clean, SARIF 75 results (SA 68, S 3, CA 4). ai-testable-platform v1.0.5 worker (runner: roslyn-analyzers, sonar-cs).
require_cmd dotnet
OUT="$REPO_ROOT/reports/roslyn-metrics"; mkdir -p "$OUT"
cd "$REPO_ROOT"
dotnet restore OrderKit.sln --nologo -v quiet || exit $RC_FAIL
dotnet build OrderKit.sln --no-restore -c Release -nologo -v quiet -p:TreatWarningsAsErrors=false "-p:ErrorLog=$OUT/roslyn.sarif,version=2.1" -p:AnalysisMode=AllEnabledByDefault || exit $RC_FAIL
exit $RC_OK
