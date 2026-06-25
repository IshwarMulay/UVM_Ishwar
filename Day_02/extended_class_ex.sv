class add;
	rand bit [3:0] a;
	rand bit [3:0] b;
	bit [4:0] a_res;

	constraint a_const { a inside {[1:10]}; }
	constraint b_range { b inside {[1:10]}; } 
	constraint a_not_eq_b { a != b; }

	function new();

	endfunction

	function void compute();
		this.a_res = a + b;
	endfunction
	
endclass

class mul extends add;
	rand bit [3:0] p;
	rand bit [3:0] q;
	bit [7:0] m_res;

	constraint p_const { p inside {[1:10]}; }
	constraint q_const { q inside {[1:10]}; }
	constraint p_not_eq_q { p != q; }

	function new();
		super.new();
	endfunction

	function void compute();
		super.compute();
		this.m_res = p * q;
	endfunction

endclass


module extended_class_TB();
	mul m;
	
	bit [4:0] addition;
	bit [7:0] multiplication;

	initial begin
		m = new();

		repeat(5) begin

			if(!m.randomize())
                		$display("Randomization Failed!");
            		else begin
				m.compute();
				addition = m.a_res;
				multiplication = m.m_res;
		
				$display("A: %0d B: %0d Addition: %0d | P: %0d Q: %0d Multiplication: %0d", 
					m.a, m.b, addition, m.p, m.q, multiplication);
			end
		end
	end

endmodule


