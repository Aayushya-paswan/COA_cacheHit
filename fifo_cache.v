module fifo_cache #(parameter SIZE = 3)(
    input clk,
    input reset,
    input [7:0] data_in,
    input valid,
    output reg hit
);

    reg [7:0] cache [0:SIZE-1];
    integer i;
    integer front;
    integer count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            front = 0;
            count = 0;
            hit = 0;
        end else if (valid) begin
            hit = 0;

            for (i = 0; i < count; i = i + 1) begin
                if (cache[i] == data_in)
                    hit = 1;
            end

            if (!hit) begin
                if (count < SIZE) begin
                    cache[count] = data_in;
                    count = count + 1;
                end else begin
                    cache[front] = data_in;
                    front = (front + 1) % SIZE;
                end
            end
        end
    end
endmodule
