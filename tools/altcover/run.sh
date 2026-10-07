#!/usr/bin/env bash
# altcover
set -uo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
. "$REPO_ROOT/tools/_skip.sh"

# Measured with altcover.global 8.8.173 exactly as the runner drives it (--save --inplace on tests/OrderKit.Tests/bin, then `altcover Runner -- dotnet test`): 21/21 passed, NCover report written. ai-testable-platform v1.0.5 worker (runner: altcover).
require_cmd dotnet
OUT="$REPO_ROOT/reports/altcover"; mkdir -p "$OUT"
cd "$REPO_ROOT"
require_cmd altcover
dotnet restore OrderKit.sln --nologo -v quiet && dotnet build OrderKit.sln --no-restore --nologo -v quiet || exit $RC_FAIL
BIN="$REPO_ROOT/tests/OrderKit.Tests/bin/Debug/net10.0"; rm -rf "$BIN/__Saved"
altcover --save "--report=$OUT/altcover.xml" --reportFormat=NCover '--assemblyFilter=.*\.Tests$' "--inputDirectory=$BIN" --inplace || exit $RC_FAIL
altcover Runner "--recorderDirectory=$BIN" --executable=dotnet -- test "$BIN/OrderKit.Tests.dll" --nologo -v minimal || exit $RC_FAIL
exit $RC_OK
