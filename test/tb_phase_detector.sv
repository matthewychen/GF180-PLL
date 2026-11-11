`default_nettype none
`timescale 1ns / 1ps
 
module tb ();
 
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
  end
 
  /* Phase Detector Logic
     ref (clk) leads feedback  -> early = 0 (late)
     ref (clk) lags feedback   -> early = 1 (early)
  */
 
  reg  clk;
  reg  rst_n;
  reg  fb_clk;
  wire early;
 
  phase_detector uut (
    .clk    (clk),
    .fb_clk (fb_clk),
    .rst_n  (rst_n),
    .early  (early)
  );
 
  parameter CLK_PERIOD = 20;          // ns
  localparam HALF = CLK_PERIOD / 2;
 
  always #(HALF) clk = ~clk;
 
  integer errors = 0;
  integer checks = 0;
 
  task apply_reset(input int unsigned cycles = 5);
    $display("[%0t] | Reset asserted...", $time);
    rst_n = 1'b0;
    repeat (cycles) @(posedge clk);
    rst_n = 1'b1;
    $display("[%0t] | Reset deasserted...", $time);
  endtask
 
  initial begin
    clk    = 0;
    fb_clk = 0;
    rst_n  = 1;
    #5;
    apply_reset(5);
 
    for (int d = 1; d < CLK_PERIOD; d++) begin
      if (d == HALF) continue;         // 180 deg: fb edge coincides with clk edge (race)
 
      fb_clk = 0;
      @(posedge clk);                  // align to a ref rising edge
      #(d) fb_clk = 1;                 // fb rises d ns after ref
 
      fork
        // feedback clock: same frequency, offset by d
        repeat (2 * 6 - 1) #(HALF) fb_clk = ~fb_clk;
 
        // check right after each ref edge (skip the first, it may be stale)
        begin
          @(posedge clk);
          repeat (4) begin
            @(posedge clk); #1;
            checks++;
            if (early !== (d > HALF)) begin
              errors++;
              $display("FAIL d=%0d ns: early=%b expected=%b", d, early, (d > HALF));
            end
          end
        end
      join
 
      $display("Offset %2d / %0d ns -> %s (expected %s)", d, CLK_PERIOD, early ? "early" : "late ", (d > HALF) ? "early" : "late ");
    end
 
    if (errors == 0) $display("PASS: %0d checks", checks);
    else             $display("FAIL: %0d / %0d checks", errors, checks);
    $finish;
  end
 
endmodule