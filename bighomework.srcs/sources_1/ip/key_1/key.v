`timescale 1ns / 1ps



// 消抖模块
module key (
    input wire clk,       // 输入时钟，高频
    input wire button,    // 输入信号（按键）
    output reg debounced_button  // 消抖后的输出信号
);
    reg [31:0] delay_counter = 0;   // 延时计数器
    reg [1:0] state = 2'b00;        // 消抖状态机

    parameter DELAY_MAX = 1000000;   // 延时计数器最大值，这个使得延时可计数20ms

    always @(posedge clk) begin
        case (state)
            2'b00: begin
                if (button == 1) begin
                    delay_counter <= 0;   // 检测到按键按下，重置延时计数器
                    state <= 2'b01;       // 切换到下一个状态
                    end
                else  debounced_button <= 0;   // 保持输出信号为0
            end
            2'b01: begin
                if (button == 1) begin
                    if (delay_counter < DELAY_MAX) begin
                        delay_counter <= delay_counter + 1;   // 延时计数器递增
                    end else begin
                        debounced_button <= 1;   // 延时结束，更新输出信号为1
                        state <= 2'b10;          // 切换到下一个状态
                    end
                  end
                else begin
                    delay_counter <= 0;   // 按键抬起，重置延时计数器
                    state <= 2'b00;       // 切换到初始状态
                end
            end
            2'b10:if(~button) state <= 2'b00;   // 按键抬起，切换到初始状态
                  else state <= 2'b10; 
                  
            default: begin
                state <= 2'b00;   // 默认初始状态
            end
        endcase
    end
endmodule
