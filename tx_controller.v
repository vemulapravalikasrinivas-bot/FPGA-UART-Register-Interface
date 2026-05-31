
`timescale 1ns / 1ps
module tx_controller(

    input clk,
    input rst,

    input rd_en,
    input [7:0] rd_data,

    input tx_busy,

    output reg tx_wr_en,
    output reg [7:0] tx_data

);

parameter IDLE      = 0;
parameter SEND_HIGH = 1;
parameter WAIT_HIGH = 2;
parameter SEND_LOW  = 3;
parameter WAIT_LOW  = 4;

reg [2:0] state;

reg [3:0] upper;
reg [3:0] lower;

wire [7:0] upper_ascii;
wire [7:0] lower_ascii;


//-------------------------------------
// Hex to ASCII blocks
//-------------------------------------

hex_ascii U1(
    .nib(upper),
    .out(upper_ascii)
);

hex_ascii U2(
    .nib(lower),
    .out(lower_ascii)
);


//-------------------------------------
// FSM
//-------------------------------------

always @(posedge clk) begin

    if(rst) begin

        state <= IDLE;

        tx_wr_en <= 0;
        tx_data <= 0;

        upper <= 0;
        lower <= 0;

    end

    else begin

        //--------------------------------
        // default
        //--------------------------------

        tx_wr_en <= 0;

        case(state)

            //--------------------------------
            // WAIT FOR READ COMMAND
            //--------------------------------

            IDLE: begin

                if(rd_en) begin

                    upper <= rd_data[7:4];
                    lower <= rd_data[3:0];

                    state <= SEND_HIGH;

                end

            end


            //--------------------------------
            // SEND UPPER NIBBLE ASCII
            //--------------------------------

            SEND_HIGH: begin

                if(!tx_busy) begin

                    tx_data <= upper_ascii;
                    tx_wr_en <= 1;

                    state <= WAIT_HIGH;

                end

            end


            //--------------------------------
            // WAIT UNTIL TX COMPLETES
            //--------------------------------

            WAIT_HIGH: begin

                if(!tx_busy)
                    state <= SEND_LOW;

            end


            //--------------------------------
            // SEND LOWER NIBBLE ASCII
            //--------------------------------

            SEND_LOW: begin

                if(!tx_busy) begin

                    tx_data <= lower_ascii;
                    tx_wr_en <= 1;

                    state <= WAIT_LOW;

                end

            end


            //--------------------------------
            // WAIT UNTIL TX COMPLETES
            //--------------------------------

            WAIT_LOW: begin

                if(!tx_busy)
                    state <= IDLE;

            end


            default:
                state <= IDLE;

        endcase

    end

end

endmodule

