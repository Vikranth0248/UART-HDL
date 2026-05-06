`timescale 1ns/1ps

module uart_top (
    input clk,
    input rst,
    input tx_start,
    input [7:0] tx_data,
    output tx,
    output [7:0] rx_data,
    output rx_done,
    output tx_busy
);

wire tx_tick, rx_tick;

// Baud generator
baud_rate_generator baud_gen (
    .clk(clk),
    .rst(rst),
    .tx_tick(tx_tick),
    .rx_tick(rx_tick)
);

// TX
uart_txd tx_unit (
    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx_tick(tx_tick),
    .tx(tx),
    .tx_busy(tx_busy)
);

// RX (loopback)
uart_rxd rx_unit (
    .clk(clk),
    .rst(rst),
    .rx(tx),
    .rx_tick(rx_tick),
    .rx_data(rx_data),
    .rx_done(rx_done)
);

endmodule