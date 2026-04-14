module uartrx(
    input logic rst,
    input logic clk,
    input logic serialin,    //UART RX
    output logic [7:0] dataout,
    output logic busy,      //LD2
    output logic done    
    );



//double register the input to prevent metastablitity
logic rx_sync;
logic rx_reg;
always_ff @(posedge clk) begin
    rx_reg  <= serialin;     // First flip-flop  (prevent metastability)
    rx_sync <= rx_reg;  // Second flip-flop (this is the one we use)
end

 localparam CLKS_PER_BIT = 10416;  //clk is 100MHz/baud rate 9600
    typedef enum logic [1:0] {IDLE, START, DATA, STOP} state_t;
    state_t state = IDLE;
    
    logic [13:0] counter = 0;       //counter for clk
    logic [2:0] bitindex = 0; //2^3 = 8
    logic [7:0]  rx_byte   = 0;   //temporary buffer
    
     always_ff @(posedge clk) begin
    if (!rst) begin    //reset is active low on the arty s7
        state     <= IDLE;
        done <= 0;  
        busy      <= 0;
        counter   <= 0;
        bitindex  <= 0;
        end else begin
    case (state)
    
    IDLE:begin
    busy <=0;
    done <=0;
    counter <= 0;
    bitindex <= 0;    
    if (rx_sync == 0)begin    
    state <= START;
    end
    end
    
    START:begin
    busy <= 1;
    if (counter == CLKS_PER_BIT/2 - 1) begin //sample in middle of bit
    counter <= 0;
    state <= DATA;
    end else
    counter <= counter + 1;
    end
    
    DATA:begin
    if (counter == CLKS_PER_BIT - 1) begin
    counter <= 0;
    rx_byte[bitindex] <= rx_sync; //store bit in temporary buffer
    if (bitindex == 7) begin
    bitindex <= 0;
    state <= STOP;
    end else begin
    bitindex <= bitindex+1;
    end
    end else begin
    counter <= counter + 1;
    end
    end
    
    STOP: begin
    busy <= 1; //still high during stop bit
    if (counter == CLKS_PER_BIT - 1) begin
    counter <= 0;
    dataout <= rx_byte;
    done <= 1; //pulse done for 1 clk cycle
    state <= IDLE;
    
    end else
    counter <= counter + 1;
    end
    
     default: state <= IDLE;
    
    endcase
    end
    end   
    
endmodule