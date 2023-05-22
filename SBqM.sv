module SBqM #(parameter N = 3) (
    input logic int_start, int_end,         // Interruption signals of the start and the end of the queue.
                reset_n, clk,
    output logic full, empty,               // The empty and full flags that reflect the status of the queue.
           logic [N-1:0] Pcout
);
    logic count, up_down,
          count_st, count_end;              // Signals for counting when interrupted.

    // The FSM for both Photocells at the start and the end.
    int_fsm fsm_start (.int_sig(int_start), .count(count_st),  .*);
    int_fsm fsm_end   (.int_sig(int_end),   .count(count_end), .*);
    
    // The up-down counter.
    counter #(N) counter0 (.*);

    // Controlling the counter with interrupts.
    always_comb begin
        up_down = 0;
        count = 0;
        case ({count_st, count_end})
            2'b10:begin up_down = 0;
                        count   = 1;
            end
            2'b01:begin up_down = 1;
                        count   = 1;
            end
        endcase
    end
endmodule
