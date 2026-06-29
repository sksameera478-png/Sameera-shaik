`timescale 1ns/1ps
module tb_fir_filter;
    reg clk, rst;
    reg signed [7:0] x_in;
    wire signed [15:0] y_out;

    fir_filter uut(clk, rst, x_in, y_out);

    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end

    initial begin
        $monitor("Time=%0t | x_in=%d | y_out=%d", $time, x_in, y_out);
        rst = 1; x_in = 0;
        #10 rst = 0;

        // Impulse response test: input = 1,0,0,0...
        #10 x_in = 8'sd100; // Impulse of amplitude 100
        #10 x_in = 8'sd0;
        #10 x_in = 8'sd0;
        #10 x_in = 8'sd0;
        #10 x_in = 8'sd0;

        // Step response test
        #20 x_in = 8'sd50; // Step input
        #100;

        $finish;
    end
endmodule
