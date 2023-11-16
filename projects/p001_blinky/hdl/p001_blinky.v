`default_nettype none


module p001_blinky (
   output wire b1_gpio3p
);

wire clk_160mhz;

PF_OSC_C0 pf_osc_c0_inst (
   .RCOSC_160MHZ_GL(clk_160mhz)
);

reg [28:0] counter;
always @(posedge clk_160mhz) begin
   counter <= counter + 1;
end

assign b1_gpio3p = counter[28];

endmodule
