module debounce_counter (

    // Inputs
    input               clk,
    input               rst_btn,
    input               go_btn,
    
    // Outputs
    output  reg [3:0]   led,
    output  reg         done_sig
);

    // States
    localparam  STATE_IDLE      = 2'd0;
    localparam  STATE_PRESSED   = 2'd1;
    localparam  STATE_WAIT      = 2'd2;
    localparam  STATE_READY     = 2'd3;
    
    // Max counts for clock divider and counter
    localparam  MAX_CLK_COUNT   = 24'd4800000 - 1;
    localparam  MAX_LED_COUNT   = 4'hF;
    
    // Internal signals
    wire rst;
    wire go;
    
    // Internal storage elements
    reg [1:0]   state;
    reg [23:0]  clk_count;
    
    // Invert active-low buttons
    assign rst = ~rst_btn;
    assign go = ~go_btn;
    
    // Wait for stuff
    always @ (posedge clk or posedge rst) begin
        if (rst == 1'b1) begin
            clk_count <= 24'b0;
        end else begin
            if (state == STATE_WAIT) begin
                clk_count <= clk_count + 1;
            end else begin
                clk_count <= 24'b0;
            end
        end
    end
    
    // State transition logic
    always @ (posedge clk or posedge rst) begin
    
        // On reset, return to idle state
        if (rst == 1'b1) begin
            state <= STATE_IDLE;
            led <= 4'b0;
            
        // Define the state transitions
        end else begin
            case (state)
            
                // Wait for go button to be pressed
                STATE_IDLE: begin
                    if (go == 1'b1) begin
                        state <= STATE_PRESSED;
                    end
                end
                
                // Go from counting to done if counting reaches max
                STATE_PRESSED: begin
                    led <= led + 1;
                    state <= STATE_WAIT;
                end
                
                STATE_WAIT: begin
                    if (clk_count == MAX_CLK_COUNT) begin
                        if (go == 1'b1) begin
                            state <= STATE_PRESSED;
                        end else begin
                            state <= STATE_IDLE;
                        end
                    end
                end
                
                // Go to idle if in unknown state
                default: state <= STATE_IDLE;
            endcase
        end
    end
    
endmodule
            
