`timescale 1ns/1ps
//==============================================================
// BAUD RATE GENERATOR
//==============================================================

module baud_rate(

    input clk,
    input rst,

    output tx_en,
    output rx_en

);

reg [12:0] tx_counter;
reg [9:0]  rx_counter;

always @(posedge clk) begin

    if(rst)
        tx_counter <= 0;

    else if(tx_counter == 5208)
        tx_counter <= 0;

    else
        tx_counter <= tx_counter + 1'b1;

end


always @(posedge clk) begin

    if(rst)
        rx_counter <= 0;

    else if(rx_counter == 325)
        rx_counter <= 0;

    else
        rx_counter <= rx_counter + 1'b1;

end


assign tx_en = (tx_counter == 0);
assign rx_en = (rx_counter == 0);

endmodule


