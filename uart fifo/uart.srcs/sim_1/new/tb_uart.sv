module tb_uart;

//logic [7:0] datain;
logic rst;
logic clk;
logic send;
logic busy;
logic serialout;

uarttx dut (
//.datain(datain),
.rst(rst),
.clk(clk),
.send(send),
.busy(busy),
.serialout(serialout)
);

initial clk = 0;
always #5 clk = ~clk;

initial begin
rst =0;
send = 0;
//datain = 8'h41; //ASCII 'A'

@(posedge clk);
@(posedge clk);
rst = 1;
@(posedge clk);
send = 1;
 @(posedge clk);  // send high for exactly one cycle
    send = 0;
    #(10416 * 10 * 10); // wait for full byte to transmit
#2000000
$finish;
end

endmodule