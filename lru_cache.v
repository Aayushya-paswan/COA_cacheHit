module lru_cache #(parameter SIZE = 3)(
    input clk,
    input reset,
    input [7:0] data_in,
    input valid,
    output reg hit
);

    reg [7:0] cache [0:SIZE-1];
    integer age [0:SIZE-1];

    integer i, lru_index;
    integer max_age;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            hit = 0;
            for (i = 0; i < SIZE; i = i + 1) begin
                age[i] = 0;
                cache[i] = 0;
            end
        end else if (valid) begin
            hit = 0;

            for (i = 0; i < SIZE; i = i + 1)
                age[i] = age[i] + 1;

            for (i = 0; i < SIZE; i = i + 1) begin
                if (cache[i] == data_in) begin
                    hit = 1;
                    age[i] = 0;
                end
            end

            if (!hit) begin
                max_age = -1;
                lru_index = 0;

                for (i = 0; i < SIZE; i = i + 1) begin
                    if (age[i] > max_age) begin
                        max_age = age[i];
                        lru_index = i;
                    end
                end

                cache[lru_index] = data_in;
                age[lru_index] = 0;
            end
        end
    end
endmodule
