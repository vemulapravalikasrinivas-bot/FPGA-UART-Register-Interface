`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.05.2026 16:03:50
// Design Name: 
// Module Name: uart_communication_tb
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


module uart_communication_tb;

reg clk;
reg rst;

reg rx;
reg rdy_clr;

wire tx;

uart_top DUT(
    .clk(clk),
    .rst(rst),
    .rx(rx),
    .rdy_clr(rdy_clr),
    .tx(tx)
);


//--------------------------------------------------
// Clock
//--------------------------------------------------

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end


//--------------------------------------------------
// UART Bit Time
//--------------------------------------------------

// For simulation only
parameter BIT_TIME = 52080;


//--------------------------------------------------
// Send UART Byte
//--------------------------------------------------

task uart_send_byte;

input [7:0] data;

integer i;

begin

    //------------------------------------------------
    // Start Bit
    //------------------------------------------------

    rx = 0;
    #(BIT_TIME);

    //------------------------------------------------
    // Data Bits
    //------------------------------------------------

    for(i=0;i<8;i=i+1)
    begin
        rx = data[i];
        #(BIT_TIME);
    end

    //------------------------------------------------
    // Stop Bit
    //------------------------------------------------

    rx = 1;
    #(BIT_TIME);

end

endtask


//--------------------------------------------------
// Test Sequence
//--------------------------------------------------

initial begin

    rx = 1;
    rst = 1;
    rdy_clr = 0;

    #100;

    rst = 0;

    //------------------------------------------------
    // WRITE COMMAND
    // W 08 01
    //------------------------------------------------

    uart_send_byte("W");
    uart_send_byte(" ");
    uart_send_byte("0");
    uart_send_byte("8");
    uart_send_byte(" ");
    uart_send_byte("0");
    uart_send_byte("1");

    #2000000;

    //------------------------------------------------
    // READ COMMAND
    // R 08
    //------------------------------------------------

   uart_send_byte("R");
uart_send_byte(" ");
uart_send_byte("0");
uart_send_byte("8");
uart_send_byte(" ");   // <-- missing space
uart_send_byte("0");
uart_send_byte("0");
    #10000000;
	$finish;
  

end


//--------------------------------------------------
// Monitor Internal Signals
//--------------------------------------------------

initial begin

$monitor(
"TIME=%0t wr=%b rd=%b addr=%h data=%h rd_data=%h",
$time,
DUT.wr_en,
DUT.rd_en,
DUT.address,
DUT.data,
DUT.rd_data
);

end
  
  always @(posedge clk)
begin
    if(DUT.tx_wr_en)
        $display("TX BYTE = %c (%h)",
                 DUT.tx_data,
                 DUT.tx_data);
  
end

  always @(posedge clk)
begin
    if(DUT.rdy)
        $display("RX BYTE = %c (%h)",
                 DUT.rx_data_out,
                 DUT.rx_data_out);
end
  
  always @(posedge clk)
begin
    if(DUT.cmd_valid)
        $display("CMD=%c%c%c%c%c%c%c",
                 DUT.command[0],
                 DUT.command[1],
                 DUT.command[2],
                 DUT.command[3],
                 DUT.command[4],
                 DUT.command[5],
                 DUT.command[6]);
end
 
endmodule
