`timescale 1ns / 1ps
module mouse_env(
    input clk,
    input rst_n,
    input read_en,
    input [23:0] mouse_data,
    input [2:0]  key,
    output reg[10:0]mouse_x,
    output reg[10:0]mouse_y,
    output reg page,
    output reg done,
    output reg [20:0] start_addra_,
    output reg [3:0]  number1,
    output reg [3:0]  number2,
    output reg [14:0] sum_price,
    output reg [14:0] sum_price_,
    output      [5:0]itemstate,
    output reg  addstate
    );
    reg [33:0] c_count,c_count1;
    reg [20:0]star_addra = 'b0;
    reg[7:0] move_x,move_y,price;
    reg left_click;
    reg state = 'b0, state1 ='b0;
    reg [2:0]key_;
    reg [5:0]items[0:7];//商品现存数量
    reg [5:0] item; //现在选中了哪个商品
    wire [7:0]all; //统计即将买的商品数量
    assign  all = number1*10 + number2;
    assign  itemstate[0] = items[0]>'b0;
    assign  itemstate[1] = items[1]>'b0;
    assign  itemstate[2] = items[2]>'b0;
    assign  itemstate[3] = items[3]>'b0;
    assign  itemstate[4] = items[4]>'b0;
    assign  itemstate[5] = items[5]>'b0;
    always@(posedge clk) begin
        addstate <= items[item]>all?'b1:'b0;
    end
    
    always@(posedge clk)begin
            if(rst_n)begin
                state1 <= 'b0; key_[0] <= 'b0;key_[1] <= 'b0;key_[2] <= 'b0;
            end
            else begin
                case(state1)
                'b0:begin
                    key_[0] <= 'b0;key_[1] <= 'b0;key_[2] <= 'b0;
                    if(c_count1 < 'd20000000) c_count1 <= c_count1 + 'b1;
                    else begin
                        c_count1 <= 'b0; state1 <= 'b1;
                    end
                end
                'b1:begin
                    if(key[0])begin key_[0]<='b1;state1 <= 'b0; end
                    if(key[1])begin key_[1]<='b1;state1 <= 'b0; end
                    if(key[2])begin key_[2]<='b1;state1 <= 'b0; end
                end
            endcase
        end
    end    
    always@(posedge clk)begin
        if(rst_n)begin
            state <= 'b0;left_click <= 'b0;c_count<='b0;
        end
        else begin
            case(state)
            'b0:begin
                left_click<='b0;
                if(c_count < 'd20000000) c_count <= c_count + 'b1;
                else begin
                    c_count <= 'b0; state <= 'b1;
                end
            end
            'b1:begin
                if(mouse_data[0])begin left_click<='b1;state <= 'b0; end
            end
        endcase
    end
end
    
    always@(posedge clk) begin
        if(rst_n) begin
            page <= 'b0;number1<='d0;number2<='d0;done <='b0;
            sum_price <= 'd0;sum_price_ <= 'd0;
            items[0]<='d5;items[1]<='d5;items[2]<=8'd50;items[3]<='d5;items[4]<='d5;items[5]<='d5;
         end
        if(!page && left_click) begin
            if(itemstate[0]&&mouse_x >= 284&& mouse_x <334&&mouse_y>=216&&mouse_y<241) begin
                page <= 'b1;
                star_addra<='d0;
                price <= 'd25;
                item<='d0;
            end
            else if(itemstate[1]&&mouse_x >= 434&& mouse_x <484&&mouse_y>=216&&mouse_y<241)begin
                page <= 'b1;    
                star_addra<='d5000;
                price <= 'd30;
                item<='d1;
            end
            else if(itemstate[2]&&mouse_x >= 584&& mouse_x <634&&mouse_y>=216&&mouse_y<241)begin
                page <= 'b1;    
                star_addra<='d10000;
                price <= 'd55;
                item<='d2;
            end
            if(itemstate[3]&&mouse_x >= 284&& mouse_x <334&&mouse_y>=476&&mouse_y<501) begin
                page <= 'b1;
                star_addra<='d15000;
                price <= 'd30;
                item<='d3;
            end
            else if(itemstate[4]&&mouse_x >= 434&& mouse_x <484&&mouse_y>=476&&mouse_y<501)begin
                page <= 'b1;    
                star_addra<='d20000;
                price <= 'd35;
                item<='d4;
            end
            else if(itemstate[5]&&mouse_x >= 584&& mouse_x <634&&mouse_y>=476&&mouse_y<501)begin
                page <= 'b1;    
                star_addra<='d25000;
                price <= 'd65;
                item<='d5;
            end
        end
        
        else if(page && left_click)begin
            if(mouse_x >= 650&& mouse_x <700&&mouse_y>=430&&mouse_y<480)begin
                page <= 'b0;
                star_addra<='d0;
                number1 <= 'd0;number2 <='d0;
                done <='b0;sum_price <= 'd0;sum_price_ <= 'd0;
            end
            else if(mouse_x >= 488&& mouse_x <493&&mouse_y>=320&&mouse_y<327&&items[item]>all)begin
               if(number2 == 'd9)begin
                    if(number1 < 'd9) begin 
                        number1 <= number1 +'b1;number2 <= 'd0; 
                        sum_price <= (sum_price + price < 'd9999) ? (sum_price + price) : 'd9999;
                    end
               end
               else begin 
                    number2 <= number2 + 'b1; 
                    sum_price <= (sum_price + price < 'd9999) ? (sum_price + price) : 'd9999;
               end 
               if(done)begin 
                    done <= 'd0;sum_price<='d0;sum_price_<='d0;number1<='d0;number2<='d0;
               end
            end
            
            else if(mouse_x >= 455&& mouse_x <460&&mouse_y>=320&&mouse_y<327)begin
                if(number2 > 'd0) begin 
                    number2 <= number2 -'b1;
                    sum_price <= (sum_price - price >0) ? (sum_price - price) : 'd0;
                end
                else begin
                    if (number1 > 'b0)begin 
                        number2<='d9;number1 <= number1-'b1;
                        sum_price <= (sum_price > price) ? (sum_price - price) : 'd0;
                    end
                end
                if(done)begin 
                    done <= 'd0;sum_price<='d0;sum_price_<='d0;number1<='d0;number2<='d0;
                end
            end
            
            else if(mouse_x>=445 && mouse_x< 505 && mouse_y>= 372 && mouse_y<402)begin
                done <= 'b1;
                if(sum_price_>= sum_price)
                    items[item] <= items[item]-all;
            end
        end
        else if(page&&key_[0]) begin 
            sum_price_ <= sum_price_ + 'd5; 
            if(done)begin 
                done <= 'd0;sum_price<='d0;sum_price_<='d0;number1<='d0;number2<='d0;
           end
        end
        else if(page&&key_[1])begin
          sum_price_ <= sum_price_ + 'd10;
          if(done)begin 
                done <= 'd0;sum_price<='d0;sum_price_<='d0;number1<='d0;number2<='d0;
           end
        end
        else if(page&&key_[2])begin  
            sum_price_ <= sum_price_ + 'd100;
            if(done)begin 
                done <= 'd0;sum_price<='d0;sum_price_<='d0;number1<='d0;number2<='d0;
           end
        end
        if(sum_price>'d9999) sum_price <= 'd9999;
    end
    
    always@(posedge clk) begin
        if(rst_n)begin
            move_x <= 'd0;
            move_y <= 'd0;  
        end 
        else begin
            move_x <= mouse_data[4] ? (~mouse_data[15:8] + 1'b1)>>2 : mouse_data[15:8]>>2;
            move_y <= mouse_data[5] ? (~mouse_data[23:16] + 1'b1)>>2 : mouse_data[23:16]>>2;
        end
    end
    
    always@(posedge clk)begin 
        if(rst_n)begin
            mouse_x <= 'd144;
            mouse_y <= 'd31;  
        end
        else begin
            if(read_en)begin
                if(mouse_data[4])
                    mouse_x <= ((mouse_x -  move_x)>='d144)?(mouse_x -  move_x):'d144 ;
                 else
                    mouse_x <= ((mouse_x +  move_x)<'d768)?(mouse_x +  move_x):'d768;
                if(mouse_data[5])
                    mouse_y <= ((mouse_y +  move_y)<'d495)?(mouse_y +  move_y):'d495 ;
                 else
                    mouse_y <= ((mouse_y -  move_y)>='d31)?(mouse_y -  move_y):'d31;
            end
        end
    end
    
    always@(posedge clk)begin
        start_addra_ <= star_addra;
    end
    
endmodule
