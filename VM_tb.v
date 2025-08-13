`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.07.2025 12:07:38
// Design Name: 
// Module Name: VM_tb
// Project Name: Vending Machine
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



module VM_tb();

    reg clk;
    reg reset;
    reg cancel;
    reg [1:0] sel;
    reg [1:0] coin;
    wire pa, pb, pc;
    wire [4:0] change;  // Shows actual change in Rs

    // Instantiate the vending machine
    VM uut (
        .clk(clk),
        .reset(reset),
        .cancel(cancel),
        .sel(sel),
        .coin(coin),
        .pa(pa),
        .pb(pb),
        .pc(pc),
        .change(change)
    );

    // Clock generation: 10 ns period
    always #5 clk = ~clk;

    // Task to simulate coin insertion
    task insert_coin(input [1:0] c);
        begin
            coin = c;
            #10 coin = 2'b00; // Release after 1 clock
        end
    endtask

    // Task to select a product
    task select_product(input [1:0] s);
        begin
            sel = s;
            #10 sel = 2'b00; // Release
        end
    endtask

    // Task to press cancel
    task press_cancel();
        begin
            cancel = 1;
            #10 cancel = 0;
        end
    endtask

    initial begin
        // Initial values
        clk = 0;
        reset = 1;
        cancel = 0;
        sel = 0;
        coin = 0;

        #10 reset = 0; // Release reset

        // ====== TEST 1: Insert Rs.5 → Buy Product A (₹5) ======
        insert_coin(2'b01);  
        select_product(2'b00); 
        #20;

        // ====== TEST 2: Insert Rs.10 → Buy Product A (₹5) ======
        insert_coin(2'b10);  
        select_product(2'b00); // Expect ₹5 change
        #20;

        // ====== TEST 3: Insert Rs.10 → Buy Product B (₹10) ======
        insert_coin(2'b10);  
        select_product(2'b01); // Expect ₹0 change
        #20;

        // ====== TEST 4: Insert Rs.15 → Buy Product B (₹10) ======
        insert_coin(2'b10);  
        insert_coin(2'b01);  
        select_product(2'b01); // Expect ₹5 change
        #20;

        // ====== TEST 5: Insert Rs.20 → Buy Product C (₹20) ======
        insert_coin(2'b10);  
        insert_coin(2'b10);  
        select_product(2'b10); // Expect ₹0 change
        #20;

        // ====== TEST 6: Cancel after Rs.15 inserted ======
        insert_coin(2'b10);  
        insert_coin(2'b01);  
        press_cancel();       // Expect ₹15 change
        #20;

        // ====== TEST 7: Cancel after Rs.5 inserted ======
        insert_coin(2'b01);  
        press_cancel();       // Expect ₹5 change
        #20;

        $finish;
    end

endmodule
