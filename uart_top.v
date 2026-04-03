module uart_top(input rst, wr_enb, clk, rdy_clr
                input [7:0] data_in
                output ready, busy
                output [7:0] data_out);

    wire rxd_enb;
    wire txd_enb;
    wire busy;
    wire tx_temp;

module baud_rate_generator bg(clk, txd_enb, rxd_enb); 
