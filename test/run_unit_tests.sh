#!/usr/bin/env bash
# Run every block-level Verilog testbench in test/.
#
# Convention (see test/README.md):
#   - Testbench file:  test/tb_<block>.v
#   - Top module name: tb_<block>          (must match the file name)
#   - It is compiled together with every file in src/, so it can
#     instantiate any module there.
#   - It must print a line that is exactly "PASS" on success, and call
#     $fatal (or print anything else) on failure.
#
# Usage (from anywhere):
#   test/run_unit_tests.sh              # run all testbenches
#   test/run_unit_tests.sh lock_detector   # run only tb_lock_detector.v
#
# Waveforms (.vcd) are written to test/, next to the testbench.

set -u

TEST_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_DIR="$(cd "$TEST_DIR/../src" && pwd)"
BUILD_DIR="$TEST_DIR/sim_build/unit"
TIMEOUT="${UNIT_TEST_TIMEOUT:-300}"   # seconds per testbench

mkdir -p "$BUILD_DIR"
shopt -s nullglob

# Pick testbenches: all tb_*.v, or the ones named on the command line.
# tb.v (the cocotb top-level harness) is deliberately excluded.
if [ $# -gt 0 ]; then
    tbs=()
    for name in "$@"; do
        name="${name#tb_}"; name="${name%.v}"
        tbs+=("$TEST_DIR/tb_${name}.v")
    done
else
    tbs=("$TEST_DIR"/tb_*.v)
fi

if [ ${#tbs[@]} -eq 0 ]; then
    echo "No testbenches found (expected test/tb_<block>.v)."
    exit 1
fi

src_files=("$SRC_DIR"/*.v)
pass=0
fail=0
summary=""

for tb in "${tbs[@]}"; do
    name="$(basename "$tb" .v)"
    log="$BUILD_DIR/$name.log"
    vvp_file="$BUILD_DIR/$name.vvp"

    if [ ! -f "$tb" ]; then
        result="FAIL (file not found)"
    elif ! iverilog -g2012 -Wall -s "$name" -o "$vvp_file" "$tb" "${src_files[@]}" >"$log" 2>&1; then
        result="FAIL (compile error)"
    else
        # Run from test/ so $dumpfile paths land next to the testbench.
        (cd "$TEST_DIR" && timeout "$TIMEOUT" vvp -n "$vvp_file") >>"$log" 2>&1
        rc=$?
        if [ $rc -eq 124 ]; then
            result="FAIL (timed out after ${TIMEOUT}s)"
        elif [ $rc -ne 0 ]; then
            result="FAIL (exit code $rc)"
        elif ! grep -qx "PASS" "$log"; then
            result="FAIL (no PASS line)"
        else
            result="PASS"
        fi
    fi

    if [ "$result" = "PASS" ]; then
        pass=$((pass + 1))
        echo "PASS  $name"
    else
        fail=$((fail + 1))
        echo "FAIL  $name  -- $result"
        echo "----- $log -----"
        tail -n 40 "$log"
        echo "-----"
    fi
    summary+="| \`$name\` | $result |"$'\n'
done

echo
echo "$pass passed, $fail failed"

# Nice table on the GitHub Actions run page.
if [ -n "${GITHUB_STEP_SUMMARY:-}" ]; then
    {
        echo "## Unit tests: $pass passed, $fail failed"
        echo
        echo "| Testbench | Result |"
        echo "|---|---|"
        printf "%s" "$summary"
    } >>"$GITHUB_STEP_SUMMARY"
fi

[ $fail -eq 0 ]
