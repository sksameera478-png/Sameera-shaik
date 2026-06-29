module traffic_light_priority(
    input clk, rst,           // 1Hz clock, active high reset
    input emergency_NS,       // Priority for North-South
    input emergency_EW,       // Priority for East-West  
    output reg [2:0] NS_light, // NS: [Red, Yellow, Green]
    output reg [2:0] EW_light  // EW: [Red, Yellow, Green]
);

    // Light encoding: 3'b100 = Red, 3'b010 = Yellow, 3'b001 = Green
    parameter RED=3'b100, YELLOW=3'b010, GREEN=3'b001;
    
    // FSM States
    parameter S_NS_GREEN = 2'b00;  // NS Green, EW Red
    parameter S_NS_YELLOW= 2'b01;  // NS Yellow, EW Red  
    parameter S_EW_GREEN = 2'b10;  // EW Green, NS Red
    parameter S_EW_YELLOW= 2'b11;  // EW Yellow, NS Red
    
    reg [1:0] state, next_state;
    reg [3:0] timer; // Counts up to 10s for green, 3s for yellow
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            state <= S_NS_GREEN;
            timer <= 0;
        end
        else begin
            // Priority override: force yellow transition first
            if(emergency_NS && state != S_NS_GREEN && state != S_NS_YELLOW) begin
                state <= S_NS_YELLOW; 
                timer <= 0;
            end
            else if(emergency_EW && state != S_EW_GREEN && state != S_EW_YELLOW) begin
                state <= S_EW_YELLOW; 
                timer <= 0;
            end
            // Normal timing
            else if(timer == 4'd9 && state == S_NS_GREEN ||   // 10s
                    timer == 4'd2 && state == S_NS_YELLOW ||  // 3s
                    timer == 4'd9 && state == S_EW_GREEN ||  // 10s
                    timer == 4'd2 && state == S_EW_YELLOW) begin  // 3s
                state <= next_state;
                timer <= 0;
            end
            else timer <= timer + 1;
        end
    end
    
    always @(*) begin
        case(state)
            S_NS_GREEN:  next_state = S_NS_YELLOW;
            S_NS_YELLOW: next_state = S_EW_GREEN;
            S_EW_GREEN:  next_state = S_EW_YELLOW;
            S_EW_YELLOW: next_state = S_NS_GREEN;
            default:     next_state = S_NS_GREEN;
        endcase
    end
    
    always @(*) begin
        case(state)
            S_NS_GREEN:  begin NS_light = GREEN;  EW_light = RED;    end
            S_NS_YELLOW: begin NS_light = YELLOW; EW_light = RED;    end
            S_EW_GREEN:  begin NS_light = RED;    EW_light = GREEN;  end
            S_EW_YELLOW: begin NS_light = RED;    EW_light = YELLOW; end
            default:     begin NS_light = RED;    EW_light = RED;    end
        endcase
    end
endmodule
