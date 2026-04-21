module top_uart_echo(
    input  logic clk,       // Pin R2 (100MHz)
    input  logic rst,       // Pin C18 (Active Low Button)
    input  logic usb_rx,    // Pin V12
    output logic usb_tx,    // Pin R12
    output logic [3:0] led  // Pins E18, F13, E13, H15 
);

    // Internal "Virtual Wires"
    logic [7:0] rx_data;
    logic rx_ready;
    logic [7:0] fifo_out;
    logic       fifo_empty;
    logic       fifo_full;
    logic       fifo_rd_en;
    logic       tx_busy;
    logic       tx_send;

    uartrx receiver (
        .clk(clk),
        .rst(rst),
        .serialin(usb_rx),
        .dataout(rx_data),
        .done(rx_ready) // This pulses when a byte is fully caught
    );

    uart_fifo buffer (
    .clk(clk),
    .rst(rst),
    .wr_en(rx_ready),
    .din(rx_data),
    .rd_en(fifo_rd_en),
    .dout(fifo_out),
    .empty(fifo_empty),
    .full(fifo_full)
    );
    
    // We only want to read from FIFO if it's NOT empty and TX is NOT busy
    always_ff @(posedge clk) begin
        if (!rst) begin
            tx_send <= 0;
            fifo_rd_en <= 0;
        end else begin
            // Default: don't pulse
            tx_send <= 0;
            fifo_rd_en <= 0;

            if (!fifo_empty && !tx_busy && !tx_send && !fifo_rd_en) begin
                fifo_rd_en <= 1; // "Pop" the data from FIFO
                tx_send <= 1;    // "Push" it to the Transmitter
            end
        end
    end
    
    uarttx transmitter (
        .clk(clk),
        .rst(rst),
        .send(tx_send), // Trigger send as soon as RX is done
        .din(fifo_out),   // Feed it the byte we just caught
        .serialout(usb_tx),
        .busy(tx_busy)    // LED1 lights up while transmitting
    );
    
    assign led[0] = fifo_full;  // Red Alert: We are dropping data!
    assign led[1] = !fifo_empty; // Something is in the bucket
    assign led[2] = tx_busy;
    assign led[3] = rx_ready;
    
endmodule