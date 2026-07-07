`include "RAM.sv"
`include "ram_if.sv"
module top();
import ram_package::*;
logic clk;
logic reset;
initial begin clk=0;end
initial begin
forever #10 clk=~clk;
end
initial begin
reset=1;
@(posedge clk);
reset=0;
repeat(1)@(posedge clk);
reset=1;
end
ram_if intrf(clk,reset);
RAM DUV(.data_in(intrf.data_in),.read_enb(intrf.read_enb),.write_enb(intrf.write_enb),.data_out(intrf.data_out),.address(intrf.address),.clk(clk),.reset(reset));
//ram_test test;
//test=new(intrf.DRV,intrf.MON,intrf.REF_SB);
//test1 tb1= new(intrf.DRV,intrf.MON,intrf.REF_SB);
//test2 tb2= new(intrf.DRV,intrf.MON,intrf.REF_SB);
//test4 tb4= new(intrf.DRV,intrf.MON,intrf.REF_SB);
test_regression tb_regression= new(intrf.DRV,intrf.MON,intrf.REF_SB);

initial begin
//test.run();
tb_regression.run();
$finish();
end
endmodule
