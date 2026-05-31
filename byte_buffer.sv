`timescale 1ns / 1ps

module byte_buffer(

    input clk,
    input rst,

    input rdy,
    input [7:0] data_out,

    output reg [7:0] command [0:7],
    output reg cmd_valid);

  reg [2:0] index;

always @(posedge clk) begin

    if(rst) begin

        index <= 0;
        cmd_valid <= 0;

    end

    else begin

        cmd_valid <= 0;

        if(rdy) begin

            command[index] <= data_out;

            if(index == 6) begin

                cmd_valid <= 1;
                index <= 0;

            end

            else begin

                index <= index + 1;

            end
        end
    end
end

endmodule


