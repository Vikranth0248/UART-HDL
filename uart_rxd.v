module uart_rxd(input clk, rst, serial_in, clr, rxd_enb
                output reg [7:0] data_out
                output ready);

    parameter start_state = 2'b00;
    parameter data_state = 2'b01;
    parameter stop_state = 2'b10;

    reg [1:0] state = start_state;
    reg [3:0] sample = 0;
    reg [3:0] index = 0;
    reg [7:0] temp_register = 8'b0;

    always@(posedge clk) begin
        if(rst) begin
            data_out <= 0;
            ready <= 0;
        end
    end
    
    always@(posedge clk) begin
        if(clr) begin
            ready <= 0;
        end

        if(rxd_enb) begin
            case(state) 
                start_state: begin
                    if(serial_in == 0 && sample !=0)
                        sample <= sample + 1'b1;
                    if(sample == 15) begin
                        state <= data_state;
                        sample <= 0;
                        index <= 0;
                        temp_register <= 0;
                    end
                end

                data_state: begin
                    sample <= sample + 1'b1;
                    if(sample == 4'h8) begin
                        temp_register[index] <= serial_in;
                        index <= index + 1'b1;
                    end

                    if(index == 8 && sample == 15)
                        state <= stop_state;
                end

                stop_state: begin
                    if(sample == 15) begin
                        state <= start_state;
                        data_out <= temp_register;
                        sample <= 0;
                        ready <= 1'b1; 
                    end
                    else 
                        sample <= sample + 1'b1;
                end
                default: begin
                    state <= start_state;
                end
            endcase
        end
    end