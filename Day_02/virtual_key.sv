class first;
	int data = 12;
	virtual function void display();
		$display("FIRST: value of data : %0d", data);
	endfunction

endclass : first

class second extends first;
	int temp = 34;

	function void display();
		$display("SECOND: value of data %0d", temp);
	endfunction

	function void add();
		$display("SECOND: value of after addition %0d", temp + 4);
	endfunction
endclass : second

module virtual_key_TB();
	first f;
	second s;

	initial begin
		f = new();
		s = new();

		f = s;
		
		s.display();
		f.display();
		s.add();
	end
endmodule


