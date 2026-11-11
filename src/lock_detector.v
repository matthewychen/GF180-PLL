`timescale 1ns/1ps
`default_nettype none

// Lock detector: watches the PFD's EARLY decisions and raises lock once the
// loop has settled. Observer only - nothing in the loop reads lock.
// Spec: assert after 256 cycles with no run of more than 8 identical decisions.

module lock_detector #(
    parameter MAX_RUN     = 8,    // longest run of identical decisions still allowed
    parameter LOCK_CYCLES = 256   // quiet cycles needed before lock asserts
) (
    input  wire clk,    // 10 MHz reference
    input  wire rst_n,  // active-low reset, clears lock
    input  wire early,  // from PFD: 1 = VCO too fast, 0 = too slow
    output wire lock    // to uo_out[1]
);

    reg                               last_bit;
    reg [$clog2(MAX_RUN+1)-1:0]       length_counter;  // = current run length (1..MAX_RUN)
    reg [$clog2(LOCK_CYCLES+1)-1:0]   quiet_counter;   // cycles since last over-long run

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            last_bit       <= 1'b0;
            length_counter <= 0;
            quiet_counter  <= 0;
        end else begin
            last_bit <= early;

            if (early == last_bit) begin

                if (length_counter == MAX_RUN) begin
                    quiet_counter <= 0;

                end else begin
                    length_counter <= length_counter + 1;
                    if (quiet_counter != LOCK_CYCLES)
                        quiet_counter <= quiet_counter + 1;
                end

            end else begin
                length_counter <= 1;
                if (quiet_counter != LOCK_CYCLES)
                    quiet_counter <= quiet_counter + 1;
            end
        end
    end

    assign lock = (quiet_counter == LOCK_CYCLES);

endmodule

`default_nettype wire
