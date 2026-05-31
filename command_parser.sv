`timescale 1ns / 1ps
//==============================================================
// COMMAND PARSER + REGISTER FILE
//==============================================================

module command_parser(

    input clk,
    input rst,

    input cmd_valid,

    input [7:0] command [0:7],

    output reg wr_en,
    output reg rd_en,

    output reg [7:0] address,
    output reg [7:0] data,

    output reg [7:0] rd_data

);

reg [7:0] reg_file [0:255];

always @(posedge clk) begin

    if(rst) begin

        wr_en <= 0;
        rd_en <= 0;

        address <= 0;
        data <= 0;
        rd_data <= 0;

    end

    else begin

        wr_en <= 0;
        rd_en <= 0;

        if(cmd_valid) begin

            //----------------------------------------
            // WRITE COMMAND
            //----------------------------------------

            if(command[0] == "W") begin

                wr_en <= 1;

                address <= (((command[2] - "0") << 4) |
                             (command[3] - "0"));

                data <= (((command[5] - "0") << 4) |
                          (command[6] - "0"));

                reg_file[
                    (((command[2] - "0") << 4) |
                      (command[3] - "0"))
                ]
                <=
                (((command[5] - "0") << 4) |
                  (command[6] - "0"));

            end


            //----------------------------------------
            // READ COMMAND
            //----------------------------------------

            else if(command[0] == "R") begin

                rd_en <= 1;

                address <= (((command[2] - "0") << 4) |
                             (command[3] - "0"));

                rd_data <= reg_file[
                            (((command[2] - "0") << 4) |
                              (command[3] - "0"))
                           ];

            end
        end
    end
end

endmodule
