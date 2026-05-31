`timescale 1ns/1ps
//==============================================================
// UART RECEIVER
//==============================================================

module receiver(

    input clk,
    input rst,

    input rx,
    input rdy_clr,
    input clk_en,

    output reg rdy,
    output reg [7:0] data_out

);

parameter start = 0;
parameter data  = 1;
parameter stop  = 2;

reg [1:0] state;

reg [3:0] sample;
reg [3:0] index;

reg [7:0] temp;

always @(posedge clk) begin

    if(rst) begin

        state <= start;
        sample <= 0;
        index <= 0;
        temp <= 0;

        rdy <= 0;
        data_out <= 0;

    end

    else begin
		rdy<=0;
        if(rdy_clr)
            rdy <= 0;

        if(clk_en) begin

            case(state)

                start: begin

                    if(rx == 0 || sample != 0)
                        sample <= sample + 1'b1;

                    if(sample == 15) begin

                        state <= data;
                        sample <= 0;
                        index <= 0;
                        temp <= 0;

                    end
                end


                data: begin

                    sample <= sample + 1'b1;

                    if(sample == 8) begin

                        temp[index] <= rx;

                    end

                    if(sample == 15) begin

                        sample <= 0;

                        if(index == 7)
                            state <= stop;

                        else
                            index <= index + 1'b1;

                    end
                end


                stop: begin

                    sample <= sample + 1'b1;

                    if(sample == 15) begin

                        state <= start;

                        data_out <= temp;
                        rdy <= 1'b1;

                        sample <= 0;

                    end
                end


                default: begin

                    state <= start;

                end

            endcase
        end
    end
end

endmodule

