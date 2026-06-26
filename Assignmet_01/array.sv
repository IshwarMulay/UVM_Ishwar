module array_initialization;

  // Question 2: Define a fixed-size array of 5 elements
  int fixed_arr[5];
  
  // Question 1: Different initialization styles
  int default_arr[5]    = '{default: 10};       
  int repetitive_arr[4] = '{2{1, 2}};           
  int unique_arr[5]     = '{5, 15, 25, 35, 45}; 

  initial begin
    $display("--- Questions 1 & 2: Array Initialization ---");
    
    // Assigning values manually to fixed_arr
    fixed_arr = '{100, 200, 300, 400, 500};
   
    $display("Fixed-size array contents:");
    foreach (fixed_arr[i]) $display("fixed_arr[%0d] = %0d", i, fixed_arr[i]);

    $display("\nArray with Default values (all 10):");
    foreach (default_arr[i]) $display("default_arr[%0d] = %0d", i, default_arr[i]);

    $display("\nArray with Repetitive values (1, 2, 1, 2):");
    foreach (repetitive_arr[i]) $display("repetitive_arr[%0d] = %0d", i, repetitive_arr[i]);

    $display("\nArray with Unique values:");
    foreach (unique_arr[i]) $display("unique_arr[%0d] = %0d", i, unique_arr[i]);
  end

endmodule
