`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.07.2025
// Design Name: Vending Machine
// Module Name: VM
// Project Name: Vending Machine
// Target Devices: 
// Tool Versions: 
// Description: Vending machine with products A(₹5), B(₹10), C(₹20).
//              Accepts ₹5 and ₹10 coins. Returns actual change amount.
//              Cancel button refunds all inserted coins.
//
// Dependencies: None
//////////////////////////////////////////////////////////////////////////////////

module VM(
    input clk,
    input reset,
    input cancel,
    input [1:0] sel,    // 00 = A, 01 = B, 10 = C
    input [1:0] coin,   // 01 = ₹5, 10 = ₹10
    output reg pa,
    output reg pb,
    output reg pc,
    output reg [4:0] change   // 0, 5, 10, 15, 20
);

    // States based on total amount inserted
    parameter s0  = 3'b000,  // ₹0
              s5  = 3'b001,  // ₹5
              s10 = 3'b010,  // ₹10
              s15 = 3'b011,  // ₹15
              s20 = 3'b100;  // ₹20

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
            // Default outputs
            pa     <= 0;
            pb     <= 0;
            pc     <= 0;
            change <= 0;
            
            case (cs)
                // ₹5 inserted
                s5: begin
                    if (sel == 2'b00) begin
                        pa     <= 1;
                        change <= 0;
                    end
                    else begin
                        change <= 0; // Insufficient funds
                    end
                end

                // ₹10 inserted
                s10: begin
                    if (sel == 2'b00) begin
                        pa     <= 1;
                        change <= 5;
                    end
                    else if (sel == 2'b01) begin
                        pb     <= 1;
                        change <= 0;
                    end
                    else begin
                        change <= 0; // Insufficient funds
                    end
                end 
                
                // ₹15 inserted
                s15: begin
                    if (sel == 2'b00) begin
                        pa     <= 1;
                        change <= 10;
                    end
                    else if (sel == 2'b01) begin
                        pb     <= 1;
                        change <= 5;
                    end
                    else begin
                        change <= 0; // Insufficient funds
                    end
                end

                // ₹20 inserted
                s20: begin
                    if (sel == 2'b00) begin
                        pa     <= 1;
                        change <= 15;
                    end
                    else if (sel == 2'b01) begin
                        pb     <= 1;
                        change <= 10;
                    end
                    else if (sel == 2'b10) begin
                        pc     <= 1;
                        change <= 0;
                    end
                end     
            endcase

            // Cancel logic: return inserted money
            if (cancel) begin
                pa <= 0;
                pb <= 0;
                pc <= 0;
                case (cs)
                    s5:  change <= 5;
                    s10: change <= 10;
                    s15: change <= 15;
                    s20: change <= 20;
                    default: change <= 0;
                endcase
            end
        end
    end

endmodule
