`timescale 1ns/1ps
	module uart_top(
    input clk,
    input rst,
    input rx,
    input rdy_clr,

    output tx
);
  wire tx_en;
wire rx_en;

wire rdy;
wire cmd_valid;

wire [7:0] rx_data_out;

wire wr_en;
wire rd_en;

wire [7:0] address;
wire [7:0] data;
wire [7:0] rd_data;

wire tx_wr_en;
wire [7:0] tx_data;

wire tx_busy;

wire [7:0] command [0:7];

  baud_rate BR(clk,rst,tx_en,rx_en);
  receiver RX(

    .clk(clk),
    .rst(rst),

    .rx(rx),
    .rdy_clr(rdy_clr),

    .clk_en(rx_en),

    .rdy(rdy),
    .data_out(rx_data_out)

);
 byte_buffer BB(

    .clk(clk),
    .rst(rst),

    .rdy(rdy),
    .data_out(rx_data_out),

    .command(command),
    .cmd_valid(cmd_valid)

);command_parser CP(

    .clk(clk),
    .rst(rst),

    .cmd_valid(cmd_valid),

    .command(command),

    .wr_en(wr_en),
    .rd_en(rd_en),

    .address(address),
    .data(data),

    .rd_data(rd_data)

);
      
      tx_controller TXCTRL(

    .clk(clk),
    .rst(rst),

    .rd_en(rd_en),
    .rd_data(rd_data),

    .tx_busy(tx_busy),

    .tx_wr_en(tx_wr_en),
    .tx_data(tx_data)

);
      
      transmitter TX(

    .clk(clk),
    .rst(rst),

    .wr_en(tx_wr_en),
    .en(tx_en),

    .data_in(tx_data),

    .tx(tx),
    .busy(tx_busy)

);
    endmodule


