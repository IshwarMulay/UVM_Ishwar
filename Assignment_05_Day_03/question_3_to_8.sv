`include "uvm_macros.svh"
import uvm_pkg::*;

class greater extends uvm_object;
	
	`uvm_object_utils(greater);

	function new(string name = "greater");
		super.new(name);
	endfunction

	rand bit [3:0] a;
	rand bit [3:0] b;
	
	//Question 3
	//constraint e_const {(a < b); }
	
	//Question 5
	//constraint a_const {{(a + b) == 10};}

	//Question 6
	//constraint a_const{a > 8; }
	
	//Qiestion 7
	//rand bit [7:0] addr;
	//rand bit [7:0] data;
	//constraint addr_const{inside addr{[10:50]};}
	//constraint data_const{inside data{[20:60]};}
	
	//Question 8
	rand bit [7:0] addr;
	rand bit [7:0] data;
	constraint addr_const{inside addr{[16:31]};}
	constraint data_const{inside data{[20:60]};}



endclass

module greater_TB;
	
	greater g;
	
	initial begin
		g = greater::type_id::create("g");
		repeat(10) begin
			if(!g.randomize())begin
				$sformatf("Randomization Faild");	
			end
			else
				`uvm_info(g.get_name(), $sformatf("A: %0d B: %0d",g.a, g.b), UVM_LOW);
		end

	end	

endmodule
