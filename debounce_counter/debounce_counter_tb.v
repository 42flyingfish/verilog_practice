// Define timescale
`timescale 1 us / 10 ps

module debounce_counter_tb ();

    // Internal signals
    wire    [3:0]   out;

    // Storage
    reg     clk = 0;
    reg     rst_btn = 1;
    reg     inc_btn = 1;
    integer i;
    integer j;

    localparam DURATION = 10000;

    // Generate signal
    always begin

            // DELAY for 41.67 time units
            // 10 ps precision means that 41.667 is rounded to 42.67
            #0.04167

            // Toggle clock like
            clk = ~clk;
    end

    debounce_counter #(.MAX_CLK_COUNT(4800 - 1)) uut (
        .clk(clk),
        .rst_btn(rst_btn),
        .go_btn(inc_btn),
        .led(out)
    );

    initial begin

        #10
        rst_btn = 0;
        #1
        rst_btn = 1;

        for (i = 0; i < 32; i = i + 1) begin
            //Wait
            #1
            inc_btn = ~inc_btn;
        end
    end


    initial begin

        // Create simulation file
        $dumpfile("debounce_counter_tb.vcd");
        $dumpvars(0, debounce_counter_tb);

        #(DURATION);

        $display("FINISHED");
        $finish;
    end

endmodule