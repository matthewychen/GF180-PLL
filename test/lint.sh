#!/usr/bin/env bash
# Lint every module in src/ with Verilator (-Wall).
#
# Each file in src/ is linted with its own module as the top, together with
# all other src/ files, so cross-module port mismatches are caught too.
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
for f in "${src_files[@]}"; do
    # first "module <name>" in the file
    top="$(sed -n -E 's/^[[:space:]]*module[[:space:]]+([A-Za-z_][A-Za-z0-9_$]*).*/\1/p' "$f" | head -n 1)"
    if [ -z "$top" ]; then
        echo "SKIP  $(basename "$f")  (no module found)"
        continue
    fi
    if out="$(verilator "${VERILATOR_FLAGS[@]}" --top-module "$top" "${src_files[@]}" 2>&1)"; then
        echo "OK    $(basename "$f")  ($top)"
    else
        echo "FAIL  $(basename "$f")  ($top)"
        echo "$out"
        fail=1
    fi
done

exit $fail
