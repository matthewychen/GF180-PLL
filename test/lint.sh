#!/usr/bin/env bash
# Lint every module in src/ with Verilator (-Wall).
#
# Every module in every file in src/ is linted as its own top. Submodules
# are pulled in from src/ by file name, so cross-module port mismatches are
# caught too. Keep each instantiated module in src/<module_name>.v.
# New files in src/ are picked up automatically - nothing to register.
#
# Usage (from anywhere):
#   test/lint.sh
#
# To silence a warning you have checked and accept, use an inline comment
# in the Verilog rather than editing this script, e.g.:
#   /* verilator lint_off UNUSEDSIGNAL */ ... /* verilator lint_on UNUSEDSIGNAL */

set -u

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../src" && pwd)"
shopt -s nullglob
src_files=("$SRC_DIR"/*.v)

# DECLFILENAME: Tiny Tapeout requires the top module to live in project.v,
#               so its name never matches the file name.
VERILATOR_FLAGS=(--lint-only -Wall -Wno-DECLFILENAME --timescale 1ns/1ps)

fail=0

# Verilator 5 (used in CI) rejects files without a final newline (EOFNEWLINE);
# Verilator 4 doesn't check, so check here to catch it locally too.
for f in "${src_files[@]}"; do
    if [ -s "$f" ] && [ -n "$(tail -c1 "$f")" ]; then
        echo "FAIL  $(basename "$f")  (missing newline at end of file)"
        fail=1
    fi
done

for f in "${src_files[@]}"; do
    # every "module <name>" in the file (a file may hold several modules)
    tops="$(sed -n -E 's/^[[:space:]]*module[[:space:]]+([A-Za-z_][A-Za-z0-9_$]*).*/\1/p' "$f")"
    if [ -z "$tops" ]; then
        echo "SKIP  $(basename "$f")  (no module found)"
        continue
    fi
    for top in $tops; do
        # Only this file on the command line; submodules are found in src/
        # by file name (-y), so module <name> must live in src/<name>.v.
        if out="$(verilator "${VERILATOR_FLAGS[@]}" -y "$SRC_DIR" --top-module "$top" "$f" 2>&1)"; then
            echo "OK    $(basename "$f")  ($top)"
        else
            echo "FAIL  $(basename "$f")  ($top)"
            echo "$out"
            fail=1
        fi
    done
done

exit $fail
