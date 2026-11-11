`default_nettype none
`timescale 1ns / 1ps

module tb_phase_detector_db ();

  initial begin
    $dumpfile("tb_phase_detector_db.vcd");
    $dumpvars(0, tb_phase_detector_db);
  end

  /* Phase Detector Logic
     fb lags ref by more than DEADBAND  -> late  = 1
     fb leads ref by more than DEADBAND -> early = 1
     within DEADBAND                    -> early = late = 0
  */

  reg  sample_clk;
  reg  clk;
  reg  rst_n;
  reg  fb_clk;
  wire early;
  wire late;

  parameter CLK_PERIOD = 20;          // ns
  parameter DEADBAND   = 2;           // sample_clk ticks (1 ns each)
  localparam HALF = CLK_PERIOD / 2;

  phase_detector_deadband #(.DEADBAND(DEADBAND)) uut (
    .sample_clk (sample_clk),
    .clk        (clk),
    .fb_clk     (fb_clk),
    .rst_n      (rst_n),
    .early      (early),
    .late       (late)
  );

  always #(HALF) clk = ~clk;
  always #0.5 sample_clk = ~sample_clk;   // 1 ns, edges on x.5 ns: never races clk/fb

  integer errors = 0;
  integer checks = 0;

  // fb rises d ns after ref: lags by d (d < HALF) or leads by CLK_PERIOD - d (d > HALF)
  function automatic string expected(input int d);
    if      (d < HALF && d > DEADBAND)               return "late ";
    else if (d > HALF && CLK_PERIOD - d > DEADBAND)  return "early";
    else                                             return "none ";
  endfunction

  function automatic string got();
    case ({early, late})
      2'b10:   return "early";
      2'b01:   return "late ";
      2'b00:   return "none ";
      default: return "BOTH ";
    endcase
  endfunction

  task apply_reset(input int unsigned cycles = 5);
    $display("[%0t] | Reset asserted...", $time);
    rst_n = 1'b0;
    repeat (cycles) @(posedge clk);
    rst_n = 1'b1;
    $display("[%0t] | Reset deasserted...", $time);
  endtask

  initial begin
    sample_clk = 0;
    clk        = 0;
    fb_clk     = 0;
    rst_n      = 1;
    #5;
    apply_reset(5);

    for (int d = 1; d < CLK_PERIOD; d++) begin
      if (d != HALF) begin            // 180 deg: lead or lag is ambiguous

      // The detector pairs each edge with the next edge of the other clock,
      // so reset it and release it while clk and fb_clk are both low, just
      // before the pair we want it to measure:
      //   d < HALF: ref at P,     fb at P + d  (fb lags)
      //   d > HALF: fb  at P + d, ref at P + T (fb leads)
      fb_clk = 0;
      rst_n  = 0;
      @(negedge clk);
      if (d < HALF) rst_n = 1;
      @(posedge clk);                  // P: align to a ref rising edge

      fork
        // feedback clock: same frequency, rises d ns after ref
        begin
          #(d) fb_clk = 1;
          repeat (2 * 6 - 1) #(HALF) fb_clk = ~fb_clk;
        end

        // release reset for the lead case (clk and fb_clk are both low here)
        begin
          if (d > HALF) #(HALF) rst_n = 1;
        end

        // check right after each ref edge (skip the first, it may be stale)
        begin
          @(posedge clk);
          repeat (4) begin
            @(posedge clk); #1;
            checks++;
            if (got() != expected(d)) begin
              errors++;
              $display("FAIL d=%0d ns: got %s expected %s", d, got(), expected(d));
            end
          end
        end
      join

      $display("Offset %2d / %0d ns -> %s (expected %s)", d, CLK_PERIOD, got(), expected(d));
      end
    end

    if (errors == 0) begin
      $display("%0d checks passed", checks);
      $display("PASS");
      $finish;
    end else begin
      $fatal(1, "FAIL: %0d / %0d checks", errors, checks);
    end
  end

endmodule