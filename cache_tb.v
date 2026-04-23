`timescale 1ns/1ps

module cache_tb;

    reg clk;
    reg reset;
    reg [7:0] data_in;
    reg valid;

    wire hit_fifo;
    wire hit_lru;

    fifo_cache #(3) fifo_inst (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .valid(valid),
        .hit(hit_fifo)
    );

    lru_cache #(3) lru_inst (
        .clk(clk),
        .reset(reset),
        .data_in(data_in),
        .valid(valid),
        .hit(hit_lru)
    );

    always #5 clk = ~clk;

    integer i;
    reg [7:0] ref_string [0:6];

    initial begin
        clk = 0;
        reset = 1;
        valid = 0;

        ref_string[0] = 1;
        ref_string[1] = 2;
        ref_string[2] = 3;
        ref_string[3] = 4;
        ref_string[4] = 1;
        ref_string[5] = 2;
        ref_string[6] = 5;

        #10 reset = 0;

        for (i = 0; i < 7; i = i + 1) begin
            @(posedge clk);
            data_in = ref_string[i];
            valid = 1;

            @(posedge clk);
            valid = 0;

            @(posedge clk);

            $display("Input: %d | FIFO Hit: %d | LRU Hit: %d", 
                      data_in, hit_fifo, hit_lru);
        end

        #20 $finish;
    end

endmodule
