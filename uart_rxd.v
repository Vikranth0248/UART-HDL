`timescale 1ns/1ps

module uart_rxd (
    input clk,
    input rst,
    input rx,
    input rx_tick,
    output reg [7:0] rx_data,
    output reg rx_done
);

// Synchronizer
reg rx_sync1, rx_sync2;

always @(posedge clk) begin
    rx_sync1 <= rx;
    rx_sync2 <= rx_sync1;
end

localparam IDLE=0, START=1, DATA=2, STOP=3;

reg [1:0] state;
reg [3:0] sample_count;
reg [3:0] bit_index;
reg [7:0] data_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        rx_done <= 0;
        sample_count <= 0;
    end else begin
        rx_done <= 0;

        if (rx_tick) begin
            case(state)

            IDLE: begin
                if (rx_sync2 == 0) begin
                    state <= START;
                    sample_count <= 0;
                end
            end

            // wait half bit (8 samples)
            START: begin
                sample_count <= sample_count + 1;
                if (sample_count == 7) begin
                    if (rx_sync2 == 0) begin
                        state <= DATA;
                        sample_count <= 0;
                        bit_index <= 0;
                    end else begin
                        state <= IDLE;
                    end
                end
            end

            DATA: begin
                sample_count <= sample_count + 1;

                if (sample_count == 15) begin
                    sample_count <= 0;
                    data_reg[bit_index] <= rx_sync2;
                    bit_index <= bit_index + 1;

                    if (bit_index == 7)
                        state <= STOP;
                end
            end

            STOP: begin
                sample_count <= sample_count + 1;

                if (sample_count == 15) begin
                    rx_data <= data_reg;
                    rx_done <= 1;
                    state <= IDLE;
                end
            end

            endcase
        end
    end
end

endmodule