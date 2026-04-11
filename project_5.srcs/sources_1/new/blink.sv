module blink (
    input  logic clk,
    output logic [3:0] led
    
);
    localparam HALF_PERIOD = 50_000_000; // 0.5s at 100MHz, so full blink = 1s
    localparam FLASH_COUNT = 6;
    
    logic [2:0] flashcount = 0;
    logic [25:0] counter = 0;

typedef enum logic [1:0] {FLASHING, COUNTING} state_t;
state_t state = FLASHING;

    always_ff @(posedge clk) begin
        if (counter == HALF_PERIOD - 1)
            counter <= 0;
        else
            counter <= counter + 1;
    end

    always_ff @(posedge clk) begin
        if (counter == 0)begin
        case (state)
        FLASHING:begin
            led <= ~led;
            flashcount <= flashcount+1;
            if (flashcount == FLASH_COUNT - 1)
            state <= COUNTING;
         end
         COUNTING:begin  
            led <= led+1;
            if (led == 4'b1111) begin
            state <= FLASHING;
            flashcount <= 0;
            end
            end
        endcase
    end
    end

endmodule