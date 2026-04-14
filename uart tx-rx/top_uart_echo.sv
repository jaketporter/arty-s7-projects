module top_uart_echo(
    input  logic clk,       // Pin R2 (100MHz)
    input  logic rst,       // Pin C18 (Active Low Button)
    input  logic usb_rx,    // Pin V12
    output logic usb_tx,    // Pin R12
    output logic [3:0] led  // Pins E18, F13, E13, H15 (Optional status)
);

    // Internal "Virtual Wires"
    logic [7:0] rx_data;
    logic rx_ready;
    logic tx_busy;

    // 1. Instantiate the Receiver (The Ears)
    uartrx receiver (
        .clk(clk),
        .rst(rst),
        .serialin(usb_rx),
        .dataout(rx_data),
        .done(rx_ready), // This pulses when a byte is fully caught
        .busy(led[0])    // LED0 lights up while receiving
    );

    // 2. Instantiate the Transmitter (The Mouth)
    // IMPORTANT: Make sure your uarttx module is the version 
    // that sends a SINGLE byte, not the "Hello World" string version.
    uarttx transmitter (
        .clk(clk),
        .rst(rst),
        .send(rx_ready), // Trigger send as soon as RX is done
        .din(rx_data),   // Feed it the byte we just caught
        .serialout(usb_tx),
        .busy(led[1])    // LED1 lights up while transmitting
    );
    
    // Show the first 2 bits of the byte on LEDs for fun
    assign led[3:2] = rx_data[1:0];

endmodule