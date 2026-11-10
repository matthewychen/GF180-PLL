# make            -> run plain phase detector test
# make TEST=db    -> run deadband phase detector test
# make wave       -> run, then open GTKWave (add TEST=db for the deadband one)
TEST ?= db

ifeq ($(TEST),db)
TB = ./test/tb_phase_detector_db.sv
else
TB = ./test/tb_phase_detector.sv
endif

SRCS = $(TB) ./src/phase_detector.v

all:
	iverilog -g2012 -o tb.vvp $(SRCS)
	vvp tb.vvp

wave: all
	gtkwave tb.vcd

clean:
	rm -f tb.vvp tb.vcd

.PHONY: all wave clean