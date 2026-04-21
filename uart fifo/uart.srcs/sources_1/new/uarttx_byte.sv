module uarttx(
    input  logic clk,
    input  logic rst,
    input  logic send,
    input  logic [7:0] din,
    output logic serialout,
    output logic busy
);

    localparam CLKS_PER_BIT = 10416;

    typedef enum logic [1:0] {IDLE, START, DATA, STOP} state_t;
    state_t state = IDLE;

    logic [13:0] counter = 0;
    logic [2:0]  bitindex = 0;
    logic [7:0]  tx_data = 0; // Buffer to hold the byte while sending

    always_ff @(posedge clk) begin
        if (!rst) begin
            state     <= IDLE;
            serialout <= 1; // Idle high
            busy      <= 0;
        end else begin
            case (state)
                IDLE: begin
                    busy <= 0;
                    serialout <= 1;
                    if (send) begin
                        tx_data <= din; // Capture the input byte immediately
                        state   <= START;
                    end
                end

                START: begin
                    busy <= 1;
                    serialout <= 0; // Start bit
                    if (counter == CLKS_PER_BIT - 1) begin
                        counter <= 0;
                        state   <= DATA;
                    end else
                        counter <= counter + 1;
                end

                DATA: begin
                    serialout <= tx_data[bitindex];
                    if (counter == CLKS_PER_BIT - 1) begin
                        counter <= 0;
                        if (bitindex == 7) begin
                            bitindex <= 0;
                            state    <= STOP;
                        end else
                            bitindex <= bitindex + 1;
                    end else
                        counter <= counter + 1;
                end

                STOP: begin
                    serialout <= 1; // Stop bit
                    if (counter == CLKS_PER_BIT - 1) begin
                        counter <= 0;
                        state   <= IDLE;
                    end else
                        counter <= counter + 1;
                end
            endcase
        end
    end
endmodule