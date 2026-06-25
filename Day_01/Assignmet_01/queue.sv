module queue;

  int my_queue[$];

  initial begin
    $display("\n Question 4: Queue Operations");
    
    // Push operations
    my_queue.push_back(50); 
    my_queue.push_back(60);  
    my_queue.push_front(40);  
    
    $display("Queue after pushes: %p", my_queue);
    
    // Pop operations
    begin
      int popped_val;
      
      popped_val = my_queue.pop_front();
      $display("Popped from front: %0d | Remaining Queue: %p", popped_val, my_queue);
      
      popped_val = my_queue.pop_back(); 
      $display("Popped from back: %0d  | Remaining Queue: %p", popped_val, my_queue);
    end
  end

endmodule
