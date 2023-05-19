`timescale 1ns/10ps
module test_b;
parameter clk_per = 20, N = 3;
logic int_start, int_end,  reset_n, clk, full, empty;
logic [N-1:0] Pcout, temp;
 
SBqM #(.N(N), .clk_per(clk_per)) sqbm (.*);

// Initialization and Generating The Clock.
initial begin
    reset_n = 0;
    clk = 0;
    int_start = 0;
    int_end = 0;
    forever #(clk_per/2) clk = ~clk;
end

initial begin
    #(2*clk_per);
    reset_n = 1;
    #(clk_per/4);

    $display("Stage1: Testing the end of the queue photocell.");
    for(int i=0;i<(2**N)-1;i++)begin
        int_end = 1;
        #clk_per;
        int_end = 0;
        #clk_per;
        $display("Customer #%d entered the queue and Pcout is %d", i+1, Pcout);
    end
    $display("Full flag = %d and Empty flag = %d", full, empty);
    if((Pcout == '1) && (full == 1) && (empty == 0))
        $display("Stage1: Correct!");
    else
        $display("Stage1: Wrong!");
////////////////////////////////////////////////
    $display("Stage2: Testing Overflow.");
    int_end = 1;
    #clk_per;
    int_end = 0;
    #clk_per;
    $display("Another customer entered the queue and Pcout is %d", Pcout);
    $display("Full flag = %d and Empty flag = %d", full, empty);
    if(Pcout == '1)
        $display("Stage2: Correct!");
    else
        $display("Stage2: Wrong!");
////////////////////////////////////////////////
    $display("Stage3: Testing the start of the queue photocell.");
    for(int i=(2**N)-1;i>0;i--)begin
        int_start = 1;
        #clk_per;
        int_start = 0;
        #clk_per;
        $display("Customer #%d left the queue and Pcout is %d", i, Pcout);
    end
    $display("Full flag = %d and Empty flag = %d", full, empty);
    if(Pcout == 0 && full == 0 && empty == 1)
        $display("Stage3: Correct!");
    else
        $display("Stage3: Wrong!");
////////////////////////////////////////////////
    $display("Stage4: Testing Underflow.");
    int_start = 1;
    #clk_per;
    $display("Another customer left the queue and Pcout is %d", Pcout);
    $display("Full flag = %d and Empty flag = %d", full, empty);
    if(Pcout == 0)
        $display("Stage4: Correct!");
    else
        $display("Stage4: Wrong!");
////////////////////////////////////////////////
    $display("Resetting...");
    #clk_per;
    reset_n = 0;
    #clk_per;
    reset_n = 1;
    if((empty == 1)&&(full == 0)&&(Pcout == 0))
        $display("Done.");
    else begin
        $display("Error!");
    end
////////////////////////////////////////////////
    $display("Stage5: Testing the start & the end of the queue photocells simultaneously.");
    int_start = 0;
    int_end   = 0;
    for(int i=0;i<=2**N/2;i++)begin
        int_end = 1;
        #clk_per;
        int_end = 0;
        #clk_per;
    end    
    temp = Pcout;
    $display("Pcout is %d", Pcout);
    $display("Full flag = %d and Empty flag = %d", full, empty);
    $display("Asserting both signals simultaneously.");
    int_start = 1;
    int_end   = 1;
    #clk_per;
    int_start = 0; 
    int_end   = 0;
    $display("Pcout is %d", Pcout);
    if(Pcout == temp)
        $display("Stage5: Correct!");
    else
        $display("Stage5: Wrong!");
////////////////////////////////////////////////
    $display("Resetting...");
    #(clk_per/4);
    reset_n = 0;
    #clk_per;
    reset_n = 1;
    if((empty == 1)&&(full == 0)&&(Pcout == 0))
        $display("Done.");
    else begin
        $display("Error!");
    end
////////////////////////////////////////////////
    $display("Testing has completed...");
    $display("Finishing...");
$stop;
end
endmodule