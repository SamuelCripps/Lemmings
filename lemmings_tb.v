`timescale 1ns / 1ps

module top_module_tb;
    // Inputs
    reg clk;
    reg areset;
    reg bump_left;
    reg bump_right;
    reg ground;
    reg dig;
    
    // Outputs
    wire walk_left;
    wire walk_right;
    wire aaah;
    wire digging;
    
    // Instantiate the Unit Under Test (UUT)
    top_module uut (
        .clk(clk),
        .areset(areset),
        .bump_left(bump_left),
        .bump_right(bump_right),
        .ground(ground),
        .dig(dig),
        .walk_left(walk_left),
        .walk_right(walk_right),
        .aaah(aaah),
        .digging(digging)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end
    
    // Test stimulus
    initial begin
        // Initialize Inputs
        areset = 1;
        bump_left = 0;
        bump_right = 0;
        ground = 1;
        dig = 0;
        
        // Reset
        #20;
        areset = 0;
        
        // Test Case 1: Walk left, bump left, switch to walk right
        #10;
        bump_left = 1;
        #10;
        bump_left = 0;
        
        // Test Case 2: Walk right, fall (no ground)
        #10;
        ground = 0;
        #30;
        ground = 1; // Land safely
        #10;
        
        // Test Case 3: Walk right, dig
        ground = 1;
        dig = 1;
        #20;
        dig = 0;
        
        // Test Case 4: Dig, lose ground, fall
        dig = 1;
        #10;
        ground = 0;
        #20;
        ground = 1;
        
        // Test Case 5: Long fall to splatter
        ground = 1;
        #10;
        ground = 0;
        #210; // Fall for >20 cycles
        ground = 1;
        #10;
        
        // Test Case 6: Reset during splatter
        #10;
        areset = 1;
        #10;
        areset = 0;
        
        // Test Case 7: Walk left, bump, dig, fall
        ground = 1;
        bump_left = 1;
        #10;
        bump_left = 0;
        dig = 1;
        #10;
        ground = 0;
        #20;
        
        // End simulation
        #50;
        $finish;
    end
    
    
endmodule
