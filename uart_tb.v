`timescale 1ns/1ps

module uart_tb;

reg clk = 0;
reg rst = 1;
reg tx_start = 0;
reg [7:0] tx_data;

wire tx;
wire [7:0] rx_data;
wire rx_done;
wire tx_busy;

uart_top dut (
    .clk(clk),
    .rst(rst),
    .tx_start(tx_start),
    .tx_data(tx_data),
    .tx(tx),
    .rx_data(rx_data),
    .rx_done(rx_done),
    .tx_busy(tx_busy)
);

always #10 clk = ~clk;

initial begin
    $dumpfile("uart.vcd");
    $dumpvars(0, uart_tb);

    tx_data = 8'h41;

    #50 rst = 0;

    #50 tx_start = 1;
    #20 tx_start = 0;

    wait(rx_done);
    $display("Received: %h", rx_data);

    tx_data = 8'h55;

    #50 tx_start = 1;
    #20 tx_start = 0;

    wait(rx_done);
    $display("Received: %h", rx_data);

    #200 $finish;
end

endmodule