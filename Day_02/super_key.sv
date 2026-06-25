class first; //parent class
	int data;

	function new(input int data);
		this.data = data;
	endfunction
endclass : first

class second extends first;
	int temp;

	function new(int data, int temp);
		super.new(data);
		this.temp = temp;
	endfunction
endclass : second

class third extends second;
	int num;
	
	function new(int data, temp, num);
		super.new(data, temp);
		this.num = num;
	endfunction
endclass: third


module tb;
	second s;
	first f;
	third t;

	initial begin
		s = new(67, 45);
		f = new(10);
		t = new(10,20,30);

		$display("Value of data : %0d and Temp: %0d", s.data, s.temp);
		$display("Value of data : %0d", f.data);
		$display("Value of data : %0d , Temp: %0d and Num: %0d", t.data, t.temp, t.num);

	end

endmodule
