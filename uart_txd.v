module uart_txd(input wr_enb, clk, rst, txd_enb, 
                input [7:0] data_in,
                output reg serial_data,
                output busy);

    parameter idle_state = 2'b00;
    parameter start_state = 2'b01;
    parameter data_state = 2'b10;
    parameter stop_state = 2'b11;

    reg [1:0] state;
    reg [2:0] index;
    reg [7:0] data;

    always@(posedge clk) begin
        if(rst)
            serial_data <= 1'b1;
            state <= idle_state;
            index <= 3'h0;
            data <= 8'h0;
        end

    always@(posedge clk) begin
        case(state)
            idle_state: begin
            serial_data <= 1'b1;
            index <= 3'b0;
                if(wr_enb)
                    state <= start_state;
            end
                    
            start_state: begin
                if(txd_enb) begin
                    serial_data <= 1'b0;
                    state <= data_state;
                    data <= data_in;
                end
            end
                        
            data_state: begin
                if(txd_enb) begin
                    if(index == 3'h7)
                        state <= stop_state;
                    else begin
                        index <= index + 3'h1;
                        serial_data <= data[index];
                    end
                end
            end

            stop_state: begin
                if(txd_enb) begin
                    state <= idle_state;
                    serial_data <= 1'b1;
                end
            end

            default: begin
                state <= idle_state;
                serial_data <= 1'b1;
            end
        endcase
    end

    assign busy = (state != idle_state) ? 1'b1 : 1'b0;
endmodule
            


