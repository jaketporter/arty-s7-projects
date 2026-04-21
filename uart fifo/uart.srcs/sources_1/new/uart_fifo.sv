module uart_fifo (

    input logic clk,
    input logic rst,
    
    //write
    input logic wr_en,
    input logic [7:0] din,
    
    //read
    input logic rd_en,
    output logic [7:0] dout,
    
    //status flags
    output logic empty,
    output logic full
    );
    
    //The memory 16 slots, each 8 bits wide
    logic [7:0] mem [15:0];
    
    //pointers 4 bits can address 0-15
    logic [3:0] w_ptr = 0;
    logic [3:0] r_ptr = 0;
    
    //counter - 5 bits wide to represent the number 16
    logic [4:0] count = 0;
    
    assign empty = (count ==0);
    assign full = (count == 16);
    
    always_ff @(posedge clk) begin
        if (!rst) begin
            w_ptr <= 0;
            r_ptr <= 0;
            count <= 0;
        end else begin
        if (wr_en && !full) begin    //if ok start writing
                mem[w_ptr] <= din;
                w_ptr <= w_ptr + 1;    //circular buffer goes back to 0000 after 1111
                if (!rd_en) count <= count + 1;  //increment count if something is written but not read
        end
        
        if (rd_en && !empty) begin  //if ok start reading
                r_ptr <= r_ptr + 1;
                if (!wr_en) count <= count - 1; //increment count down if not writing and something is read
        end
        end
        end
        assign dout = mem[r_ptr];

endmodule 