module uarttx(
   
    input logic rst,
    input logic clk,
    input logic send,     //BTN0
    output logic busy,
    output logic serialout
    
    );
    
    localparam [7:0] datain = 8'h41; // 'A'
    localparam CLKS_PER_BIT = 10416;  //clk is 100MHz/baud rate 9600
    typedef enum logic [1:0] {IDLE, START, DATA, STOP} state_t;
    logic [13:0] counter = 0;
    logic [2:0] bitindex = 0; //2^3 = 8
    
    state_t state = IDLE;
    
    
    
    always_ff @(posedge clk) begin
    if (!rst) begin    //reset is active low on the arty s7
        state     <= IDLE;
        serialout <= 1;  // line should idle high on reset
        busy      <= 0;
        counter   <= 0;
        bitindex  <= 0;
        end else begin
    case (state)
    IDLE:begin
    serialout <= 1;
    busy <=0;
    counter <= 0;
    bitindex <= 0;    
    if (send)      //wait for button press
    state <= START;
    end
    
    START:begin
    serialout <= 0;
    busy <= 1;
    if (counter == CLKS_PER_BIT - 1) begin
    counter <= 0;
    state <= DATA;
    end else
    counter <= counter + 1;
    end
    
    DATA:begin
    serialout <= datain[bitindex];
    if (counter == CLKS_PER_BIT - 1) begin
    counter <= 0;
    if (bitindex == 7) begin
    state <= STOP;
    end else
    bitindex <= bitindex+1;
    end else
    counter <= counter + 1;
    end
    
    STOP: begin
    serialout <= 1;
    busy <= 0;
    if (counter == CLKS_PER_BIT - 1) begin
    counter <= 0;
    state <= IDLE;
    end else
    counter <= counter + 1;
    end
    endcase
    end
    end   
endmodule