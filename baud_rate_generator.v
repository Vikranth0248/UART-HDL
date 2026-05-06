`timescale 1ns/1ps

module baud_rate_generator #(
    parameter CLK_FREQ = 50000000,
    parameter BAUD_RATE = 9600,
    parameter OVERSAMPLE = 16
)(
    input clk,
    input rst,
    output reg tx_tick,
    output reg rx_tick
);

localparam integer CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;
localparam integer CLKS_PER_SAMPLE = CLKS_PER_BIT / OVERSAMPLE;

reg [15:0] tx_count;
reg [15:0] rx_count;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        tx_count <= 0;
        rx_count <= 0;
        tx_tick <= 0;
        rx_tick <= 0;
    end else begin

        // TX tick (1x baud)
        if (tx_count == CLKS_PER_BIT - 1) begin
            tx_count <= 0;
            tx_tick <= 1;
        end else begin
            tx_count <= tx_count + 1;
            tx_tick <= 0;
        end

        // RX tick (16x oversampling)
        if (rx_count == CLKS_PER_SAMPLE - 1) begin
            rx_count <= 0;
            rx_tick <= 1;
        end else begin
            rx_count <= rx_count + 1;
            rx_tick <= 0;
        end

    end
end

endmodule