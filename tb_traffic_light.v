`timescale 1ns/1ps
module tb_traffic_light;
    reg clk, rst, emergency_NS, emergency_EW;
    wire [2:0] NS_light, EW_light;
    
    traffic_light_priority uut(clk, rst, emergency_NS, emergency_EW, NS_light, EW_light);
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period = 100MHz for fast sim. Use #500000000 for 1Hz
    end
    
    initial begin
        $monitor("Time=%0t | NS=%b EW=%b | Emergency_NS=%b EW=%b", 
                 $time, NS_light, EW_light, emergency_NS, emergency_EW);
        
        rst = 1; emergency_NS = 0; emergency_EW = 0;
        #10 rst = 0;
        
        #100; // Normal cycle
        emergency_EW = 1; #20 emergency_EW = 0; // EW emergency
        #200;
        emergency_NS = 1; #20 emergency_NS = 0; // NS emergency  
        #300;
        $finish;
    end
endmodule
