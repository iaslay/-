`timescale 1ns / 1ps

module show(
    input                   clk, // 系统100MHz时钟
    input                   rst_n, // 系统复位
    input          [11:0]   douta, //颜色
    input          [11:0]   mouse_douta,
    input          [11:0]   font_douta,
    input          [9:0]    mouse_x,
    input          [9:0]    mouse_y,
    input                   read_en,
    input                   page,
    input                   done,
    input                   [3:0]number1,
    input                   [3:0]number2,
    input                   [14:0]sum_price1,
    input                   [14:0]sum_price2,
    input                   [5:0] itemstate,
    input                   addstate,
    output   reg   [3:0]    O_red, // VGA红色分量
    output   reg   [3:0]    O_green, // VGA绿色分量
    output   reg   [3:0]    O_blue, // VGA蓝色分量
    output   reg            hs, // VGA行同步信号
    output   reg            vs,  // VGA场同步信号
    output     [8:0] mouse_R_rom_addr,
    output     [17:0]image_R_rom_addr,
    output     [13:0]font_addra
    );
     integer cnth = 0;
     integer cntv = 0;
     reg [8:0] R_rom_addr_ = 0;
     reg [17:0] I_R_rom_addr_ = 0;
     reg [13:0] font_R_rom_addr_ = 0;
     reg [1:0]  counter_div4;
     reg [5:0]  itemstate_;
     reg div4_o_r, page_='b0, done_ = 'b0;
     reg [9:0] mouse_x_, mouse_y_;
     wire[34:0] nums [0:9], ops[0:1];
     reg[4:0]  sum1[0:3],sum2[0:3], sum3[0:3];
     reg[6:0]  nums_count [0:15];
     reg [3:0] number1_ = 4'd0, number2_ = 4'd1;
     reg flag = 'b1, addstate_='b1;
     wire[14:0] sum_price3;
     wire Flashing = done && sum_price2 >= sum_price1;
     assign sum_price3 = sum_price2 >= sum_price1 ? sum_price2 - sum_price1:sum_price2;
     assign nums[0] = 35'b11111100011000110001100011000111111;
     assign nums[1] = 35'b00100001000010000100001000010000100;
     assign nums[2] = 35'b11111000010000111111100001000011111;
     assign nums[3] = 35'b11111000010000111111000010000111111;
     assign nums[4] = 35'b10001100011000111111000010000100001;
     assign nums[5] = 35'b11111100001000011111000010000111111;
     assign nums[6] = 35'b10000100001000011111100011000111111;
     assign nums[7] = 35'b11111000010000100001000010000100001;
     assign nums[8] = 35'b11111100011000111111100011000111111;
     assign nums[9] = 35'b11111100011000111111000010000100001;
     assign ops[0]  = 35'b00000000000000011111000000000000000;
     assign ops[1]  = 35'b00100001000010011111001000010000100;
     
       always @(posedge clk)begin
          if(rst_n) begin
            counter_div4 <= 0;
            div4_o_r <= 0;
         end
          else begin
            if(counter_div4 <= 0)begin
              counter_div4 <= 'b1;
              div4_o_r <= div4_o_r;
           end
           else if(counter_div4 <='b1) begin
              counter_div4 <= 0;
              div4_o_r <=~div4_o_r;
            end   
         end
     end
     
       always@(posedge div4_o_r)begin
             if(rst_n) begin
               cnth <=0;
               cntv <= 0;
            end
            if (cnth==800)
            begin
                cnth <=0;
                cntv <= cntv==525?0:cntv+1; 
            end
            else cnth <= cnth+1;
         end
         
       always@(posedge clk or negedge rst_n)
            begin
                    if(rst_n)begin
                        hs<=0;
                    end
                    else if(cnth==95)begin
                        hs<=1;
                    end
                    else if(cnth==799)begin
                        hs<=0;
                    end
             end  
             
       always@(posedge clk or negedge rst_n) begin
               if(rst_n)begin
                    vs<=0;
               end
               else if(cnth==799 && cntv==1)begin
                    vs<=1;
               end
               else if(cnth==799 && cntv== 520)begin
                    vs<=0;
               end
             end
        
       always@(posedge div4_o_r)begin
           if(hs&&vs) begin
              if(cnth>=144 && cnth< 784 && cntv>= 31 && cntv<511 ) begin
                     if (!page_) begin
                         if((cnth>=284 && cnth< 334 && cntv>= 41 && cntv<141)||
                            (cnth>=434 && cnth< 484 && cntv>= 41 && cntv<141)||
                            (cnth>=584 && cnth< 634 && cntv>= 41 && cntv<141)||
                            
                            (cnth>=297 && cnth< 322 && cntv>= 166 && cntv<191)||
                            (cnth>=447 && cnth< 472 && cntv>= 166 && cntv<191)||
                            (cnth>=597 && cnth< 622 && cntv>= 166 && cntv<191)||
                            
                            (cnth>=284 && cnth< 334 && cntv>= 216 && cntv<241)||
                            (cnth>=434 && cnth< 484 && cntv>= 216 && cntv<241)||
                            (cnth>=584 && cnth< 634 && cntv>= 216 && cntv<241)||
                            
                            (cnth>=284 && cnth< 334 && cntv>= 301 && cntv<401)||
                            (cnth>=434 && cnth< 484 && cntv>= 301 && cntv<401)||
                            (cnth>=584 && cnth< 634 && cntv>= 301 && cntv<401)||
                           
                            (cnth>=297 && cnth< 322 && cntv>= 426 && cntv<451)||
                            (cnth>=447 && cnth< 472 && cntv>= 426 && cntv<451)||
                            (cnth>=597 && cnth< 622 && cntv>= 426 && cntv<451)||
                            
                            (cnth>=284 && cnth< 334 && cntv>= 476 && cntv<501)||
                            (cnth>=434 && cnth< 484 && cntv>= 476 && cntv<501)||
                            (cnth>=584 && cnth< 634 && cntv>= 476 && cntv<501)
                            )begin //图像1
                                O_red   <= douta[11:8];
                                O_green <= douta[8:4];
                                O_blue  <= douta[3:0];
                                if(!itemstate_[0]&&douta[11:8]!=4'b1111&&(cnth>=284 && cnth< 334 && cntv>= 216 && cntv<241))begin
                                    O_red   <= 4'b1111; O_green <= 4'b0000; O_blue  <= 4'b0000;
                                end
                                else if(!itemstate_[1]&&douta[11:8]!=4'b1111&&(cnth>=434 && cnth< 484 && cntv>= 216 && cntv<241))begin
                                    O_red   <= 4'b1111; O_green <= 4'b0000; O_blue  <= 4'b0000;
                                end
                                else if(!itemstate_[2]&&douta[11:8]!=4'b1111&&(cnth>=584 && cnth< 634 && cntv>= 216 && cntv<241))begin
                                    O_red   <= 4'b1111; O_green <= 4'b0000; O_blue  <= 4'b0000;
                                end
                                else if(!itemstate_[3]&&douta[11:8]!=4'b1111&&(cnth>=284 && cnth< 334 && cntv>= 476 && cntv<501))begin
                                    O_red   <= 4'b1111; O_green <= 4'b0000; O_blue  <= 4'b0000;
                                end
                                else if(!itemstate_[4]&&douta[11:8]!=4'b1111&&(cnth>=434 && cnth< 484 && cntv>= 476 && cntv<501))begin
                                    O_red   <= 4'b1111; O_green <= 4'b0000; O_blue  <= 4'b0000;
                                end
                                else if(!itemstate_[5]&&douta[11:8]!=4'b1111&&(cnth>=584 && cnth< 634 && cntv>= 476 && cntv<501))begin
                                    O_red   <= 4'b1111; O_green <= 4'b0000; O_blue  <= 4'b0000;
                                end
                                I_R_rom_addr_ <= I_R_rom_addr_ + 'b1;  
                                     
                         end
                         else begin
                                O_red   <= 4'b1111;
                                O_green <= 4'b1111;
                                O_blue  <= 4'b1111;
                         end
                     end
                     
                     else begin
                         if(cnth>=450 && cnth< 500 && cntv>= 200 && cntv<300)begin
                                if(flag) begin
                                    O_red   <= douta[11:8];O_green <= douta[8:4];O_blue  <= douta[3:0];
                                end
                                else begin
                                     O_red   <= 4'b1111;O_green <= 4'b1111;O_blue  <= 4'b1111;
                                 end 
                                 if(cnth == 'd499 && cntv=='d299) I_R_rom_addr_ <= 'd30000;
                                 else I_R_rom_addr_ <= I_R_rom_addr_ + 'b1;
                         end
                         else if(cnth>=650 && cnth< 700 && cntv>= 430 && cntv<480)begin
                            O_red   <= douta[11:8];
                            O_green <= douta[8:4];
                            O_blue  <= douta[3:0];
                            I_R_rom_addr_ <= I_R_rom_addr_ + 'b1;
                         end
                         
                         else if(cnth>=468&&cnth<473 && cntv>=320&&cntv<327)begin
                            if(nums[number1_][nums_count[0]] == 'b0)begin
                                 O_red   <= 4'b1111;O_green <= 4'b1111;O_blue  <= 4'b1111;
                            end
                            else begin
                                 O_red   <= 4'b0000;O_green <= 4'b0000;O_blue  <= 4'b0000;
                            end 
                                 nums_count[0] <= nums_count[0] - 'b1;
                         end
                         else if(cnth>=455&&cnth<460 && cntv>=320&&cntv<327)begin
                            if(ops[0][nums_count[2]] == 'b0)begin
                               O_red   <= 4'b1111;O_green <= 4'b1111;O_blue  <= 4'b1111;
                             end
                             else begin
                               O_red   <= 4'b0000;O_green <= 4'b0000;O_blue  <= 4'b1111;
                             end 
                               nums_count[2] <= nums_count[2] + 'b1;
                         end
                         else if(cnth>=488&&cnth<493 && cntv>=320&&cntv<327)begin
                             if(ops[1][nums_count[3]] == 'b0)begin
                                O_red   <= 4'b1111;O_green <= 4'b1111;O_blue  <= 4'b1111;
                              end
                              else begin
                                  if(addstate_)begin  
                                        O_red   <= 4'b0000;O_green <= 4'b0000;O_blue  <= 4'b1111;
                                   end
                                   else begin
                                        O_red   <= 4'b1111;O_green <= 4'b0000;O_blue  <= 4'b0000;
                                   end
                              end 
                                nums_count[3] <= nums_count[3] + 'b1;
                          end
                         else if(cnth>=475&&cnth<480 && cntv>=320&&cntv<327)begin
                            if(nums[number2_][nums_count[1]] == 'b0)begin
                              O_red   <= 4'b1111;O_green <= 4'b1111;O_blue  <= 4'b1111;
                            end
                            else begin
                              O_red   <= 4'b0000;O_green <= 4'b0000;O_blue  <= 4'b0000;
                            end 
                              nums_count[1] <= nums_count[1] - 'b1;
                         end
                         else if((cnth>=400&&cnth<550 && cntv>=347&&cntv<367)||
                                (cnth>=445 && cnth< 505 && cntv>= 372 && cntv<402)||
                                (done_&&cnth>=415 && cnth< 535 && cntv>= 422 && cntv<442)) begin
                                    O_red   <= font_douta[11:8];
                                    O_green <= font_douta[8:4];
                                    O_blue  <= font_douta[3:0];
                                    if(cnth == 504&& cntv==401 && sum_price2 < sum_price1)
                                        font_R_rom_addr_ <= font_R_rom_addr_+'d2400;
                                     else   
                                        font_R_rom_addr_ <=  font_R_rom_addr_ +'b1;
                         end
                         else begin
                             O_red   <= 4'b1111;
                             O_green <= 4'b1111;
                             O_blue  <= 4'b1111;
                         end
                          if(cnth>=418&&cnth<423 && cntv>=353&&cntv<360)begin
                                if(nums[sum1[0]][nums_count[4]] == 'b0)begin
                                 O_red   <= 4'b1111;O_green <= 4'b1111;O_blue  <= 4'b1111;
                               end
                               else begin
                                 O_red   <= 4'b0000;O_green <= 4'b0000;O_blue  <= 4'b0000;
                               end 
                                 nums_count[4] <= nums_count[4] - 'b1;
                           end
                           else if(cnth>=425&&cnth<430 && cntv>=353&&cntv<360)begin
                                if(nums[sum1[1]][nums_count[5]] == 'b0)begin
                                    O_red   <= 4'b1111;O_green <= 4'b1111;O_blue  <= 4'b1111;
                                  end
                                  else begin
                                    O_red   <= 4'b0000;O_green <= 4'b0000;O_blue  <= 4'b0000;
                                  end 
                                    nums_count[5] <= nums_count[5] - 'b1;
                           end
                           else if(cnth>=432&&cnth<437 && cntv>=353&&cntv<360)begin
                               if(nums[sum1[2]][nums_count[6]] == 'b0)begin
                                   O_red   <= 4'b1111;O_green <= 4'b1111;O_blue  <= 4'b1111;
                                 end
                                 else begin
                                   O_red  <= 4'b0000;O_green <= 4'b0000;O_blue  <= 4'b0000;
                                 end 
                                   nums_count[6] <= nums_count[6] - 'b1;
                          end
                          else if(cnth==439&&cntv==359)begin
                            O_red  <= 4'b0000;O_green <= 4'b0000;O_blue  <= 4'b0000;
                          end
                          else if(cnth>=441&&cnth<446 && cntv>=353&&cntv<360)begin
                              if(nums[sum1[3]][nums_count[7]] == 'b0)begin
                                  O_red   <= 4'b1111;O_green <= 4'b1111;O_blue  <= 4'b1111;
                                end
                                else begin
                                  O_red   <= 4'b0000;O_green <= 4'b0000;O_blue  <= 4'b0000;
                                end 
                                  nums_count[7] <= nums_count[7] - 'b1;
                         end
                         else if(cnth>=511&&cnth<516 && cntv>=353&&cntv<360)begin
                            if(nums[sum2[0]][nums_count[8]] == 'b0)begin
                                   O_red   <= 4'b1111;O_green <= 4'b1111;O_blue  <= 4'b1111;
                                 end
                                 else begin
                                   O_red   <= 4'b0000;O_green <= 4'b0000;O_blue  <= 4'b0000;
                                 end 
                                   nums_count[8] <= nums_count[8] - 'b1;
                        end
                        else if(cnth>=518&&cnth<523 && cntv>=353&&cntv<360)begin
                        if(nums[sum2[1]][nums_count[9]] == 'b0)begin
                               O_red   <= 4'b1111;O_green <= 4'b1111;O_blue  <= 4'b1111;
                             end
                             else begin
                               O_red   <= 4'b0000;O_green <= 4'b0000;O_blue  <= 4'b0000;
                             end 
                               nums_count[9] <= nums_count[9] - 'b1;
                        end
                        else if(cnth>=525&&cnth<530 && cntv>=353&&cntv<360)begin
                            if(nums[sum2[2]][nums_count[10]] == 'b0)begin
                                   O_red   <= 4'b1111;O_green <= 4'b1111;O_blue  <= 4'b1111;
                                 end
                                 else begin
                                   O_red   <= 4'b0000;O_green <= 4'b0000;O_blue  <= 4'b0000;
                                 end 
                                   nums_count[10] <= nums_count[10] - 'b1;
                        end
                        else if(cnth==532&&cntv==359)begin
                            O_red  <= 4'b0000;O_green <= 4'b0000;O_blue  <= 4'b0000;
                        end
                       else if(cnth>=534&&cnth<539 && cntv>=353&&cntv<360)begin
                            if(nums[sum2[3]][nums_count[11]] == 'b0)begin
                                   O_red   <= 4'b1111;O_green <= 4'b1111;O_blue  <= 4'b1111;
                                 end
                                 else begin
                                   O_red   <= 4'b0000;O_green <= 4'b0000;O_blue  <= 4'b0000;
                                 end 
                                   nums_count[11] <= nums_count[11] - 'b1;
                        end
                        else if(done_&&cnth>=490&&cnth<495 && cntv>=427&&cntv<434)begin
                            if(nums[sum3[0]][nums_count[12]] == 'b0)begin
                                   O_red   <= 4'b1111;O_green <= 4'b1111;O_blue  <= 4'b1111;
                                 end
                                 else begin
                                   O_red   <= 4'b0000;O_green <= 4'b0000;O_blue  <= 4'b0000;
                                 end 
                                   nums_count[12] <= nums_count[12] - 'b1;
                        end
                        else if(done_&&cnth>=497&&cnth<502 && cntv>=427&&cntv<434)begin
                        if(nums[sum3[1]][nums_count[13]] == 'b0)begin
                               O_red   <= 4'b1111;O_green <= 4'b1111;O_blue  <= 4'b1111;
                             end
                             else begin
                               O_red   <= 4'b0000;O_green <= 4'b0000;O_blue  <= 4'b0000;
                             end 
                               nums_count[13] <= nums_count[13] - 'b1;
                        end
                        else if(done_&&cnth>=504&&cnth<509 && cntv>=427&&cntv<434)begin
                            if(nums[sum3[2]][nums_count[14]] == 'b0)begin
                                   O_red   <= 4'b1111;O_green <= 4'b1111;O_blue  <= 4'b1111;
                                 end
                                 else begin
                                   O_red   <= 4'b0000;O_green <= 4'b0000;O_blue  <= 4'b0000;
                                 end 
                                   nums_count[14] <= nums_count[14] - 'b1;
                        end
                        else if(done_&&cnth==511&&cntv==432)begin
                            O_red  <= 4'b0000;O_green <= 4'b0000;O_blue  <= 4'b0000;
                        end
                       else if(done_&&cnth>=513&&cnth<518 && cntv>=427&&cntv<434)begin
                            if(nums[sum3[3]][nums_count[15]] == 'b0)begin
                                   O_red   <= 4'b1111;O_green <= 4'b1111;O_blue  <= 4'b1111;
                                 end
                                 else begin
                                   O_red   <= 4'b0000;O_green <= 4'b0000;O_blue  <= 4'b0000;
                                 end 
                                   nums_count[15] <= nums_count[15] - 'b1;
                        end
                     end
                        
                     
                     if(cnth >= mouse_x_ && cnth<mouse_x_+'d16 && cntv >= mouse_y_ && cntv < mouse_y_+'d16) begin
                        if(mouse_douta[3] =='b1)begin
                            O_red   <= mouse_douta[11:8];
                            O_green <= mouse_douta[8:4];
                            O_blue  <= mouse_douta[3:0];
                        end
                        R_rom_addr_ <=  R_rom_addr_  +  9'd1 ;
                        
                     end 
               end      
               else begin
                   O_red       <=  4'b0000      ;
                   O_green     <=  4'b0000      ;
                   O_blue      <=  4'b0000      ;
                   if(cnth==784&&cntv==511)begin
                       mouse_x_ <= mouse_x;
                       mouse_y_ <= mouse_y; 
                       R_rom_addr_ <= 9'd0;
                       I_R_rom_addr_ <= 18'd0;
                       font_R_rom_addr_ <= 14'd0;
                       page_ <= page;
                       nums_count[0] <= 7'd34;nums_count[1] <= 7'd34;
                       nums_count[4] <= 7'd34;nums_count[5] <= 7'd34;
                       nums_count[6] <= 7'd34;nums_count[7] <= 7'd34;
                       nums_count[8] <= 7'd34;nums_count[9] <= 7'd34;
                       nums_count[10] <= 7'd34;nums_count[11] <= 7'd34;
                       nums_count[12] <= 7'd34;nums_count[13] <= 7'd34;
                       nums_count[14] <= 7'd34;nums_count[15] <= 7'd34;
                       nums_count[2] <= 7'd0;nums_count[3] <= 7'd0;
                       number1_ <= number1;number2_ <= number2;
                       sum1[3] <= sum_price1%'d10;sum1[2] <= (sum_price1/10)%'d10;
                       sum1[1] <= (sum_price1/100)%'d10;sum1[0] <= (sum_price1/1000)%'d10;
                       sum2[3] <= sum_price2%'d10;sum2[2] <= (sum_price2/10)%'d10;
                       sum2[1] <= (sum_price2/100)%'d10;sum2[0] <= (sum_price2/1000)%'d10;
                       sum3[3] <= sum_price3%'d10;sum3[2] <= (sum_price3/10)%'d10;
                       sum3[1] <= (sum_price3/100)%'d10;sum3[0] <= (sum_price3/1000)%'d10;
                       done_ <= done;addstate_ <= addstate;itemstate_ <= itemstate;
                       if(Flashing) flag <= ~flag;
                       else flag <= 'b1;
                   end     
               end   
            end
      end
      
    assign mouse_R_rom_addr = R_rom_addr_;   
    assign image_R_rom_addr = I_R_rom_addr_;
    assign font_addra = font_R_rom_addr_;
endmodule
