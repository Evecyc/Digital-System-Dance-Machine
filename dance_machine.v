module dance_machine(btn, clk, reset, dot_row, dot_col, out_1, out_2);

    input clk, reset;
    input [3:0] btn;    //button: 0=right, 1=up, 2=down, 3=left
    output [7:0] dot_row, dot_col;
    output [6:0] out_1, out_2;  //seven segment display

    reg [7:0] dot_row, dot_col, lfsr;
    reg [6:0] out_1,out_2;
    reg [31:0] sec_Hz, row_Hz;
    reg [5:0] sec_count;
    reg [5:0] speed;
    reg [2:0] row_count;
    reg [2:0] State, NextState;
    reg sec_div, row_div;
    reg [3:0] point_1, point_2;
    reg [2:0] wrong;
    reg read;   //set to 1 to represent the point has been modified

    parameter up=3'b000, down=3'b001, left=3'b010, right=3'b011, win=3'b100, lose=3'b101;   //four arrow
   



    //State register
    always @(posedge clk or negedge reset) begin
        //reset everything
        if (!reset) begin
            sec_Hz <= 32'd0;
            row_Hz <= 32'd0;
            sec_div <= 1'b0;
            row_div <= 1'b0;
            State <= up;
            sec_count <= 6'b001111; //second start from 1s
            row_count <= 3'b0;
            point_1 <= 4'd0;
            point_2 <= 4'd0;
            read <= 0;
            wrong <= 3'b0;
        end
        //not reset
        else begin
           
            //dot matrix frequency = 10000/s
            if (row_Hz == 32'd5000) begin
                    row_div <= 1'b1;
                    row_Hz <= 32'd0;
            end
            else begin
                row_Hz <= row_Hz + 32'd1;
                if (row_div == 1) begin
                    if(row_count == 3'b111)
                        row_count <= 3'd0;
                    else
                        row_count <= row_count + 1;
                row_div <= 1'b0;
                end
                else ;
            end
           
            //second frequency = 16/s
            if (sec_Hz == 32'd3125000) begin
                    sec_div <= 1'b1;
                    sec_Hz <= 32'd0;
            end
            else begin
                sec_Hz <= sec_Hz + 32'd1;
                if (sec_div == 1) begin
                    //reset and change state when 0
                    if (sec_count == 6'b000000) begin
                        State <= NextState;
                        sec_count <= speed;
                        row_count <= 3'b0;
                        read <= 0;
                    end
                    else begin
                        sec_count <= sec_count - 6'd1;
                    end
                    //determine whether the correct button is pressed
                    if (!btn[0]) begin  //press right
                        //correct logic
                        if (State == right && read == 0)    begin
                            if(point_1 == 4'd9) begin
                                if(point_2 == 4'd9) begin
                                    point_2 <= 4'd0;
                                    State <= win;
                                    sec_count <= 6'b110000;
                                end
                                else begin
                                    point_2 <= point_2 + 1;
                                end
                                point_1 <= 4'd0;
                            end
                            else point_1 <= point_1 +1;
                        end
                        //wrong logic
                        else if (read == 0) begin
                            if(point_1 == 0) begin
                                if(point_2 == 0) ;
                                else begin
                                point_1 <= 4'd9;
                                point_2 <= point_2 - 1;
                                end
                            end
                            else point_1 <= point_1 - 1;
                            wrong <= wrong + 1;     //wrong count
                        end
                        else ;
                        read <= 1;  //indicate point changed
                    end
                    else if (!btn[1]) begin     //press up
                        if (State == up && read == 0)   begin
                            if(point_1 == 4'd9) begin
                                if(point_2 == 4'd9)
                                begin
                                    point_2 <= 4'd0;
                                    State <= win;
                                    sec_count <= 6'b110000;
                                end
                                else
                                begin
                                    point_2 <= point_2 + 1;
                                end
                                point_1 <= 4'd0;
                            end
                            else point_1 <= point_1 +1;
                        end
                        else if (read == 0) begin
                            if(point_1 == 0) begin
                                if(point_2 == 0) ;
                                else begin
                                point_1 <= 4'd9;
                                point_2 <= point_2 - 1;
                                end
                            end
                            else point_1 <= point_1 - 1;
                            wrong <= wrong + 1;
                        end
                        else ;
                        read <= 1;
                    end
                    else if (!btn[2]) begin     //press down
                        if (State == down && read == 0) begin
                            if(point_1 == 4'd9) begin
                                if(point_2 == 4'd9)
                                begin
                                    point_2 <= 4'd0;
                                    State <= win;
                                    sec_count <= 6'b110000;
                                end
                                else
                                begin
                                    point_2 <= point_2 + 1;
                                end
                                point_1 <= 4'd0;
                            end
                            else point_1 <= point_1 +1;
                        end
                        else if (read == 0) begin
                            if(point_1 == 0) begin
                                if(point_2 == 0) ;
                                else begin
                                point_1 <= 4'd9;
                                point_2 <= point_2 - 1;
                                end
                            end
                            else point_1 <= point_1 - 1;
                            wrong <= wrong + 1;
                        end
                        else ;
                        read <= 1;
                    end
                    else if (!btn[3]) begin     //press left
                        if (State == left && read == 0) begin
                            if(point_1 == 4'd9) begin
                                if(point_2 == 4'd9)
                                begin
                                    point_2 <= 4'd0;
                                    State <= win;
                                    sec_count <= 6'b110000;
                                end
                                else
                                begin
                                    point_2 <= point_2 + 1;
                                end
                                point_1 <= 4'd0;
                            end
                            else point_1 <= point_1 +1;
                        end
                        else if (read == 0) begin
                            if(point_1 == 0) begin
                                if(point_2 == 0) ;
                                else begin
                                point_1 <= 4'd9;
                                point_2 <= point_2 - 1;
                                end
                            end
                            else point_1 <= point_1 - 1;
                            wrong <= wrong + 1;
                        end
                        else ;
                        read <= 1;
                    end
                    else ;
                    //restart when 5 wrong
                    if(wrong == 3'd5) begin
                        point_1 <= 4'b0;
                        point_2 <= 4'b0;
                        wrong <= 2'b0;
                        State <= lose;
                        sec_count <= 6'b110000;
                        row_count <= 3'b000;
                    end
                    else ;
                    sec_div <= 1'b0;
                end
                else ;
            end
        end
    end


    //generate random
    always @(posedge clk or negedge reset) begin
        if (!reset)
            lfsr <= 8'b1011_1011; // Non-zero seed
        else
            // Feedback polynomial: x^8 + x^6 + x^5 + x^4 + 1
            lfsr <= {lfsr[6:0], lfsr[7] ^ lfsr[6] ^ lfsr[4] ^ lfsr[2]};
    end

    // NextState logic
    always @(posedge clk) begin
        case (lfsr[1:0])
            2'b00: NextState <= up;
            2'b01: NextState <= down;
            2'b10: NextState <= left;
            2'b11: NextState <= right;
        endcase
    end

    //speed up according to point
    always @(point_2) begin
        if (point_2 < 4'd2) speed <= 6'b001111; //1s
        else if (point_2 < 4'd5)    speed <= 6'b001100; //0.75s
        else if (point_2 < 4'd8)    speed <= 6'b001001; //0.5625s
        else speed <= 6'b000110;    //0.375s
    end
   

   
     // seven segment display to show point
    always @(point_1 or point_2) begin
        case (point_1)
            4'b0000: out_1 <= 7'b1000000; // 0
            4'b0001: out_1 <= 7'b1111001; // 1
            4'b0010: out_1 <= 7'b0100100; // 2
            4'b0011: out_1 <= 7'b0110000; // 3
            4'b0100: out_1 <= 7'b0011001; // 4
            4'b0101: out_1 <= 7'b0010010; // 5
            4'b0110: out_1 <= 7'b0000010; // 6
            4'b0111: out_1 <= 7'b1111000; // 7
            4'b1000: out_1 <= 7'b0000000; // 8
            4'b1001: out_1 <= 7'b0011000; // 9
            default: out_1 <= 7'b1111111; // blank
        endcase
        case(point_2)
            4'b0000: out_2 <= 7'b1000000; // 0
            4'b0001: out_2 <= 7'b1111001; // 1
            4'b0010: out_2 <= 7'b0100100; // 2
            4'b0011: out_2 <= 7'b0110000; // 3
            4'b0100: out_2 <= 7'b0011001; // 4
            4'b0101: out_2 <= 7'b0010010; // 5
            4'b0110: out_2 <= 7'b0000010; // 6
            4'b0111: out_2 <= 7'b1111000; // 7
            4'b1000: out_2 <= 7'b0000000; // 8
            4'b1001: out_2 <= 7'b0011000; // 9
            default: out_2 <= 7'b1111111; // blank
        endcase
    end
     
     

     // arrow
     always @(row_count) begin
        case (State)
            up: begin
                case(row_count)
                    3'd0: dot_row <= 8'b01111111;
                    3'd1: dot_row <= 8'b10111111;
                    3'd2: dot_row <= 8'b11011111;
                    3'd3: dot_row <= 8'b11101111;
                    3'd4: dot_row <= 8'b11110111;
                    3'd5: dot_row <= 8'b11111011;
                    3'd6: dot_row <= 8'b11111101;
                    3'd7: dot_row <= 8'b11111110;
                endcase
                case(row_count)
                    3'd0: dot_col <= 8'b00011000;
                    3'd1: dot_col <= 8'b00111100;
                    3'd2: dot_col <= 8'b01011010;
                    3'd3: dot_col <= 8'b10011001;
                    3'd4: dot_col <= 8'b00011000;
                    3'd5: dot_col <= 8'b00011000;
                    3'd6: dot_col <= 8'b00011000;
                    3'd7: dot_col <= 8'b00011000;
                endcase
            end
            down: begin
                case(row_count)
                    3'd0: dot_row <= 8'b01111111;
                    3'd1: dot_row <= 8'b10111111;
                    3'd2: dot_row <= 8'b11011111;
                    3'd3: dot_row <= 8'b11101111;
                    3'd4: dot_row <= 8'b11110111;
                    3'd5: dot_row <= 8'b11111011;
                    3'd6: dot_row <= 8'b11111101;
                    3'd7: dot_row <= 8'b11111110;
                endcase
                case(row_count)
                    3'd0: dot_col <= 8'b00011000;
                    3'd1: dot_col <= 8'b00011000;
                    3'd2: dot_col <= 8'b00011000;
                    3'd3: dot_col <= 8'b00011000;
                    3'd4: dot_col <= 8'b10011001;
                    3'd5: dot_col <= 8'b01011010;
                    3'd6: dot_col <= 8'b00111100;
                    3'd7: dot_col <= 8'b00011000;
                endcase
            end
            left: begin
                case(row_count)
                    3'd0: dot_row <= 8'b01111111;
                    3'd1: dot_row <= 8'b10111111;
                    3'd2: dot_row <= 8'b11011111;
                    3'd3: dot_row <= 8'b11101111;
                    3'd4: dot_row <= 8'b11110111;
                    3'd5: dot_row <= 8'b11111011;
                    3'd6: dot_row <= 8'b11111101;
                    3'd7: dot_row <= 8'b11111110;
                endcase
                case(row_count)
                    3'd0: dot_col <= 8'b00010000;
                    3'd1: dot_col <= 8'b00100000;
                    3'd2: dot_col <= 8'b01000000;
                    3'd3: dot_col <= 8'b11111111;
                    3'd4: dot_col <= 8'b11111111;
                    3'd5: dot_col <= 8'b01000000;
                    3'd6: dot_col <= 8'b00100000;
                    3'd7: dot_col <= 8'b00010000;
                endcase
            end
            right: begin
                case(row_count)
                    3'd0: dot_row <= 8'b01111111;
                    3'd1: dot_row <= 8'b10111111;
                    3'd2: dot_row <= 8'b11011111;
                    3'd3: dot_row <= 8'b11101111;
                    3'd4: dot_row <= 8'b11110111;
                    3'd5: dot_row <= 8'b11111011;
                    3'd6: dot_row <= 8'b11111101;
                    3'd7: dot_row <= 8'b11111110;
                endcase
                case(row_count)
                    3'd0: dot_col <= 8'b00001000;
                    3'd1: dot_col <= 8'b00000100;
                    3'd2: dot_col <= 8'b00000010;
                    3'd3: dot_col <= 8'b11111111;
                    3'd4: dot_col <= 8'b11111111;
                    3'd5: dot_col <= 8'b00000010;
                    3'd6: dot_col <= 8'b00000100;
                    3'd7: dot_col <= 8'b00001000;
                endcase
            end
            win: begin
                case(row_count)
                    3'd0: dot_row <= 8'b01111111;
                    3'd1: dot_row <= 8'b10111111;
                    3'd2: dot_row <= 8'b11011111;
                    3'd3: dot_row <= 8'b11101111;
                    3'd4: dot_row <= 8'b11110111;
                    3'd5: dot_row <= 8'b11111011;
                    3'd6: dot_row <= 8'b11111101;
                    3'd7: dot_row <= 8'b11111110;
                endcase
                case(row_count)
                    3'd0: dot_col <= 8'b00111100;
                    3'd1: dot_col <= 8'b01000010;
                    3'd2: dot_col <= 8'b10100101;
                    3'd3: dot_col <= 8'b10000001;
                    3'd4: dot_col <= 8'b10100101;
                    3'd5: dot_col <= 8'b10011001;
                    3'd6: dot_col <= 8'b01000010;
                    3'd7: dot_col <= 8'b00111100;
                endcase
            end
            lose: begin
                case(row_count)
                    3'd0: dot_row <= 8'b01111111;
                    3'd1: dot_row <= 8'b10111111;
                    3'd2: dot_row <= 8'b11011111;
                    3'd3: dot_row <= 8'b11101111;
                    3'd4: dot_row <= 8'b11110111;
                    3'd5: dot_row <= 8'b11111011;
                    3'd6: dot_row <= 8'b11111101;
                    3'd7: dot_row <= 8'b11111110;
                endcase
                case(row_count)
                    3'd0: dot_col <= 8'b00111100;
                    3'd1: dot_col <= 8'b01000010;
                    3'd2: dot_col <= 8'b10100101;
                    3'd3: dot_col <= 8'b10000001;
                    3'd4: dot_col <= 8'b10011001;
                    3'd5: dot_col <= 8'b10100101;
                    3'd6: dot_col <= 8'b01000010;
                    3'd7: dot_col <= 8'b00111100;
                endcase
            end
        endcase
    end  
endmodule
