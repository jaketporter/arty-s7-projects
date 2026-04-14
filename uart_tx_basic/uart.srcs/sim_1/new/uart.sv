module uarttx(
   
    input logic rst,
    input logic clk,
    input logic send,     //BTN0
 //   input logic [7:0] datain,
    output logic busy,      //LD2
    output logic serialout    //UART TX
    
    );
    logic [7:0] datain [0:13] = '{"H", "e", "l", "l", "o", " ", "W", "o", "r", "l", "d", "!",8'h0D, 8'h0A};    //CR and newline
    logic [3:0] char_ptr = 0;    //character pointer
    
    localparam CLKS_PER_BIT = 10416;  //clk is 100MHz/baud rate 9600
    typedef enum logic [2:0] {IDLE, START, DATA, STOP, NEXT_CHAR} state_t;
    state_t state = IDLE;
    
    logic [13:0] counter = 0;       //counter for clk
    logic [2:0] bitindex = 0; //2^3 = 8
    logic [7:0] current_char;

    
    
    always_ff @(posedge clk) begin
    if (!rst) begin    //reset is active low on the arty s7
        state     <= IDLE;
        serialout <= 1;  // line should idle high on reset
        busy      <= 0;
        counter   <= 0;
        bitindex  <= 0;
        char_ptr  <= 0;
        end else begin
    case (state)
    
    IDLE:begin
    serialout <= 1;
    busy <=0;
    counter <= 0;
    bitindex <= 0;    
    char_ptr <= 0;
    if (send)begin      //wait for button press
    current_char <= datain[0]; // Load first char
    state <= START;
    end
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
    serialout <= current_char[bitindex];
    if (counter == CLKS_PER_BIT - 1) begin
    counter <= 0;
    if (bitindex == 7) begin
    bitindex <= 0;
    state <= STOP;
    end else
    bitindex <= bitindex+1;
    end else
    counter <= counter + 1;
    end
    
    STOP: begin
    serialout <= 1;
    busy <= 1; //still high during stop bit
    if (counter == CLKS_PER_BIT - 1) begin
    counter <= 0;
    state <= NEXT_CHAR;
    
    end else
    counter <= counter + 1;
    end
    
    NEXT_CHAR:begin
    if (char_ptr == 13) begin
    busy <= 0;
    state <= IDLE; //string finished
    end else begin
    char_ptr <= char_ptr+1;
    current_char <= datain[char_ptr + 1];   //next character
    state <= START;
    end
    end
    
    default: state <= IDLE;
    
    endcase
    end
    end   
endmodule