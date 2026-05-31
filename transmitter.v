
`timescale 1ns/1ps
//==============================================================
// UART TRANSMITTER
//==============================================================

module transmitter(

    input clk,
    input rst,

    input wr_en,
    input en,

    input [7:0] data_in,

    output reg tx,
    output busy

);

parameter idle  = 0;
parameter start = 1;
parameter data  = 2;
parameter stop  = 3;

reg [7:0] data_temp;
reg [2:0] index;
reg [1:0] state;

always @(posedge clk) begin

    if(rst) begin

        tx <= 1'b1;
        state <= idle;
        index <= 0;
        data_temp <= 0;

    end

    else begin

        case(state)

            idle: begin

                tx <= 1'b1;

                if(wr_en) begin

                    state <= start;
                    data_temp <= data_in;
                    index <= 0;

                end
            end


            start: begin

                if(en) begin

                    tx <= 1'b0;
                    state <= data;

                end
            end


            data: begin

                if(en) begin

                    tx <= data_temp[index];

                    if(index == 7)
                        state <= stop;

                    else
                        index <= index + 1'b1;

                end
            end


            stop: begin

                if(en) begin

                    tx <= 1'b1;
                    state <= idle;

                end
            end


            default: begin

                tx <= 1'b1;
                state <= idle;

            end

        endcase
    end
end


assign busy = (state != idle);

endmodule


