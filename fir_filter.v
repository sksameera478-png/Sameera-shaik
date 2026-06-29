module fir_filter(
    input clk, rst,
    input signed [7:0] x_in, // 8-bit input sample
    output reg signed [15:0] y_out // 16-bit output
);

    // Coefficients from MATLAB Q1.7 format
    parameter h0 = 8'sd13;
    parameter h1 = 8'sd48;
    parameter h2 = 8'sd48;
    parameter h3 = 8'sd13;

    // Delay line for input samples: x[n], x[n-1], x[n-2], x[n-3]
    reg signed [7:0] x0, x1, x2, x3;

    // Multiplier outputs
    wire signed [15:0] m0, m1, m2, m3;

    // Shift register for delay
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            x0 <= 0; x1 <= 0; x2 <= 0; x3 <= 0;
        end else begin
            x3 <= x2;
            x2 <= x1;
            x1 <= x0;
            x0 <= x_in;
        end
    end

    // Multiply: Direct Form FIR
    assign m0 = h0 * x0;
    assign m1 = h1 * x1;
    assign m2 = h2 * x2;
    assign m3 = h3 * x3;

    // Accumulate + output register
    always @(posedge clk or posedge rst) begin
        if(rst)
            y_out <= 0;
        else
            y_out <= m0 + m1 + m2 + m3;
    end

endmodule
