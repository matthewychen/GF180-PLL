`default_nettype none

// Feedback divider: divides the VCO clock by 8.
// 80 MHz in, 10 MHz out, 50% duty cycle.
// vco_clk must already be level-shifted to the 1.8 V digital domain.
module fb_divider (
    input  wire vco_clk,  // from VCO, through level shifter
    input  wire rst_n,    // active-low reset (TT rst_n)
    output wire fb_clk    // to BB-PFD and to uo_out[0]
);

    reg [2:0] count;

    // Async reset: rst_n is not synchronous to the VCO clock
    always @(posedge vco_clk or negedge rst_n) begin
        if (!rst_n)
            count <= 3'd0;
        else
            count <= count + 3'd1;
    end

    // MSB toggles every 4 VCO cycles, so it is VCO / 8
    assign fb_clk = count[2];

endmodule

`default_nettype wire