`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/21 14:10:10
// Design Name: 
// Module Name: choose_color
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module choose_color(
    input clk,
    input [7:0]mouse_addra,
    input [13:0]font_addra,
    input [17:0]image_addra,
    input [20:0]start_addra,
    input       page,
    output reg [11:0]mouse_douta_,
    output reg [11:0]image_douta_,
    output reg [11:0]font_douta_
    );
    wire [11:0]mouse_douta;
    wire [11:0]image_douta;
    wire [11:0]image_douta1;
    wire [11:0]font_douta;
    reg  [20:0] real_addra;
    always@(posedge clk) begin
        if(image_addra>30000)
            real_addra <= image_addra;
        else
            real_addra <= image_addra+start_addra;
    end
    blk_mem_gen_0 u0(clk, 'b1, mouse_addra, mouse_douta);
    blk_mem_gen_1 u1(clk, ~page, image_addra, image_douta);
    blk_mem_gen_2 u2(clk, page, real_addra, image_douta1);
    blk_mem_gen_3 u3(clk, page, font_addra, font_douta);
    always @(posedge clk) begin
        mouse_douta_ <= mouse_douta;
        if(!page)
            image_douta_ <= image_douta;
        else begin
            image_douta_ <= image_douta1;
            font_douta_ <= font_douta;
        end
    end
endmodule
