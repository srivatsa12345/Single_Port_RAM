class ram_reference_model;
ram_transaction ref_trans;
mailbox#(ram_transaction)mbx_dr;
mailbox#(ram_transaction)mbx_rs;
integer data;
virtual ram_if.REF_SB vif;
reg[`DATA_WIDTH-1:0]MEM[`DATA_DEPTH-1:0];
function new(mailbox#(ram_transaction)mbx_dr,mailbox#(ram_transaction)mbx_rs,virtual ram_if.REF_SB vif);
this.mbx_dr=mbx_dr;
this.mbx_rs=mbx_rs;
this.vif=vif;
for(int i=0;i<`DATA_DEPTH;i++)MEM[i]={`DATA_WIDTH{1'bz}};
endfunction
task start();
for(int i=0;i<`num_transactions;i++)begin
ref_trans=new();
mbx_dr.get(ref_trans);
repeat(1)@(vif.ref_cb)begin
if(ref_trans.write_enb&&~ref_trans.read_enb)begin
MEM[ref_trans.address]=ref_trans.data_in;
ref_trans.data_out=data;
$display("REF MODEL DATA IN MEM[%0h]=%0h",ref_trans.address,MEM[ref_trans.address],$time);
end
if(~ref_trans.write_enb&&ref_trans.read_enb)begin
ref_trans.data_out=MEM[ref_trans.address];
data=MEM[ref_trans.address];
$display("REF MODEL DATA OUT FROM MEM data_out=%0h",ref_trans.data_out,$time);
end
if((~ref_trans.write_enb&&~ref_trans.read_enb)||(ref_trans.write_enb&&ref_trans.read_enb)) ref_trans.data_out=data;
mbx_rs.put(ref_trans);
end
end
endtask
endclass
