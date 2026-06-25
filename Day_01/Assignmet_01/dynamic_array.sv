module dynamic_array;

  int dyn_arr[];

  initial begin
    $display("\n-Question 3: Dynamic Array");
    dyn_arr = new[4];

    dyn_arr = '{11, 22, 33, 44};

    $display("Dynamic array size: %0d", dyn_arr.size());
    foreach (dyn_arr[i]) begin
    $display("dyn_arr[%0d] = %0d", i, dyn_arr[i]);
    end

    dyn_arr.delete();
  end

endmodule
