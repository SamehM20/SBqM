// FSM module for interruption.
module int_fsm (
    input logic int_sig,    // Interruption Signal for The Start and End of The Queue.
                reset_n, clk,
    output logic count
);
    typedef enum logic [1:0] {IDLE, ACTIVE, OUT_EN} state_t;
    state_t state, next;

    always_ff @(posedge clk, negedge reset_n) begin
        if(!reset_n) state = IDLE;
        else state = next;
    end
    always_comb begin : set_next_state
        next = state;   // Default value.
        unique case (state)
            IDLE:   if(int_sig)  next = OUT_EN;
            OUT_EN: if(int_sig)  next = ACTIVE;
                    else         next = IDLE;
            ACTIVE: if(!int_sig) next = IDLE;
        endcase
    end
    always_comb begin : set_output_value
        case (state)
            OUT_EN:   count = 1;
            default:  count = 0;
        endcase
    end
endmodule