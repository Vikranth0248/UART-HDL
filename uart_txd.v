`timescale 1ns/1ps

module uart_txd (
    input clk,
    input rst,
    input tx_start,
    input [7:0] tx_data,
    input tx_tick,
    output reg tx,
    output reg tx_busy
);

localparam IDLE=0, START=1, DATA=2, STOP=3;

reg [1:0] state;
reg [3:0] bit_index;
reg [7:0] data_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        tx <= 1;
        tx_busy <= 0;
    end else begin
        case(state)

        IDLE: begin
            tx <= 1;
            tx_busy <= 0;
            if (tx_start) begin
                data_reg <= tx_data;
                state <= START;
                tx_busy <= 1;
            end
        end

        START: begin
            if (tx_tick) begin
                tx <= 0;
                state <= DATA;
                bit_index <= 0;
            end
        end

        DATA: begin
            if (tx_tick) begin
                tx <= data_reg[bit_index];
                bit_index <= bit_index + 1;

                if (bit_index == 7)
                    state <= STOP;
            end
        end

        STOP: begin
            if (tx_tick) begin
                tx <= 1;
                state <= IDLE;
            end
        end

        endcase
    end
end

endmodule