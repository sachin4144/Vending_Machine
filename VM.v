`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.07.2025 10:50:40
// Design Name: 
// Module Name: VM
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module VM(
    input clk,
    input reset,
    input cancel,
    input [1:0] sel,
    input [1:0] coin,
    output reg pa,
    output reg pb,
    output reg pc,
    output reg change
    );
    
    parameter s0=3'b000, s5=3'b001, s10=3'b010, s15=3'b011, s20=3'b100;
    reg [2:0] cs, ns;
    
    // State register
    always @(posedge clk or posedge reset) begin 
        if (reset) 
            cs <= s0;
        else 
            cs <= ns;   
    end
    
    // Next state logic
    always @(*) begin 
        case(cs) 
            s0: begin
                if (coin == 2'b01)
                    ns = s5;
                else if (coin == 2'b10)
                    ns = s10;
                else
                    ns = s0;
            end

            s5: begin
                if (coin == 2'b01)
                    ns = s10;
                else if (coin == 2'b10)
                    ns = s15;
                else if (cancel) 
                    ns = s0;
                else
                    ns = s5;
            end

            s10: begin
                if (coin == 2'b01)
                    ns = s15;
                else if (coin == 2'b10)
                    ns = s20;
                else if (cancel) 
                    ns = s0;
                else
                    ns = s10;
            end

            s15: begin
                if (coin == 2'b01)
                    ns = s20;
                else if (cancel) 
                    ns = s0;
                else
                    ns = s15;
            end

            s20: begin
                if (cancel) 
                    ns = s0;
                else
                    ns = s20;
            end

            default: ns = s0;   
        endcase
    end
    
    // Output logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pa     <= 0;
            pb     <= 0;
            pc     <= 0;
            change <= 0;
        end else begin
            // Default values (avoid latches)
            pa     <= 0;
            pb     <= 0;
            pc     <= 0;
            change <= 0;
            
            case (cs)
                s5: begin
                    if (sel == 2'b00) begin
                        pa     <= 1;  // Product A (Rs. 5)
                        change <= 0;  
                    end
                end

                s10: begin
                    if (sel == 2'b00) begin
                        pa     <= 1;  // Product A (Rs. 5)
                        change <= 1;  
                    end
                    else if (sel == 2'b01) begin
                        pb     <= 1;  // Product B (Rs. 10)
                        change <= 0;  
                    end
                end 
                
                s15: begin
                    if (sel == 2'b01) begin
                        pb     <= 1;  // Product B (Rs. 10)
                        change <= 1;  
                    end
                end

                s20: begin
                    if (sel == 2'b00) begin
                        pa     <= 1;  // Product A (Rs. 5)
                        change <= 1;  
                    end
                    else if (sel == 2'b01) begin
                        pb     <= 1;  // Product B (Rs. 10)
                        change <= 1;  
                    end
                    else if (sel == 2'b10) begin
                        pc     <= 1;  // Product C  (Rs.20 )
                        change <= 0;  
                    end
                end     
            endcase

            // Cancel logic: If cancel is pressed, return change
            if (cancel)
                change <= 1;
        end
    end

endmodule
