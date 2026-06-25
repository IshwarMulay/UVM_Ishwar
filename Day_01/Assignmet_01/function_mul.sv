module function_mul;

  function int unsigned multiply(int unsigned a, int unsigned b);
    return a * b;
  endfunction

  function void verify_result(int unsigned a, int unsigned b, int unsigned expected);
    int unsigned actual;
    actual = multiply(a, b);
    
    if (actual == expected) begin
      $display("SUCCESS: %0d * %0d = %0d | TEST PASSED", a, b, expected);
    end else begin
      $display("ERROR: %0d * %0d = %0d (Expected: %0d) | TEST FAILED", a, b, actual, expected);
    end
  endfunction

  initial begin
    $display("\nQuestion 6: Multiplication Function Verification");

    //Test case 1:pass condition
    verify_result(10, 5, 50);
    
    // Test Case 2: Fail condition
    verify_result(4, 3, 15);
  end

endmodule
