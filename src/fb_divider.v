`timescale 1ns/1ps
`default_nettype none

// Purpose of this feedback divider is to divide the VCO clock by 8 to generate a feedback clock for the PLL (and output reference)
// The input clock is 80 MHz, and the output clock is 10 MHz with a 50% duty cycle. 

module fb_divider (
    input  wire vco_clk,  // clock from vco (80 MHz)
    input  wire rst_n,    // active-low reset
    output wire fb_clk    // output clock at 10MHz
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




