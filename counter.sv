//`define SYNTHESIS // Used to enable fully synthesizable design.
// Generic Up-Down N bits Counter with a default value of 3 bits.
module counter #(parameter N = 3) (
    input logic count, up_down, reset_n,      // For up_down signal, logic '1' is for up counting and '0' is for down counting.
    output logic full, empty, 
    output logic [N-1:0] Pcout
);
    assign empty = ~|Pcout;     // Indication of counter emptiness.
    assign full  = &Pcout;      // Indication of counter fullness.

    always_ff @(posedge count or negedge reset_n) begin
        if(!reset_n)  Pcout <= 0;           // Resetting the counter.
        else if(up_down) begin              // Counting up if the counter isn't full.
            if(!full) Pcout++; 
            `ifndef SYNTHESIS
            else // Warning: overflow.
                $display("Warning: overflow! Maximum number exceeded.");
            `endif
        end
        else
            if(!empty) Pcout--;             // Counting down if the counter isn't empty.
            `ifndef SYNTHESIS
            else // Warning: underflow.
                $display("Warning: underflow! Can't go below Zero.");
            `endif
    end
endmodule