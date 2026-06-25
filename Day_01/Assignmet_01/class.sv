class Class_eg;
  int unsigned val1;
  int unsigned val2;
  int unsigned val3;

  function new();
    val1 = 45;
    val2 = 78;
    val3 = 90;
  endfunction

  function void display_values();
    $display("Class Values: val1 = %0d, val2 = %0d, val3 = %0d", val1, val2, val3);
  endfunction
endclass

module class_example;
  Class_eg obj;

  initial begin
    $display("\nQuestion 5: Class Implementation");
    obj = new();      
    obj.display_values(); 
  end
endmodule
