module baud_rate_generator(input clk, output tx_enb, output rx_enb);
  reg [12:0] tx_counter = 0;
  reg [10:0] rx_counter = 0;
  
  always @(posedge clk)
    begin
      if (tx_counter == 5206)
        tx_counter = 0;
      else
        tx_counter <= tx_counter + 1'b1;
      
      if (rx_counter == 325)
        rx_counter = 0;
      else
        rx_counter <= rx_counter + 1'b1;
    end
  
  assign tx_enb = tx_counter ? 1'b1 : 1'b0;
  assign rx_enb = rx_counter ? 1'b1 : 1'b0;
                                             
endmodule