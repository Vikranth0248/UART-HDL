module uart_rxd(input rxd_enb, clk, rst, clr, serial_in
                output reg [7:0] data_out
                output ready);

    parameter start_state = 2'b00;
    parameter data_state = 2'b01;
    parameter stop_state = 2'b10;

    reg [1:0] state = start_state;
    reg [3:0] sample = 0;
    reg [3:0] index = 0;
    reg [7:0] temp_register = 8'b0;

    always@(posedge) begin
        if(rst) begin
            data_out = 0;
            ready = 0;
        end
    end
    
    always@(posedge) begin
        if(clr) begin
            ready <= 0;
        end
        if(rxd_enb) begin
            case(state) 
                start_state: begin
                    if(index != 7)
                        data_out[index] = serial_in;
                end
            endcase
        end
    end