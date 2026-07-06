class ram_generator;
ram_transaction blueprint;
mailbox#(ram_transaction)mbx_gd;
function new(mailbox#(ram_transaction)mbx_gd);
this.mbx_gd=mbx_gd;
blueprint=new();
endfunction
task start();
for(int i=0;i<`num_transactions;i++)begin
if(i==0)assert(blueprint.randomize()with{write_enb==1;read_enb==0;address==5;data_in==8'haa;});
else if(i==1)assert(blueprint.randomize()with{write_enb==0;read_enb==1;address==5;});
else if(i==2)assert(blueprint.randomize()with{write_enb==1;read_enb==0;address==10;data_in==8'h55;});
else if(i==3)assert(blueprint.randomize()with{write_enb==0;read_enb==1;address==10;});
else assert(blueprint.randomize());
mbx_gd.put(blueprint.copy());
$display("GENERATOR: data_in=%0h,write_enb=%0d,read_enb=%0d,address=%0h",blueprint.data_in,blueprint.write_enb,blueprint.read_enb,blueprint.address,$time);
end
endtask
endclass
