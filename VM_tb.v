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


module VM_tb;
reg clk,reset,cancel;
reg [1:0] coin ,sel;

wire pa,pb,pc,change;

VM uut(.clk(clk),.reset(reset),.cancel(cancel),.coin(coin),.sel(sel),.pa(pa),.pb(pb),.pc(pc),.change(change));

always #5 clk=~clk;

initial begin

clk=0;
reset=0;
cancel=0;
coin=2'b00;
sel=2'b00;

#20 reset=0;

#10 coin=2'b01;
#10 sel=2'b00;
#10 coin=2'b00;
#20;

#10 coin=2'b10;
#10 sel=2'b01;
#20;

#10 coin=2'b01;
#10 coin=2'b01;
#10 sel=2'b00;
#20

#10 coin=2'b10;
#10 coin=2'b10;
#10 sel=2'b10;
#20

#50 $finish;
end

initial begin
    $monitor("Time = %d, Coin = %b, Sel = %b, Cancel = %b, pa = %b, pb= %b, pc = %b, Change = %b", 
             $time, coin, sel, cancel, pa, pb, pc, change);
end

endmodule
