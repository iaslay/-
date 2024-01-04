`timescale 1ns / 1ps
module top(
    input   sys_clk,//全局时钟信号
    input   sys_rst_n, //复位信号
    inout   i_PS2Clk,
    inout   i_PS2Data,
    input   [2:0]key,
    output  [3:0]R,
    output  [3:0]G,
    output  [3:0]B,
    output  O_hs, 
    output  O_vs
   ); 
    wire[7:0] mouse_addra;
    wire[17:0] image_addra;
    wire[20:0] start_addra;
    wire [10:0] mouse_x, mouse_y;
    wire[11:0] mouse_douta, image_douta, font_douta;
    wire EnU1, read_en, page, done,addstate;
    wire [23:0] mouse_data;
    wire  [3:0] number1, number2;
    wire [14:0] sum_price,sum_price_;
    wire [13:0]font_addra;
    wire [5:0] itemstate;
    ps2_init_funcmod U1
       (
         .CLOCK(sys_clk),
         .RESET(sys_rst_n),
         .PS2_CLK(i_PS2Clk), // < top
         .PS2_DAT(i_PS2Data), // < top
         .oEn(EnU1) // > U2
 ); 
    ps2_read_funcmod U2
    (
         .CLOCK(sys_clk),
         .RESET(sys_rst_n),
         .PS2_CLK(i_PS2Clk), // < top
         .PS2_DAT(i_PS2Data), // < top
         .iEn(EnU1),       // < U1
         .oTrig(read_en),
         .oData(mouse_data)   // 
    );   

    mouse_env env(
       .clk(sys_clk),
       .rst_n(sys_rst_n),
       .read_en(read_en),
       .mouse_data(mouse_data),
       .key(key),
       .mouse_x(mouse_x),
       .mouse_y(mouse_y),
       .number1(number1),
       .number2(number2),
       .page(page),
       .done(done),
       .start_addra_(start_addra),
       .sum_price(sum_price),
       .sum_price_(sum_price_),
       .itemstate(itemstate),
       .addstate(addstate)
    );


    choose_color c(
        .clk(sys_clk),
        .mouse_addra(mouse_addra),
        .font_addra(font_addra),
        .image_addra(image_addra),
        .start_addra(start_addra),
        .page(page),
        .mouse_douta_(mouse_douta),
        .image_douta_(image_douta),
        .font_douta_(font_douta)
    );   
    
    show s(
           .clk(sys_clk),
           .rst_n(sys_rst_n),
           .douta(image_douta),
           .mouse_douta(mouse_douta),
           .font_douta(font_douta),
           .mouse_x(mouse_x),
           .mouse_y(mouse_y),
           .read_en(read_en),
           .page(page),
           .done(done),
           .number1(number1),
           .number2(number2),
           .sum_price1(sum_price),
           .sum_price2(sum_price_),
           .itemstate(itemstate),
           .addstate(addstate),
           .O_red(R),
           .O_green(G),
           .O_blue(B),
           .hs(O_hs),
           .vs(O_vs),
           .mouse_R_rom_addr(mouse_addra),
           .image_R_rom_addr(image_addra),
           .font_addra(font_addra)
        );
        
    
endmodule
