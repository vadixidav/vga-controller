module vga(
    //Horizontal signals
    h_counter, //O: Horizontal counter
    h_sync, //Horizontal sync
    
    //Veritcal signals
    v_counter, //O: Vertical counter
    v_sync, //Veritcal sync
    
    will_display, //The next pixel will be displayed
    
    reset,
    clk
);
    //Initialize parameters as 640 x 480 @ 60Hz
    parameter HORIZONTAL_SYNC_POLARITY = 1'b0;
    parameter TIME_HORIZONTAL_FRONT_PORCH = 16;
    parameter TIME_HORIZONTAL_SYNC_PULSE = 96;
    parameter TIME_HORIZONTAL_BACK_PORCH = 48;
    parameter TIME_HORIZONTAL_VIDEO = 640;
    parameter TIME_HORIZONTAL = TIME_HORIZONTAL_FRONT_PORCH +
        TIME_HORIZONTAL_SYNC_PULSE +
        TIME_HORIZONTAL_BACK_PORCH +
        TIME_HORIZONTAL_VIDEO;
    
    parameter VERTICAL_SYNC_POLARITY = 1'b0;
    parameter TIME_VERTICAL_FRONT_PORCH = 10;
    parameter TIME_VERTICAL_SYNC_PULSE = 2;
    parameter TIME_VERTICAL_BACK_PORCH = 33;
    parameter TIME_VERTICAL_VIDEO = 480;
    parameter TIME_VERTICAL = TIME_VERTICAL_FRONT_PORCH +
        TIME_VERTICAL_SYNC_PULSE +
        TIME_VERTICAL_BACK_PORCH +
        TIME_VERTICAL_VIDEO;
    
    parameter HORIZONTAL_COUNTER_WIDTH = 10;
    parameter VERTICAL_COUNTER_WIDTH = 10;
    
    
    output reg [HORIZONTAL_COUNTER_WIDTH-1:0] h_counter;
    output h_sync;
    output reg [VERTICAL_COUNTER_WIDTH-1:0] v_counter;
    output v_sync;
    output will_display;
    input reset;
    input clk;
    
    assign h_sync = (h_counter >= TIME_HORIZONTAL_FRONT_PORCH && h_counter < TIME_HORIZONTAL_FRONT_PORCH + TIME_HORIZONTAL_SYNC_PULSE) ?
        HORIZONTAL_SYNC_POLARITY : ~HORIZONTAL_SYNC_POLARITY;
    
    assign v_sync = (v_counter >= TIME_VERTICAL_FRONT_PORCH && v_counter < TIME_VERTICAL_FRONT_PORCH + TIME_VERTICAL_SYNC_PULSE) ?
        VERTICAL_SYNC_POLARITY : ~VERTICAL_SYNC_POLARITY;
        
    assign will_display = h_counter >= TIME_HORIZONTAL_FRONT_PORCH + TIME_HORIZONTAL_SYNC_PULSE + TIME_HORIZONTAL_BACK_PORCH - 1 && h_counter < TIME_HORIZONTAL - 1;
    
    always @(posedge clk) begin
        if (reset) begin
            h_counter <= 0;
            v_counter <= 0;
        end else begin
            if (h_counter == TIME_HORIZONTAL - 1) begin
                h_counter <= 0;
                if (v_counter == TIME_VERTICAL - 1)
                    v_counter <= 0;
                else
                    v_counter <= v_counter + 1;
            end else
                h_counter <= h_counter + 1;
        end
    end
endmodule
